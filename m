From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [xtables-arptables PATCH v2 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Wed, 24 Jul 2013 10:56:49 +0200
Message-ID: <20130724085649.GC16434@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
 <20130723161244.10040.57825.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56156 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab3GXI47 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:56:59 -0400
Content-Disposition: inline
In-Reply-To: <20130723161244.10040.57825.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 23, 2013 at 06:12:47PM +0200, Giuseppe Longo wrote:
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/nft.c                |   33 ++++++++++++---------------------
>  iptables/nft.h                |    2 +-
>  iptables/xtables-config.c     |    5 ++---
>  iptables/xtables-restore.c    |   16 ++++++++--------
>  iptables/xtables-save.c       |   15 ++++++++-------
>  iptables/xtables-standalone.c |   14 +++-----------
>  iptables/xtables.c            |    5 +++++
>  7 files changed, 39 insertions(+), 51 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 07ca0f1..589cba7 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -373,7 +373,8 @@ static bool nft_chain_builtin(struct nft_chain *c)
>  	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
>  }
>  
> -int nft_init(struct nft_handle *h, struct builtin_table *t)
> +int nft_init(struct nft_handle *h, struct builtin_table *t,
> +	     const char *filename)
                         ^^^^^^^^

why do we need this new parameter?

The optional /etc/xtables.conf file should contain the definition for
all the families, that includes IPv4, IPv6, bridge and ARP.

