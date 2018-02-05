class PokemonController < ApplicationController
  def show
    pokemon_response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{params[:id]}")
    pokemon_body = JSON.parse(pokemon_response.body)

    pokemon = []
    pokemon << {name: pokemon_body["name"]}
    pokemon << {id: pokemon_body["id"]}
    types = []
    pokemon_body["types"].each {|type|
      types << type["type"]["name"]
    }
    pokemon << {types: types}

    giphy_key = {api_key: "#{ENV['GIPHY_KEY']}"}

    giphy_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?q=#{pokemon_body["name"]}&rating=g", headers: giphy_key)
    giphy_body = JSON.parse(giphy_response.body)

    giphy_url = giphy_body["data"].sample["url"]
    pokemon << {url: giphy_url}
    render json: pokemon
    # respond_to do |format|
    #   format.html
    #   format.json {render json:{pokemon: [pokemon, giphy_url]}}
    # end
  end
end
