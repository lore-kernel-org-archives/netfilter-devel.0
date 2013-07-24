From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-arptables PATCH v2 1/5] nft: add builtin_table pointer
Date: Wed, 24 Jul 2013 10:50:50 +0200
Message-ID: <20130724085050.GA16434@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
 <20130723161200.10040.19762.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3GXIu5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:50:57 -0400
Content-Disposition: inline
In-Reply-To: <20130723161200.10040.19762.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

Several comments below.

On Tue, Jul 23, 2013 at 06:12:11PM +0200, Giuseppe Longo wrote:
>

missing patch description, a couple of lines would be just fine: You
have to explain why you need this.

Others may be trying to follow nftables development, and this empty
description does not help.

>
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/nft.c                |   22 +++-------------------
>  iptables/nft.h                |   22 +++++++++++++++++++++-
>  iptables/xtables-config.c     |    4 +++-
>  iptables/xtables-restore.c    |    5 +++--
>  iptables/xtables-save.c       |    5 +++--
>  iptables/xtables-standalone.c |    4 +++-
>  iptables/xtables.c            |    2 ++
>  7 files changed, 38 insertions(+), 26 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 4d6a7a3..f6dccff 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -80,24 +80,7 @@ static int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
>  	return 0;
>  }
>  
> -#define FILTER		0
> -#define MANGLE		1
> -#define RAW		2
> -#define SECURITY	3
> -#define NAT		4
> -#define TABLES_MAX	5
> -
> -struct builtin_chain {
> -	const char *name;
> -	const char *type;
> -	uint32_t prio;
> -	uint32_t hook;
> -};
> -
> -static struct builtin_table {
> -	const char *name;
> -	struct builtin_chain chains[NF_INET_NUMHOOKS];
> -} tables[TABLES_MAX] = {
> +struct builtin_table tables[TABLES_MAX] = {

please, rename 'tables' to 'xtables_ipv4' in this patch.

>  	[RAW] = {
>  		.name	= "raw",
>  		.chains = {
> @@ -389,7 +372,7 @@ static bool nft_chain_builtin(struct nft_chain *c)
>  	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
>  }
>  
> -int nft_init(struct nft_handle *h)
> +int nft_init(struct nft_handle *h, struct builtin_table *t)
>  {
>  	h->nl = mnl_socket_open(NETLINK_NETFILTER);
>  	if (h->nl == NULL) {
> @@ -402,6 +385,7 @@ int nft_init(struct nft_handle *h)
>  		return -1;
>  	}
>  	h->portid = mnl_socket_get_portid(h->nl);
> +	h->tables = t;
>  
>  	return 0;
>  }
> diff --git a/iptables/nft.h b/iptables/nft.h
> index 7a6351b..e4d177e 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -4,6 +4,25 @@
>  #include "xshared.h"
>  #include "nft-shared.h"
>  
> +#define FILTER		0
> +#define MANGLE		1
> +#define RAW		2
> +#define SECURITY	3
> +#define NAT		4
> +#define TABLES_MAX	5
> +
> +struct builtin_chain {
> +	const char *name;
> +	const char *type;
> +	uint32_t prio;
> +	uint32_t hook;
> +};
> +
> +struct builtin_table {
> +	const char *name;
> +	struct builtin_chain chains[NF_INET_NUMHOOKS];
> +};
> +
>  struct nft_handle {
>  	int			family;
>  	struct mnl_socket	*nl;
> @@ -11,9 +30,10 @@ struct nft_handle {
>  	uint32_t		seq;
>  	bool			commit;
>  	struct nft_family_ops	*ops;
> +	struct builtin_table	*tables;
>  };
>  
> -int nft_init(struct nft_handle *h);
> +int nft_init(struct nft_handle *h, struct builtin_table *t);
>  void nft_fini(struct nft_handle *h);
>  
>  /*
> diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
> index 515b18b..bb87886 100644
> --- a/iptables/xtables-config.c
> +++ b/iptables/xtables-config.c
> @@ -19,6 +19,8 @@
>  #include "xtables-multi.h"
>  #include "nft.h"
>  
> +extern struct builtin_table tables[TABLES_MAX];
> +
>  int xtables_config_main(int argc, char *argv[])
>  {
>  	struct nft_handle h = {
> @@ -35,7 +37,7 @@ int xtables_config_main(int argc, char *argv[])
>  	else
>  		filename = argv[1];
>  
> -	if (nft_init(&h) < 0) {
> +	if (nft_init(&h, tables) < 0) {
>                  fprintf(stderr, "Failed to initialize nft: %s\n",
>  			strerror(errno));
>  		return EXIT_FAILURE;
> diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
> index 8469ba1..b894173 100644
> --- a/iptables/xtables-restore.c
> +++ b/iptables/xtables-restore.c
> @@ -24,6 +24,8 @@
>  #define DEBUGP(x, args...)
>  #endif
>  
> +extern struct builtin_table tables[TABLES_MAX];

You can move this definition to nft.h, as it is again required a bit
below.

> +
>  static int binary = 0, counters = 0, verbose = 0, noflush = 0;
>  
>  /* Keeping track of external matches and targets.  */
> @@ -177,7 +179,6 @@ xtables_restore_main(int argc, char *argv[])
>  	const struct xtc_ops *ops = &iptc_ops;
>  	struct nft_chain_list *chain_list;
>  	struct nft_chain *chain_obj;
> -

I still want that empty line there to separated variable declaration
and function body, please get it back.

>  	line = 0;
>  
>  	xtables_globals.program_name = "xtables-restore";
> @@ -193,7 +194,7 @@ xtables_restore_main(int argc, char *argv[])
>  	init_extensions4();
>  #endif
>  
> -	if (nft_init(&h) < 0) {
> +	if (nft_init(&h, tables) < 0) {
>  		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
>  				xtables_globals.program_name,
>  				xtables_globals.program_version,
> diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
> index 41ceaf5..8a5c991 100644
> --- a/iptables/xtables-save.c
> +++ b/iptables/xtables-save.c
> @@ -25,6 +25,8 @@
>  #include <dlfcn.h>
>  #endif
>  
> +extern struct builtin_table tables[TABLES_MAX];
> +
>  static bool show_counters = false;
>  
>  static const struct option options[] = {
> @@ -82,7 +84,6 @@ xtables_save_main(int argc, char *argv[])
>  		.family	= AF_INET,	/* default to AF_INET */
>  	};
>  	int c;
> -

Same thing here.

>  	xtables_globals.program_name = "xtables-save";
>  	/* XXX xtables_init_all does several things we don't want */
>  	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
> @@ -96,7 +97,7 @@ xtables_save_main(int argc, char *argv[])
>  	init_extensions();
>  	init_extensions4();
>  #endif
> -	if (nft_init(&h) < 0) {
> +	if (nft_init(&h, tables) < 0) {
>  		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
>  				xtables_globals.program_name,
>  				xtables_globals.program_version,
> diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
> index 3f8b981..bd95ff8 100644
> --- a/iptables/xtables-standalone.c
> +++ b/iptables/xtables-standalone.c
> @@ -39,6 +39,8 @@
>  #include "xtables-multi.h"
>  #include "nft.h"
>  
> +extern struct builtin_table tables[TABLES_MAX];
> +
>  int
>  xtables_main(int argc, char *argv[])
>  {
> @@ -61,7 +63,7 @@ xtables_main(int argc, char *argv[])
>  	init_extensions4();
>  #endif
>  
> -	if (nft_init(&h) < 0) {
> +	if (nft_init(&h, tables) < 0) {
>  		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
>  				xtables_globals.program_name,
>  				xtables_globals.program_version,
> diff --git a/iptables/xtables.c b/iptables/xtables.c
> index c314b37..65e4882 100644
> --- a/iptables/xtables.c
> +++ b/iptables/xtables.c
> @@ -50,6 +50,8 @@
>  #define FALSE 0
>  #endif
>  
> +extern struct builtin_table tables[TABLES_MAX];
> +
>  #define NUMBER_OF_CMD	16
>  static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
>  				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
