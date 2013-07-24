From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH] xtables: Bootstrap xtables-arptables
 compatible tool for nftables
Date: Wed, 24 Jul 2013 11:21:09 +0300
Message-ID: <51EF8E75.1080302@linux.intel.com>
References: <20130724075808.4219.71684.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab3GXIVN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:21:13 -0400
In-Reply-To: <20130724075808.4219.71684.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

Some issues. You should take into account your previous refactoring patches.
See:

> xtables: Bootstrap xtables-arptables compatible tool for nftables
>
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>   iptables/Makefile.am                    |    4
>   iptables/nft-arptables.c                |  214 ++++
>   iptables/nft-arptables.h                |   95 ++
>   iptables/xtables-arptables-standalone.c |   58 +
>   iptables/xtables-arptables.c            | 1632 +++++++++++++++++++++++++++++++
>   iptables/xtables-multi.c                |    1
>   iptables/xtables-multi.h                |    1
>   7 files changed, 2004 insertions(+), 1 deletions(-)
>   create mode 100644 iptables/nft-arptables.c
>   create mode 100644 iptables/nft-arptables.h
>   create mode 100644 iptables/xtables-arptables-standalone.c
>   create mode 100644 iptables/xtables-arptables.c
>
> diff --git a/iptables/Makefile.am b/iptables/Makefile.am
> index fb26a32..ac9edf6 100644
> --- a/iptables/Makefile.am
> +++ b/iptables/Makefile.am
> @@ -31,7 +31,9 @@ xtables_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
>   xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
>   			 xtables-standalone.c xtables.c nft.c \
>   			 nft-shared.c nft-ipv4.c nft-ipv6.c \
> -			 xtables-config.c xtables-events.c
> +			 xtables-config.c xtables-events.c \
> +			 nft-arptables.c xtables-arptables.c \
> +			 xtables-arptables-standalone.c			
>   xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS}
>   xtables_multi_CFLAGS  += -DENABLE_NFTABLES
>   # yacc and lex generate dirty code
> diff --git a/iptables/nft-arptables.c b/iptables/nft-arptables.c
> new file mode 100644
> index 0000000..ef9dfdd
> --- /dev/null
> +++ b/iptables/nft-arptables.c
> @@ -0,0 +1,214 @@
> +/*
> + * (C) 2013 by Giuseppe Longo <giuseppelng@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <errno.h>
> +
> +#include <linux/netlink.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <linux/netfilter/nf_tables_compat.h>
> +
> +#include <libiptc/libxtc.h>
> +#include <libiptc/xtcshared.h>
> +
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter_ipv4/ip_tables.h>
> +#include <linux/netfilter_ipv6/ip6_tables.h>
> +#include <netinet/ip6.h>
> +
> +#include <libmnl/libmnl.h>
> +#include <libnftables/table.h>
> +#include <libnftables/chain.h>
> +#include <libnftables/rule.h>
> +#include <libnftables/expr.h>
> +
> +#include "nft-arptables.h"
> +#include "xshared.h" /* proto_to_name */
> +#include "nft-shared.h"
> +#include "xtables-config-parser.h"
> +
> +extern struct builtin_table arp_tables[TABLES_MAX] = {

No need of extern keyword here.

> +	[FILTER] = {
> +		.name	= "filter",
> +		.chains = {
> +			{
> +				.name	= "INPUT",
> +				.type	= "filter",
> +				.prio	= 0,	/* NF_IP_PRI_FILTER */
> +				.hook	= NF_INET_LOCAL_IN,
> +			},
> +			{
> +				.name	= "FORWARD",
> +				.type	= "filter",
> +				.prio	= 0,	/* NF_IP_PRI_FILTER */
> +				.hook	= NF_INET_FORWARD,
> +			},
> +			{
> +				.name	= "OUTPUT",
> +				.type	= "filter",
> +				.prio	= 0,	/* NF_IP_PRI_FILTER */
> +				.hook	= NF_INET_LOCAL_OUT,
> +			},
> +		},
> +	},
> +};
> +
> +static int
> +nft_arp_chain_user_add(struct nft_handle *h, const char *chain,

No need of that function. You can use nft_chain_user_add() from nft.c, 
just make it public.
Now that from your previous patches, nft_handle is owning the 
builtin_table pointer.

> +		       const char *table)
> +{
> +	char buf[MNL_SOCKET_BUFFER_SIZE];
> +	struct nlmsghdr *nlh;
> +	struct nft_chain *c;
> +	int ret;
> +
> +	/* If built-in chains don't exist for this table, create them */
> +	if (nft_xtables_config_load(h, ARPTABLES_CONFIG_DEFAULT, 0) < 0)
> +		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> +
> +	nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
> +
> +	c = nft_chain_alloc();
> +	if (c == NULL) {
> +		DEBUGP("cannot allocate chain\n");
> +		return -1;
> +	}
> +
> +	nft_chain_attr_set(c, NFT_CHAIN_ATTR_TABLE, (char *)table);
> +	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)chain);
> +
> +	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
> +                                       NLM_F_ACK|NLM_F_EXCL, h->seq);
> +	nft_chain_nlmsg_build_payload(nlh, c);
> +	nft_chain_free(c);
> +
> +	ret = mnl_talk(h, nlh, NULL, NULL);
> +	if (ret < 0) {
> +		if (errno != EEXIST)
> +			perror("mnl_talk:nft_chain_add");
> +	}
> +
> +	/* the core expects 1 for success and 0 for error */
> +	return ret == 0 ? 1 : 0;
> +}
> +
> +static const char *policy_name[NF_ACCEPT+1] = {
> +	[NF_DROP] = "DROP",
> +	[NF_ACCEPT] = "ACCEPT",
> +};
> +
> +static void
> +print_header(unsigned int format, const char *chain, const char *pol,
> +            const struct xt_counters *counters, bool basechain, uint32_t refs)
> +{
> +	printf("Chain %s", chain);
> +	if (basechain) {
> +		printf(" (policy %s", pol);
> +		if (!(format & FMT_NOCOUNTS)) {
> +			fputc(' ', stdout);
> +			print_num(counters->pcnt, (format|FMT_NOTABLE));
> +			fputs("packets, ", stdout);
> +			print_num(counters->bcnt, (format|FMT_NOTABLE));
> +			fputs("bytes", stdout);
> +		}
> +		printf(")\n");
> +	} else {
> +		printf(" (%u references)\n", refs);
> +	}
> +
> +	if (format & FMT_LINENUMBERS)
> +		printf(FMT("%-4s ", "%s "), "num");
> +	if (!(format & FMT_NOCOUNTS)) {
> +		if (format & FMT_KILOMEGAGIGA) {
> +			printf(FMT("%5s ","%s "), "pkts");
> +			printf(FMT("%5s ","%s "), "bytes");
> +		} else {
> +			printf(FMT("%8s ","%s "), "pkts");
> +			printf(FMT("%10s ","%s "), "bytes");
> +		}
> +	}
> +	if (!(format & FMT_NOTARGET))
> +		printf(FMT("%-9s ","%s "), "target");
> +	fputs(" prot ", stdout);
> +	if (format & FMT_OPTIONS)
> +		fputs("opt", stdout);
> +	if (format & FMT_VIA) {
> +		printf(FMT(" %-6s ","%s "), "in");
> +		printf(FMT("%-6s ","%s "), "out");
> +	}
> +	printf(FMT(" %-19s ","%s "), "source");
> +	printf(FMT(" %-19s "," %s "), "destination");
> +	printf("\n");
> +}
> +
> +static int
> +nft_arp_rule_list(struct nft_handle *h, const char *chain, const char *table,

Ok here you need it, since nft_rule_list from nft.c is using internal 
print_headers, which is proper to xtables.c
(Though we could think of refactoring to make a generic function, let's 
say nft_rule_list_full() which would take in 2 more parameters: the 
print_headers function pointer, and the callback pointer given to 
__nft_rule_list() inside).

> +		  int rulenum, unsigned int format)
> +{
> +	struct nft_chain_list *list;
> +	struct nft_chain_list_iter *iter;
> +	struct nft_chain *c;
> +	bool found = false;
> +
> +	/* If built-in chains don't exist for this table, create them */
> +	if (nft_xtables_config_load(h, ARPTABLES_CONFIG_DEFAULT, 0) < 0)
> +		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);

