From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC ebtables-compat PATCH] extensions: add ebt 802_3 extension
Date: Wed, 10 Dec 2014 13:58:07 +0100
Message-ID: <20141210125807.GA4198@salvia>
References: <20141210123605.24725.15481.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54770 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbaLJMzy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:55:54 -0500
Content-Disposition: inline
In-Reply-To: <20141210123605.24725.15481.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 10, 2014 at 01:36:05PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds the first ebtables extension to ebtables-compat.
> The original 802_3 code is adapted to the xtables environment.
> 
> I tried to mimic as much as possible the original ebtables code paths.
> 
> With this patch, ebtables-compat is able to send the 802_3 match to the kernel,
> but the kernel-to-userspace path is not tested and should be adjusted
> in follow-up patches.

Great news. Please, test this with Giuseppe's patch to add the kernel
support for nft_compat.

Some comments below:

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  extensions/GNUmakefile.in        |    8 +
>  extensions/libebt_802_3.c        |  157 +++++++++++++++++++++++++++++
>  iptables/Makefile.am             |    4 -
>  iptables/nft-bridge.c            |    6 +
>  iptables/nft-bridge.h            |    6 +
>  iptables/xtables-eb-standalone.c |   32 +-----
>  iptables/xtables-eb.c            |  204 +++++++++++++++++++++++++++-----------
>  libxtables/xtables.c             |   13 ++
>  8 files changed, 341 insertions(+), 89 deletions(-)
>  create mode 100644 extensions/libebt_802_3.c
> 
> diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
> index 7b4f891..a2dd4f5 100644
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
> @@ -60,7 +60,7 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
>  #
>  # Building blocks
>  #
> -targets := libext.a libext4.a libext6.a matches.man targets.man
> +targets := libext.a libext4.a libext6.a libextb.a matches.man targets.man
>  targets_install :=
>  @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
>  @ENABLE_STATIC_TRUE@ libextb_objs := ${pfb_objs}
> @@ -80,7 +80,7 @@ install: ${targets_install}
>  	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
>  
>  clean:
> -	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
> +	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c;
>  	rm -f .*.d .*.dd;
>  
>  distclean: clean
> @@ -180,8 +180,8 @@ initextb.c: .initextb.dd
>  	for i in ${initextb_func}; do \
>  		echo "extern void lib$${i}_init(void);" >>$@; \
>  	done; \
> -	echo "void init_extensions(void);" >>$@; \
> -	echo "void init_extensions(void)" >>$@; \
> +	echo "void init_extensionsb(void);" >>$@; \

Please, use:

init_ebt_extensions()

instead.

