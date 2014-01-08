From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 4/6] internal: add a selector for parsing ops
Date: Wed, 8 Jan 2014 14:36:55 +0100
Message-ID: <20140108133655.GA25887@localhost>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114732.12841.11957.stgit@nfdev.cica.es>
 <20140107232919.GD16894@localhost>
 <CAOkSjBiOw10oK4stjz48yqF63+Y_8-hOoH-uUh4FqO2e7P2DVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbaAHNhI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:37:08 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiOw10oK4stjz48yqF63+Y_8-hOoH-uUh4FqO2e7P2DVA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 08, 2014 at 01:31:44PM +0100, Arturo Borrero Gonzalez wrote:
> On 8 January 2014 00:29, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > You should pass a callback function instead, eg.
> >
> > static int nft_chain_json_parse(struct nft_chain *c, const char *json,
> >                                 struct nft_parse_err *err,
> >                                 json_t *(*jsonbuilder)(const void *input_data,
> >                                                        const char *treename,
> >                                                        struct nft_parse_err *e))
> 
> Ok.
> 
> > But I don't understand yet what you save (in terms of lines of code)
> > by using this aproach.
> 
> I avoid doing something like:
> 
> nft_*_parse() {
> switch (type)
>  if XML return xml_parse()
>  if JSON return json_parse()
> }
> 
> nft_*_parse_file() {
> switch (type)
>  if XML return xml_parse_file()
>  if JSON return json_parse_file()
> }
> 
> We double the format switch, and also two functions per format are
> needed to do build and parsing.
> Total = 6 functions heavily duplicating code.
> 
> With my approach, we have 1 function that decides which format to
> parse, and a one function per format to build and do parsing.
> Total = 3 functions, no duplicate code.

I guess this is saving you code, but I think this abstraction needs to
be refined, your functions:

* nft_mxml_do_build_tree
* nft_mxml_do_build_tree_file

look almost the same, only difference is mxmlLoadString / mxmlLoadFile.

I really think you can save more code and make this look better if you
rework the internal nft_*_json_parse functions to receive the xml/json
trees, eg.

static int nft_set_json_parse(struct nft_set *s, json_t tree
                              struct nft_parse_err *err)
{
        ...
}

So you nft_set_do_parse() creates the tree and pass it to it.

You can also add an enum like:

enum {
        NFT_PARSE_BUFFER,
        NFT_PARSE_FILE,
};

json_t *nft_json_build_tree(uint32_t type, void *data)
{
        json_t *tree;

        switch (type) {
        case NFT_PARSE_BUFFER:
                tree = nft_json_build_tree(data, ...);
                break;
        case NFT_PARSE_FILE:
                tree = nft_json_build_tree_file(data, ...);
                break;
        }

        return tree;
}

that you can pass this enum to nft_set_do_parse() to indicate how the
tree need to be build, eg.

statiuc int nft_set_do_parse(..., uint32_t format)
{
        switch (format) {
        ...
        case NFT_PARSE_JSON:
                tree = nft_json_build_tree(type, data);
                break;
        ...
        }
        ...
}

Where data is the file descriptor / buffer area.