And this is now useless since it's called once in nft_init() with your 
previous patches.

> +
> +	list = nft_chain_dump(h);
> +
> +	iter = nft_chain_list_iter_create(list);
> +	if (iter == NULL) {
> +		DEBUGP("cannot allocate rule list iterator\n");
> +		return 0;
> +	}
> +
> +	c = nft_chain_list_iter_next(iter);
> +	while (c != NULL) {
> +		const char *chain_table =
> +			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_TABLE);
> +		const char *chain_name =
> +			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_NAME);
> +		uint32_t policy =
> +			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
> +		uint32_t refs =
> +			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_USE);
> +		struct xt_counters ctrs = {
> +			.pcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
> +			.bcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES),
> +		};
> +		bool basechain = false;
> +
> +		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM))
> +			basechain = true;
> +
> +		if (strcmp(table, chain_table) != 0)
> +			goto next;
> +		if (chain && strcmp(chain, chain_name) != 0)
> +			goto next;
> +
> +		if (found) printf("\n");
> +
> +		print_header(format, chain_name, policy_name[policy], &ctrs,
> +				basechain, refs);
> +
> +		//__nft_rule_list(h, c, table, rulenum, format, print_firewall);
> +
> +		found = true;
> +
> +next:
> +		c = nft_chain_list_iter_next(iter);
> +	}
> +
> +	nft_chain_list_free(list);
> +
> +	return 1;
> +}
> diff --git a/iptables/nft-arptables.h b/iptables/nft-arptables.h
> new file mode 100644
> index 0000000..e573324
> --- /dev/null
> +++ b/iptables/nft-arptables.h
> @@ -0,0 +1,95 @@
> +/*
> + * (C) 2013 by Giuseppe Longo <giuseppelng@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef _NFT_ARPTABLES_H_
> +#define _NFT_ARPTABLES_H_
> +
> +#include "nft.h"
> +
> +typedef char arpt_chainlabel[32];
> +
> +enum exittype {
> +	OTHER_PROBLEM = 1,
> +	PARAMETER_PROBLEM,
> +	VERSION_PROBLEM
> +};
> +
> +/*******************************/
> +/* REMOVE LATER, PUT IN KERNEL */
> +/*******************************/
> +struct arpt_entry_match
> +{
> +	int iets;
> +};
> +
> +/*******************************/
> +/* END OF KERNEL REPLACEMENTS  */
> +/*******************************/
> +
> +/* Include file for additions: new matches and targets. */
> +
> +struct arptables_match
> +{
> +	struct arptables_match *next;
> +
> +	arpt_chainlabel name;
> +
> +	const char *version;
> +
> +	/* Size of match data. */
> +	size_t size;
> +
> +	/* Size of match data relevent for userspace comparison purposes */
> +	size_t userspacesize;
> +
> +	/* Function which prints out usage message. */
> +	void (*help)(void);
> +
> +	/* Initialize the match. */
> +	void (*init)(struct arpt_entry_match *m, unsigned int *nfcache);
> +
> +	/* Function which parses command options; returns true if it
> +		ate an option */
> +	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
> +			const struct arpt_entry *entry,
> +			unsigned int *nfcache,
> +			struct arpt_entry_match **match);
> +
> +	/* Final check; exit if not ok. */
> +	void (*final_check)(unsigned int flags);
> +
> +	/* Prints out the match iff non-NULL: put space at end */
> +	void (*print)(const struct arpt_arp *ip,
> +			const struct arpt_entry_match *match, int numeric);
> +
> +	/* Saves the match info in parsable form to stdout. */
> +	void (*save)(const struct arpt_arp *ip,
> +			const struct arpt_entry_match *match);
> +
> +	/* Pointer to list of extra command-line options */
> +	const struct option *extra_opts;
> +
> +	/* Ignore these men behind the curtain: */
> +	unsigned int option_offset;
> +	struct arpt_entry_match *m;
> +	unsigned int mflags;
> +	unsigned int used;
> +	unsigned int loaded; /* simulate loading so options are merged properly */
> +};
> +
> +const char *program_name, *program_version;
> +
> +/* For nft_arptables.c */
> +int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table);
> +
> +/*
> + * Parse config for tables and chain helper functions
> + */
> +#define ARPTABLES_CONFIG_DEFAULT  "/etc/arptables.conf"
> +
> +#endif
> diff --git a/iptables/xtables-arptables-standalone.c b/iptables/xtables-arptables-standalone.c
> new file mode 100644
> index 0000000..a98ceea
> --- /dev/null
> +++ b/iptables/xtables-arptables-standalone.c
> @@ -0,0 +1,58 @@
> +/*
> + * Author: Paul.Russell@rustcorp.com.au and mneuling@radlogic.com.au
> + *
> + * Based on the ipchains code by Paul Russell and Michael Neuling
> + *
> + * (C) 2000-2002 by the netfilter coreteam <coreteam@netfilter.org>:
> + * 		    Paul 'Rusty' Russell <rusty@rustcorp.com.au>
> + * 		    Marc Boucher <marc+nf@mbsi.ca>
> + * 		    James Morris <jmorris@intercode.com.au>
> + * 		    Harald Welte <laforge@gnumonks.org>
> + * 		    Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + *
> + *	arptables -- IP firewall administration for kernels with
> + *	firewall table (aimed for the 2.3 kernels)
> + *
> + *	See the accompanying manual page arptables(8) for information
> + *	about proper usage of this program.
> + *
> + *	This program is free software; you can redistribute it and/or modify
> + *	it under the terms of the GNU General Public License as published by
> + *	the Free Software Foundation; either version 2 of the License, or
> + *	(at your option) any later version.
> + *
> + *	This program is distributed in the hope that it will be useful,
> + *	but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *	GNU General Public License for more details.
> + *
> + *	You should have received a copy of the GNU General Public License
> + *	along with this program; if not, write to the Free Software
> + *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <string.h>
> +#include "nft-arptables.h"
> +
> +int
> +xtables_arptables_main(int argc, char *argv[])
> +{
> +	int ret;
> +	char *table = "filter";
> +	extern struct builtin_table arp_tables[TABLES_MAX];

No, global variable should be put as global. And anyway here you don't 
need it (put it in xtables-arptables.c)

> +        struct nft_handle h = {
> +                .family = NFPROTO_ARP,
> +        };
> +
> +	program_name = "xtables-arptables";
> +
> +	nft_init(&h, arp_tables, ARPTABLES_CONFIG_DEFAULT);

Don't call nft_init() here. Let do_commandarp() do this (we initialize 
NFT if only the command is properly parsed).

> +
> +	ret = do_commandarp(&h, argc, argv, &table);
> +
> +	exit(!ret);
> +}
> +
> diff --git a/iptables/xtables-arptables.c b/iptables/xtables-arptables.c
> new file mode 100644
> index 0000000..fc3c2ff
> --- /dev/null
> +++ b/iptables/xtables-arptables.c
> @@ -0,0 +1,1632 @@
> +/* Code to take an arptables-style command line and do it. */
> +