> +	echo "void init_extensionsb(void)" >>$@; \
>  	echo "{" >>$@; \
>  	for i in ${initextb_func}; do \
>  		echo  " ""lib$${i}_init();" >>$@; \
> diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
> new file mode 100644
> index 0000000..34190dd
> --- /dev/null
> +++ b/extensions/libebt_802_3.c
> @@ -0,0 +1,157 @@
> +/* 802_3
> + *
> + * Author:
> + * Chris Vitale <csv@bluetail.com>
> + *

Add a notice here that you have adapted this to the iptables' internal
library. I'd suggest:

Adapted by Arturo Borrero <...@...> to use libxtables for ebtables-compat.

> + * May 2003
> + */
> +
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <stdlib.h>
> +#include <getopt.h>
> +#include <xtables.h>
> +#include <linux/netfilter_bridge/ebt_802_3.h>
> +
> +#define _802_3_SAP	'1'
> +#define _802_3_TYPE	'2'
> +
> +static const struct option br802_3_opts[] = {
> +	{ .name = "802_3-sap",	.has_arg = true, .val = _802_3_SAP },
> +	{ .name = "802_3-type",	.has_arg = true, .val = _802_3_TYPE },
> +	XT_GETOPT_TABLEEND,
> +};
> +
> +static void br802_3_print_help(void)
> +{
> +	printf(
> +"802_3 options:\n"
> +"--802_3-sap [!] protocol       : 802.3 DSAP/SSAP- 1 byte value (hex)\n"
> +"  DSAP and SSAP are always the same.  One SAP applies to both fields\n"
> +"--802_3-type [!] protocol      : 802.3 SNAP Type- 2 byte value (hex)\n"
> +"  Type implies SAP value 0xaa\n");
> +}
> +
> +static void br802_3_init(struct xt_entry_match *match)
> +{
> +	struct ebt_802_3_info *info = (struct ebt_802_3_info *)match->data;
> +
> +	info->invflags = 0;
> +	info->bitmask = 0;
> +}
> +
> +/*static int parse(int c, char **argv, int argc, const struct ebt_u_entry *entry,
> +   unsigned int *flags, struct ebt_entry_match **match)*/
> +static int
> +br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
> +	      const void *entry, struct xt_entry_match **match)
> +{
> +	struct ebt_802_3_info *info = (struct ebt_802_3_info *) (*match)->data;
> +	unsigned int i;
> +	char *end;
> +
> +	switch (c) {
> +	case _802_3_SAP:
> +		if (invert)
> +			info->invflags |= EBT_802_3_SAP;
> +		i = strtoul(optarg, &end, 16);
> +		if (i > 255 || *end != '\0')
> +			xtables_error(PARAMETER_PROBLEM,
> +				      "Problem with specified "
> +					"sap hex value, %x",i);
> +		info->sap = i; /* one byte, so no byte order worries */
> +		info->bitmask |= EBT_802_3_SAP;
> +		break;
> +	case _802_3_TYPE:
> +		if (invert)
> +			info->invflags |= EBT_802_3_TYPE;
> +		i = strtoul(optarg, &end, 16);
> +		if (i > 65535 || *end != '\0') {
> +			xtables_error(PARAMETER_PROBLEM,
> +				      "Problem with the specified "
> +					"type hex value, %x",i);
> +		}
> +		info->type = htons(i);
> +		info->bitmask |= EBT_802_3_TYPE;
> +		break;
> +	default:
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +static void
> +br802_3_final_check(unsigned int flags)
> +{
> +	/*if (!(entry->bitmask & EBT_802_3))
> +		ebt_print_error("For 802.3 DSAP/SSAP filtering the protocol "
> +				"must be LENGTH");
> +	*/
> +	if (!flags)
> +		xtables_error(PARAMETER_PROBLEM,
> +			      "You must specify proper arguments");
> +}
> +
> +/*static void print(const struct ebt_u_entry *entry,
> +   const struct ebt_entry_match *match)*/
> +static void br802_3_print(const void *ip, const struct xt_entry_match *match,
> +			  int numeric)
> +{
> +	struct ebt_802_3_info *info = (struct ebt_802_3_info *)match->data;
> +
> +	if (info->bitmask & EBT_802_3_SAP) {
> +		printf("--802_3-sap ");
> +		if (info->invflags & EBT_802_3_SAP)
> +			printf("! ");
> +		printf("0x%.2x ", info->sap);
> +	}
> +	if (info->bitmask & EBT_802_3_TYPE) {
> +		printf("--802_3-type ");
> +		if (info->invflags & EBT_802_3_TYPE)
> +			printf("! ");
> +		printf("0x%.4x ", ntohs(info->type));
> +	}
> +}
> +/*
> +static int compare(const struct ebt_entry_match *m1,
> +   const struct ebt_entry_match *m2)
> +{
> +	struct ebt_802_3_info *info1 = (struct ebt_802_3_info *)m1->data;
> +	struct ebt_802_3_info *info2 = (struct ebt_802_3_info *)m2->data;
> +
> +	if (info1->bitmask != info2->bitmask)
> +		return 0;
> +	if (info1->invflags != info2->invflags)
> +		return 0;
> +	if (info1->bitmask & EBT_802_3_SAP) {
> +		if (info1->sap != info2->sap)
> +			return 0;
> +	}
> +	if (info1->bitmask & EBT_802_3_TYPE) {
> +		if (info1->type != info2->type)
> +			return 0;
> +	}
> +	return 1;
> +}
> +*/
> +static struct xtables_match br802_3_match =
> +{
> +	.name		= "802_3",
> +	.revision	= 0,
> +	.version	= XTABLES_VERSION,
> +	.family		= NFPROTO_BRIDGE,
> +	.size		= XT_ALIGN(sizeof(struct ebt_802_3_info)),
> +	.userspacesize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
> +	.init		= br802_3_init,
> +	.help		= br802_3_print_help,
> +	.parse		= br802_3_parse,
> +	.final_check	= br802_3_final_check,
> +	.print		= br802_3_print,
> +	.extra_opts	= br802_3_opts,
> +};
> +
> +void _init(void)
> +{
> +	xtables_register_match(&br802_3_match);
> +}
> diff --git a/iptables/Makefile.am b/iptables/Makefile.am
> index b3e417b..d8a55b2 100644
> --- a/iptables/Makefile.am
> +++ b/iptables/Makefile.am
> @@ -29,7 +29,7 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
>  if ENABLE_NFTABLES
>  xtables_compat_multi_SOURCES  = xtables-compat-multi.c iptables-xml.c
>  xtables_compat_multi_CFLAGS   = ${AM_CFLAGS}
> -xtables_compat_multi_LDADD    = ../extensions/libext.a
> +xtables_compat_multi_LDADD    = ../extensions/libext.a ../extensions/libextb.a

libext_ebt.a ?

>  if ENABLE_STATIC
>  xtables_compat_multi_CFLAGS  += -DALL_INCLUSIVE
>  endif
> @@ -42,7 +42,7 @@ xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
>  				xtables-arp-standalone.c xtables-arp.c \
>  				getethertype.c nft-bridge.c \
>  				xtables-eb-standalone.c xtables-eb.c
> -xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a
> +xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libextb.a
>  # yacc and lex generate dirty code
>  xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
>  xtables_compat_multi_SOURCES += xshared.c
> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> index a1bd906..9772b5f 100644
> --- a/iptables/nft-bridge.c
> +++ b/iptables/nft-bridge.c
> @@ -135,6 +135,7 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
>  static int nft_bridge_add(struct nft_rule *r, void *data)
>  {
>  	struct ebtables_command_state *cs = data;
> +	struct xtables_rule_match *matchp;
>  	struct ebt_entry *fw = &cs->fw;
>  	uint32_t op;
>  	char *addr;
> @@ -179,6 +180,11 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
>  		add_cmp_u16(r, fw->ethproto, op);
>  	}
>  
> +	for (matchp = cs->matches; matchp; matchp = matchp->next) {
> +		if (add_match(r, matchp->match->m) < 0)
> +			break;
> +	}
> +
>  	return _add_action(r, cs);
>  }
>  
> diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
> index 1e3f0a1..fd8bc9f 100644
> --- a/iptables/nft-bridge.h
> +++ b/iptables/nft-bridge.h
> @@ -90,6 +90,12 @@ struct ebtables_command_state {
>  	struct xtables_rule_match *matches;
>  	const char *jumpto;
>  	struct xt_counters counters;
> +	int invert;
> +	int c;
> +	char **argv;
> +	int proto_used;
> +	char *protocol;
> +	unsigned int options;
>  };
>  
>  void nft_rule_to_ebtables_command_state(struct nft_rule *r,
> diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
> index 1c3cbf0..914d137 100644
> --- a/iptables/xtables-eb-standalone.c
> +++ b/iptables/xtables-eb-standalone.c
> @@ -36,22 +36,12 @@
>  #include <errno.h>
>  #include <string.h>
>  #include <xtables.h>
> +#include <iptables.h>
>  #include "nft.h"
>  
>  #include "xtables-multi.h"
>  
> -extern struct xtables_globals xtables_globals;
> -extern const char *program_version, *program_name;
> -
> -static const struct xtables_afinfo afinfo_bridge = {
> -        .kmod          = "eb_tables",
> -        .proc_exists   = "/proc/net/eb_tables_names",
> -        .libprefix     = "libeb_",
> -        .family        = NFPROTO_BRIDGE,
> -        .ipproto       = IPPROTO_IP,
> -        .so_rev_match  = -1,
> -        .so_rev_target = -1,
> -};
> +extern struct xtables_globals ebtables_globals;
>  
>  int xtables_eb_main(int argc, char *argv[])
>  {
> @@ -61,24 +51,18 @@ int xtables_eb_main(int argc, char *argv[])
>  		.family = NFPROTO_BRIDGE,
>  	};
>  
> -	xtables_globals.program_name = "ebtables";
> -	/* This code below could be replaced by xtables_init_all, which
> -	 * doesn't support NFPROTO_BRIDGE yet.
> -	 */
> -	xtables_init();
> -	afinfo = &afinfo_bridge;
> -	ret = xtables_set_params(&xtables_globals);
> +	ebtables_globals.program_name = "ebtables";
> +	ret = xtables_init_all(&ebtables_globals, NFPROTO_BRIDGE);
>  	if (ret < 0) {
> -		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
> -				xtables_globals.program_name,
> -				xtables_globals.program_version);
> +		fprintf(stderr, "%s/%s Failed to initialize ebtables-compat\n",
> +			ebtables_globals.program_name,
> +			ebtables_globals.program_version);
>  		exit(1);
>  	}
>  
>  #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
> -	init_extensions();
> +	init_extensionsb();
>  #endif
> -
>  	ret = do_commandeb(&h, argc, argv, &table);
>  	if (ret)
>  		ret = nft_commit(&h);
> diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
> index 51811cf..c879be7 100644
> --- a/iptables/xtables-eb.c
> +++ b/iptables/xtables-eb.c
> @@ -30,6 +30,7 @@
>  #include <signal.h>
>  #include <net/if.h>
>  #include <netinet/ether.h>
> +#include <iptables.h>
>  #include <xtables.h>
>  
>  #include <linux/netfilter_bridge.h>
> @@ -39,10 +40,6 @@
>  #include "nft.h"
>  #include "nft-bridge.h"
>  
> -extern struct xtables_globals xtables_globals;
> -#define prog_name xtables_globals.program_name
> -#define prog_vers xtables_globals.program_version
> -
>  /*
>   * From include/ebtables_u.h
>   */
> @@ -141,44 +138,6 @@ static int ebt_check_inverse2(const char option[], int argc, char **argv)
>  }
>  
>  /*
> - * From libebtc.c
> - */
> -
> -/* The four target names, from libebtc.c */
> -const char* ebt_standard_targets[NUM_STANDARD_TARGETS] =
> -{
> -	"ACCEPT",
> -	"DROP",
> -	"CONTINUE",
> -	"RETURN",
> -};
> -
> -/* Prints all registered extensions */
> -static void ebt_list_extensions(const struct xtables_target *t,
> -				const struct xtables_rule_match *m)
> -{
> -	printf("%s v%s\n", prog_name, prog_vers);
> -	printf("Loaded userspace extensions:\n");
> -	/*printf("\nLoaded tables:\n");
> -        while (tbl) {
> -		printf("%s\n", tbl->name);
> -                tbl = tbl->next;
> -	}*/
> -	printf("\nLoaded targets:\n");
> -        for (t = xtables_targets; t; t = t->next) {
> -		printf("%s\n", t->name);
> -	}
> -	printf("\nLoaded matches:\n");
> -        for (; m != NULL; m = m->next)
> -		printf("%s\n", m->match->name);
> -	/*printf("\nLoaded watchers:\n");
> -        while (w) {
> -		printf("%s\n", w->name);
> -                w = w->next;
> -	}*/
> -}
> -
> -/*
>   * Glue code to use libxtables
>   */
>  static int parse_rule_number(const char *rule)
> @@ -341,8 +300,119 @@ static struct option ebt_original_options[] =
>  	{ 0 }
>  };
>  
> +void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
> +
>  static struct option *ebt_options = ebt_original_options;
>  
> +struct xtables_globals ebtables_globals = {
> +	.option_offset 		= 0,
> +	.program_version	= IPTABLES_VERSION,
> +	.orig_opts		= ebt_original_options,
> +	.exit_err		= xtables_exit_error,
> +	.compat_rev		= nft_compatible_revision,
> +};
> +
> +#define opts ebtables_globals.opts
> +#define prog_name ebtables_globals.program_name
> +#define prog_vers ebtables_globals.program_version
> +
> +/*
> + * From libebtc.c
> + */
> +
> +/* The four target names, from libebtc.c */
> +const char* ebt_standard_targets[NUM_STANDARD_TARGETS] =
> +{
> +	"ACCEPT",
> +	"DROP",
> +	"CONTINUE",
> +	"RETURN",
> +};
> +
> +/* Prints all registered extensions */
> +static void ebt_list_extensions(const struct xtables_target *t,
> +				const struct xtables_rule_match *m)
> +{
> +	printf("%s v%s\n", prog_name, prog_vers);
> +	printf("Loaded userspace extensions:\n");
> +	/*printf("\nLoaded tables:\n");
> +        while (tbl) {
> +		printf("%s\n", tbl->name);
> +                tbl = tbl->next;
> +	}*/
> +	printf("\nLoaded targets:\n");
> +        for (t = xtables_targets; t; t = t->next) {
> +		printf("%s\n", t->name);
> +	}
> +	printf("\nLoaded matches:\n");
> +        for (; m != NULL; m = m->next)
> +		printf("%s\n", m->match->name);
> +	/*printf("\nLoaded watchers:\n");
> +        while (w) {
> +		printf("%s\n", w->name);
> +                w = w->next;
> +	}*/
> +}
> +
> +#define OPTION_OFFSET 256
> +static struct option *merge_options(struct option *oldopts,
> +				    const struct option *newopts,
> +				    unsigned int *options_offset)
> +{
> +	unsigned int num_old, num_new, i;
> +	struct option *merge;
> +
> +	if (!newopts || !oldopts || !options_offset)
> +		xtables_error(OTHER_PROBLEM, "merge wrong");
> +	for (num_old = 0; oldopts[num_old].name; num_old++);
> +	for (num_new = 0; newopts[num_new].name; num_new++);
> +
> +	ebtables_globals.option_offset += OPTION_OFFSET;
> +	*options_offset = ebtables_globals.option_offset;
> +
> +	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
> +	if (!merge)
> +		return NULL;
> +	memcpy(merge, oldopts, num_old * sizeof(struct option));
> +	for (i = 0; i < num_new; i++) {
> +		merge[num_old + i] = newopts[i];
> +		merge[num_old + i].val += *options_offset;
> +	}
> +	memset(merge + num_old + num_new, 0, sizeof(struct option));
> +	/* Only free dynamically allocated stuff */
> +	if (oldopts != ebt_original_options)
> +		free(oldopts);
> +
> +	return merge;
> +}
> +
> +/* manually registering ebt matches, given the original ebtables parser
> + * don't use '-m matchname' and the match can't loaded dinamically when
> + * the user calls it.
> + * This code is very similar to iptables/xtables.c:command_match()
> + */
> +static void load_matches(void)
> +{
> +	struct xtables_match *m;
> +	size_t size;
> +	opts = ebt_original_options;
> +
> +	m = xtables_find_match("802_3", XTF_LOAD_MUST_SUCCEED, NULL);
> +	if (m == NULL)
> +		xtables_error(OTHER_PROBLEM, "Unable to load 802_3 match");
> +
> +	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
> +	m->m = xtables_calloc(1, size);
> +	m->m->u.match_size = size;
> +	strcpy(m->m->u.user.name, m->name);
> +	m->m->u.user.revision = m->revision;
> +	xs_init_match(m);
> +
> +	opts = merge_options(opts, m->extra_opts, &m->option_offset);
> +	if (opts == NULL)
> +		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
> +}

You can abstract this function to:

void ebt_load_match(const char *name)

so you can use it from:

static void ebt_load_matches(void)
{
        ebt_load_match("802_3");
        ...
}

>  /*
>   * More glue code.
>   */

I'd suggest you to move the new code above for extension / option
handling here, after this "More glue code" notice. Since this doesn't
originally belongs to libebt.c

