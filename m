From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 04/18] libnftables: add context new and free
Date: Fri, 25 Aug 2017 13:22:01 +0200
Message-ID: <1503660121.31357.15.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-5-eric@regit.org> <20170824153016.GA23164@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41748 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755023AbdHYLWE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 07:22:04 -0400
In-Reply-To: <20170824153016.GA23164@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thu, 2017-08-24 at 17:30 +0200, Pablo Neira Ayuso wrote:
> I took over this patch and revamp it, so we can apply this asap.
> 
> Let me know if you have any concern,

I would just add a uint32_t flag to the nft_ctc_new function parameters
so we can later pass information such as "don't handle netlink" or
"handle netlink". But setting the info could also be done in another
function so I let you decide.

++


> Thanks.
> 
> 
> On Sat, Aug 19, 2017 at 05:24:06PM +0200, Eric Leblond wrote:
> > Signed-off-by: Eric Leblond <eric@regit.org>
> > ---
> >  include/nftables.h          |  1 +
> >  include/nftables/nftables.h |  3 +++
> >  src/libnftables.c           | 20 ++++++++++++++++++++
> >  src/main.c                  | 29 ++++++++++++++---------------
> >  4 files changed, 38 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/nftables.h b/include/nftables.h
> > index a457aba..717af37 100644
> > --- a/include/nftables.h
> > +++ b/include/nftables.h
> > @@ -35,6 +35,7 @@ struct output_ctx {
> >  struct nft_ctx {
> >  	struct output_ctx	output;
> >  	bool			check;
> > +	struct mnl_socket	*nf_sock;
> >  };
> >  
> >  struct nft_cache {
> > diff --git a/include/nftables/nftables.h
> > b/include/nftables/nftables.h
> > index 4ba16f0..cfa60fe 100644
> > --- a/include/nftables/nftables.h
> > +++ b/include/nftables/nftables.h
> > @@ -17,4 +17,7 @@
> >  void nft_global_init(void);
> >  void nft_global_deinit(void);
> >  
> > +struct nft_ctx *nft_context_new(void);
> > +void nft_context_free(struct nft_ctx *nft);
> > +
> >  #endif
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index 215179a..6756c0f 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> > @@ -51,3 +51,23 @@ void nft_global_deinit(void)
> >  	realm_table_meta_exit();
> >  	mark_table_exit();
> >  }
> > +
> > +struct nft_ctx *nft_context_new(void)
> > +{
> > +	struct nft_ctx *ctx = NULL;
> > +	ctx = calloc(1, sizeof(struct nft_ctx));
> > +	if (ctx == NULL)
> > +		return NULL;
> > +	ctx->nf_sock = netlink_open_sock();
> > +
> > +	return ctx;
> > +}
> > +
> > +
> > +void nft_context_free(struct nft_ctx *nft)
> > +{
> > +	if (nft == NULL)
> > +		return;
> > +	netlink_close_sock(nft->nf_sock);
> > +	xfree(nft);
> > +}
> > diff --git a/src/main.c b/src/main.c
> > index dde3104..ee5566c 100644
> > --- a/src/main.c
> > +++ b/src/main.c
> > @@ -29,7 +29,6 @@
> >  #include <iface.h>
> >  #include <cli.h>
> >  
> > -static struct nft_ctx nft;
> >  unsigned int max_errors = 10;
> >  #ifdef DEBUG
> >  unsigned int debug_level;
> > @@ -283,13 +282,13 @@ int main(int argc, char * const *argv)
> >  	unsigned int len;
> >  	bool interactive = false;
> >  	int i, val, rc = NFT_EXIT_SUCCESS;
> > -	struct mnl_socket *nf_sock;
> > +	struct nft_ctx *nft;
> >  
> >  	memset(&cache, 0, sizeof(cache));
> >  	init_list_head(&cache.list);
> >  
> >  	nft_global_init();
> > -	nf_sock = netlink_open_sock();
> > +	nft = nft_context_new();
> >  	while (1) {
> >  		val = getopt_long(argc, argv, OPTSTRING, options,
> > NULL);
> >  		if (val == -1)
> > @@ -304,7 +303,7 @@ int main(int argc, char * const *argv)
> >  			       PACKAGE_NAME, PACKAGE_VERSION,
> > RELEASE_NAME);
> >  			exit(NFT_EXIT_SUCCESS);
> >  		case OPT_CHECK:
> > -			nft.check = true;
> > +			nft->check = true;
> >  			break;
> >  		case OPT_FILE:
> >  			filename = optarg;
> > @@ -322,7 +321,7 @@ int main(int argc, char * const *argv)
> >  			include_paths[num_include_paths++] =
> > optarg;
> >  			break;
> >  		case OPT_NUMERIC:
> > -			if (++nft.output.numeric > NUMERIC_ALL) {
> > +			if (++nft->output.numeric > NUMERIC_ALL) {
> >  				fprintf(stderr, "Too many numeric
> > options "
> >  						"used, max. %u\n",
> >  					NUMERIC_ALL);
> > @@ -330,10 +329,10 @@ int main(int argc, char * const *argv)
> >  			}
> >  			break;
> >  		case OPT_STATELESS:
> > -			nft.output.stateless++;
> > +			nft->output.stateless++;
> >  			break;
> >  		case OPT_IP2NAME:
> > -			nft.output.ip2name++;
> > +			nft->output.ip2name++;
> >  			break;
> >  #ifdef DEBUG
> >  		case OPT_DEBUG:
> > @@ -365,10 +364,10 @@ int main(int argc, char * const *argv)
> >  			break;
> >  #endif
> >  		case OPT_HANDLE_OUTPUT:
> > -			nft.output.handle++;
> > +			nft->output.handle++;
> >  			break;
> >  		case OPT_ECHO:
> > -			nft.output.echo++;
> > +			nft->output.echo++;
> >  			break;
> >  		case OPT_INVALID:
> >  			exit(NFT_EXIT_FAILURE);
> > @@ -386,20 +385,20 @@ int main(int argc, char * const *argv)
> >  				strcat(buf, " ");
> >  		}
> >  		strcat(buf, "\n");
> > -		parser_init(nf_sock, &cache, &state, &msgs);
> > +		parser_init(nft->nf_sock, &cache, &state, &msgs);
> >  		scanner = scanner_init(&state);
> >  		scanner_push_buffer(scanner, &indesc_cmdline,
> > buf);
> >  	} else if (filename != NULL) {
> > -		rc = cache_update(nf_sock, &cache, CMD_INVALID,
> > &msgs);
> > +		rc = cache_update(nft->nf_sock, &cache,
> > CMD_INVALID, &msgs);
> >  		if (rc < 0)
> >  			return rc;
> >  
> > -		parser_init(nf_sock, &cache, &state, &msgs);
> > +		parser_init(nft->nf_sock, &cache, &state, &msgs);
> >  		scanner = scanner_init(&state);
> >  		if (scanner_read_file(scanner, filename,
> > &internal_location) < 0)
> >  			goto out;
> >  	} else if (interactive) {
> > -		if (cli_init(&nft, nf_sock, &cache, &state) < 0) {
> > +		if (cli_init(nft, nft->nf_sock, &cache, &state) <
> > 0) {
> >  			fprintf(stderr, "%s: interactive CLI not
> > supported in this build\n",
> >  				argv[0]);
> >  			exit(NFT_EXIT_FAILURE);
> > @@ -410,7 +409,7 @@ int main(int argc, char * const *argv)
> >  		exit(NFT_EXIT_FAILURE);
> >  	}
> >  
> > -	if (nft_run(&nft, nf_sock, &cache, scanner, &state, &msgs)
> > != 0)
> > +	if (nft_run(nft, nft->nf_sock, &cache, scanner, &state,
> > &msgs) != 0)
> >  		rc = NFT_EXIT_FAILURE;
> >  out:
> >  	scanner_destroy(scanner);
> > @@ -418,7 +417,7 @@ out:
> >  	xfree(buf);
> >  	cache_release(&cache);
> >  	iface_cache_release();
> > -	netlink_close_sock(nf_sock);
> > +	nft_context_free(nft);
> >  	nft_global_deinit();
> >  
> >  	return rc;
> > -- 
> > 2.14.1
> > 
-- 
Eric Leblond <eric@regit.org>