>  {
>  	h->nl = mnl_socket_open(NETLINK_NETFILTER);
>  	if (h->nl == NULL) {
> @@ -388,6 +389,16 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
>  	h->portid = mnl_socket_get_portid(h->nl);
>  	h->tables = t;
>  
> +	/* If built-in chains don't exist for this table, create them */
> +	if (nft_xtables_config_load(h, filename, 0) < 0) {
> +		int i;
> +
> +		if (h->tables != NULL) {
> +			for (i=0; i<TABLES_MAX; i++)
> +				nft_chain_builtin_init(h, h->tables[i].name,
> +						       NULL, NF_ACCEPT);
> +		}
> +	}

I don't see what we get by moving nft_xtables_config_load here.

>  	return 0;
>  }
>  
> @@ -742,10 +753,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
>  	uint16_t flags = NLM_F_ACK|NLM_F_CREATE;
>  	int ret = 1;
>  
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
> -
>  	nft_fn = nft_rule_append;
>  
>  	r = nft_rule_new(h, chain, table, cs);
> @@ -1316,10 +1323,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
>  	struct nft_chain *c;
>  	int ret;
>  
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> -
>  	c = nft_chain_alloc();
>  	if (c == NULL)
>  		return 0;
> @@ -1472,10 +1475,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
>  	uint64_t handle;
>  	int ret;
>  
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> -
>  	/* Find the old chain to be renamed */
>  	c = nft_chain_find(h, table, chain);
>  	if (c == NULL) {
> @@ -2170,10 +2169,6 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
>  	struct nft_rule *r;
>  	uint64_t handle;
>  
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
> -
>  	nft_fn = nft_rule_insert;
>  
>  	list = nft_rule_list_create(h);
> @@ -2521,10 +2516,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
>  	struct nft_chain *c;
>  	bool found = false;
>  
> -	/* If built-in chains don't exist for this table, create them */
> -	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
> -		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> -
>  	list = nft_chain_dump(h);
>  
>  	iter = nft_chain_list_iter_create(list);
> diff --git a/iptables/nft.h b/iptables/nft.h
> index e4d177e..abf0463 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -33,7 +33,7 @@ struct nft_handle {
>  	struct builtin_table	*tables;
>  };
>  
> -int nft_init(struct nft_handle *h, struct builtin_table *t);
> +int nft_init(struct nft_handle *h, struct builtin_table *t, const char *filename);
>  void nft_fini(struct nft_handle *h);
>  
>  /*
> diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
> index bb87886..277e33e 100644
> --- a/iptables/xtables-config.c
> +++ b/iptables/xtables-config.c
> @@ -37,12 +37,11 @@ int xtables_config_main(int argc, char *argv[])
>  	else
>  		filename = argv[1];
>  
> -	if (nft_init(&h, tables) < 0) {
> +	if (nft_init(&h, tables, filename) < 0) {
>                  fprintf(stderr, "Failed to initialize nft: %s\n",
>  			strerror(errno));
>  		return EXIT_FAILURE;
>  	}
>  
> -	return nft_xtables_config_load(&h, filename, NFT_LOAD_VERBOSE) == 0 ?
> -						    EXIT_SUCCESS : EXIT_FAILURE;
> +	return EXIT_SUCCESS;
>  }
> diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
> index b894173..3893734 100644
> --- a/iptables/xtables-restore.c
> +++ b/iptables/xtables-restore.c
> @@ -194,14 +194,6 @@ xtables_restore_main(int argc, char *argv[])
>  	init_extensions4();
>  #endif
>  
> -	if (nft_init(&h, tables) < 0) {
> -		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
> -				xtables_globals.program_name,
> -				xtables_globals.program_version,
> -				strerror(errno));
> -		exit(EXIT_FAILURE);
> -	}
> -
>  	while ((c = getopt_long(argc, argv, "bcvthnM:T:46", options, NULL)) != -1) {
>  		switch (c) {
>  			case 'b':
> @@ -239,6 +231,14 @@ xtables_restore_main(int argc, char *argv[])
>  		}
>  	}
>  
> +        if (nft_init(&h, tables, XTABLES_CONFIG_DEFAULT) < 0) {
> +                fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
> +                                xtables_globals.program_name,
> +                                xtables_globals.program_version,
> +                                strerror(errno));
> +                exit(EXIT_FAILURE);
> +        }
> +
>  	if (optind == argc - 1) {
>  		in = fopen(argv[optind], "re");
>  		if (!in) {
> diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
> index 8a5c991..897e805 100644
> --- a/iptables/xtables-save.c
> +++ b/iptables/xtables-save.c
> @@ -97,13 +97,6 @@ xtables_save_main(int argc, char *argv[])
>  	init_extensions();
>  	init_extensions4();
>  #endif
> -	if (nft_init(&h, tables) < 0) {
> -		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
> -				xtables_globals.program_name,
> -				xtables_globals.program_version,
> -				strerror(errno));
> -		exit(EXIT_FAILURE);
> -	}
>  
>  	while ((c = getopt_long(argc, argv, "bcdt:46", options, NULL)) != -1) {
>  		switch (c) {
> @@ -131,6 +124,14 @@ xtables_save_main(int argc, char *argv[])
>  		}
>  	}
>  
> +        if (nft_init(&h, tables, XTABLES_CONFIG_DEFAULT) < 0) {
> +                fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
> +                                xtables_globals.program_name,
> +                                xtables_globals.program_version,
> +                                strerror(errno));
> +                exit(EXIT_FAILURE);
> +        }
> +
>  	if (optind < argc) {
>  		fprintf(stderr, "Unknown arguments found on commandline\n");
>  		exit(1);
> diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
> index bd95ff8..212b293 100644
> --- a/iptables/xtables-standalone.c
> +++ b/iptables/xtables-standalone.c
> @@ -46,9 +46,9 @@ xtables_main(int argc, char *argv[])
>  {
>  	int ret;
>  	char *table = "filter";
> -	struct nft_handle h;
> -
> -	memset(&h, 0, sizeof(h));
> +	struct nft_handle h = {
> +		.family = AF_INET,
> +	};
>  
>  	xtables_globals.program_name = "xtables";
>  	ret = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
> @@ -63,14 +63,6 @@ xtables_main(int argc, char *argv[])
>  	init_extensions4();
>  #endif
>  
> -	if (nft_init(&h, tables) < 0) {
> -		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
> -				xtables_globals.program_name,
> -				xtables_globals.program_version,
> -				strerror(errno));
> -		exit(EXIT_FAILURE);
> -	}
> -
>  	ret = do_commandx(&h, argc, argv, &table);
>  	if (!ret) {
>  		if (errno == EINVAL) {
> diff --git a/iptables/xtables.c b/iptables/xtables.c
> index 65e4882..d4b8709 100644
> --- a/iptables/xtables.c
> +++ b/iptables/xtables.c
> @@ -1100,6 +1100,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
>  	if (h->ops == NULL)
>  		xtables_error(PARAMETER_PROBLEM, "Unknown family");
>  
> +	if (h->tables == NULL) {
> +                if (nft_init(h, tables, XTABLES_CONFIG_DEFAULT) < 0)
> +                        xtables_error(OTHER_PROBLEM, "Could not initialize nftables layer.");
> +        }
> +
>  	h->ops->post_parse(command, &cs, &args);
>  
>  	if (command == CMD_REPLACE &&
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