(...)

> +		default:
> +			break;
> +			/* FIXME: This scheme doesn't allow two of the same
> +				matches --RR */
> +			/*if (!target
> +				|| !(target->parse(c - target->option_offset,
> +						argv, invert,
> +						&target->tflags,
> +						&fw, &target->t))) {*/
> +	/*
> +				for (m = arptables_matches; m; m = m->next) {
> +					if (!m->used)
> +						continue;
> +
> +					if (m->parse(c - m->option_offset,
> +							argv, invert,
> +							&m->mflags,
> +							&fw,
> +							&fw.nfcache,
> +							&m->m))
> +						break;
> +				}
> +*/
> +
> +				/* If you listen carefully, you can
> +					actually hear this code suck. */
> +
> +				/* some explanations (after four different bugs
> +				* in 3 different releases): If we encountere a
> +				* parameter, that has not been parsed yet,
> +				* it's not an option of an explicitly loaded
> +				* match or a target.  However, we support
> +				* implicit loading of the protocol match
> +				* extension.  '-p tcp' means 'l4 proto 6' and
> +				* at the same time 'load tcp protocol match on
> +				* demand if we specify --dport'.
> +				*
> +				* To make this work, we need to make sure:
> +				* - the parameter has not been parsed by
> +				*   a match (m above)
> +				* - a protocol has been specified
> +				* - the protocol extension has not been
> +				*   loaded yet, or is loaded and unused
> +				*   [think of arptables-restore!]
> +				* - the protocol extension can be successively
> +				*   loaded
> +				*/
> +/*
> +				if (m == NULL
> +					&& protocol
> +					&& (!find_proto(protocol, DONT_LOAD,
> +							options&OPT_NUMERIC)
> +					|| (find_proto(protocol, DONT_LOAD,
> +							options&OPT_NUMERIC)
> +						&& (proto_used == 0))
> +					)
> +					&& (m = find_proto(protocol, TRY_LOAD,
> +							options&OPT_NUMERIC))) {
> +					Try loading protocol */
> +/*
> +					size_t size;
> +
> +					proto_used = 1;
> +
> +					size = ARPT_ALIGN(sizeof(struct arpt_entry_match))
> +							+ m->size;
> +
> +					m->m = fw_calloc(1, size);
> +					m->m->u.match_size = size;
> +					strcpy(m->m->u.user.name, m->name);
> +					m->init(m->m, &fw.nfcache);
> +
> +					opts = merge_options(opts,
> +						m->extra_opts, &m->option_offset);
> +
> +					optind--;
> +					continue;
> +				}
> +				if (!m)
> +					exit_error(PARAMETER_PROBLEM,
> +							"Unknown arg `%s'",
> +							argv[optind-1]);
> +*/
> +                       //}
> +		}
> +		invert = FALSE;
> +	}

You need to call nft_init() here, as in xtables.c

Cheers,

Tomasz
