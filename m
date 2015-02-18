From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] arpt-compat: mangle extension support
Date: Wed, 18 Feb 2015 23:53:44 +0100
Message-ID: <20150218225344.GA11517@salvia>
References: <20150216105220.4788.79619.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57511 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbbBRWu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 17:50:28 -0500
Content-Disposition: inline
In-Reply-To: <20150216105220.4788.79619.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 16, 2015 at 11:52:52AM +0100, Arturo Borrero Gonzalez wrote:
> This patch gives support in arpt-compat to use the mangle extension.

Applied with minor glitches (see below), thanks.

> ---
> Please ignore patch http://patchwork.ozlabs.org/patch/439479/
> 
>  extensions/GNUmakefile.in         |   46 +++++++++++++++++++++++++++++++------
>  extensions/libarp_mangle.c        |    0 
>  iptables/nft-arp.c                |   23 ++++++++++---------
>  iptables/xtables-arp-standalone.c |   30 ++++++------------------
>  iptables/xtables-arp.c            |   13 ++++++++--
>  libxtables/xtables.c              |   13 ++++++++++
>  6 files changed, 80 insertions(+), 45 deletions(-)
>  rename extensions/{libxt_mangle.c => libarp_mangle.c} (100%)
> 
> diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
> index 9eb4bf9..929a02b 100644
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
> @@ -40,19 +40,23 @@ endif
>  #
>  pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
>  pfb_build_mod := $(patsubst ${srcdir}/libebt_%.c,%,$(sort $(wildcard ${srcdir}/libebt_*.c)))
> +pfa_build_mod := $(patsubst ${srcdir}/libarp_%.c,%,$(sort $(wildcard ${srcdir}/libarp_*.c)))
>  pfx_symlinks  := NOTRACK state
>  @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
>  @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
>  pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
>  pfb_build_mod := $(filter-out @blacklist_modules@,${pfb_build_mod})
> +pfa_build_mod := $(filter-out @blacklist_modules@,${pfa_build_mod})
>  pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
>  pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
>  pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
>  pfb_objs      := $(patsubst %,libebt_%.o,${pfb_build_mod})
> +pfa_objs      := $(patsubst %,libarp_%.o,${pfa_build_mod})
>  pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
>  pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
>  pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
>  pfb_solibs    := $(patsubst %,libebt_%.so,${pfb_build_mod})
> +pfa_solibs    := $(patsubst %,libarp_%.so,${pfa_build_mod})
>  pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
>  pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
>  
> @@ -60,14 +64,15 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
>  #
>  # Building blocks
>  #
> -targets := libext.a libext4.a libext6.a libext_ebt.a matches.man targets.man
> +targets := libext.a libext4.a libext6.a libext_ebt.a libext_arp.a matches.man targets.man
>  targets_install :=
>  @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
>  @ENABLE_STATIC_TRUE@ libext_ebt_objs := ${pfb_objs}
> +@ENABLE_STATIC_TRUE@ libext_arp_objs := ${pfa_objs}
>  @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
>  @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
> -@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
> -@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
> +@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
> +@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
>  
>  .SECONDARY:
>  
> @@ -80,7 +85,7 @@ install: ${targets_install}
>  	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
>  
>  clean:
> -	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c;
> +	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c initexta.c;
>  	rm -f .*.d .*.dd;
>  
>  distclean: clean
> @@ -126,6 +131,9 @@ libext.a: initext.o ${libext_objs}
>  libext_ebt.a: initextb.o ${libext_ebt_objs}
>  	${AM_VERBOSE_AR} ${AR} crs $@ $^;
>  
> +libext_arp.a: initexta.o ${libext_arp_objs}
> +	${AM_VERBOSE_AR} ${AR} crs $@ $^;
> +
>  libext4.a: initext4.o ${libext4_objs}
>  	${AM_VERBOSE_AR} ${AR} crs $@ $^;
>  
> @@ -134,6 +142,7 @@ libext6.a: initext6.o ${libext6_objs}
>  
>  initext_func  := $(addprefix xt_,${pfx_build_mod})
>  initextb_func := $(addprefix ebt_,${pfb_build_mod})
> +initexta_func := $(addprefix arp_,${pfa_build_mod})
>  initext4_func := $(addprefix ipt_,${pf4_build_mod})
>  initext6_func := $(addprefix ip6t_,${pf6_build_mod})
>  
> @@ -147,6 +156,11 @@ initext6_func := $(addprefix ip6t_,${pf6_build_mod})
>  	cmp -s $@ $@.tmp || mv $@.tmp $@; \
>  	rm -f $@.tmp;
>  
> +.initexta.dd: FORCE
> +	@echo "${initexta_func}" >$@.tmp; \
> +	cmp -s $@ $@.tmp || mv $@.tmp $@; \
> +	rm -f $@.tmp;
> +
>  .initext4.dd: FORCE
>  	@echo "${initext4_func}" >$@.tmp; \
>  	cmp -s $@ $@.tmp || mv $@.tmp $@; \
> @@ -189,6 +203,22 @@ initextb.c: .initextb.dd
>  	echo "}" >>$@; \
>  	);
>  
> +initexta.c: .initexta.dd
> +	${AM_VERBOSE_GEN}
> +	@( \
> +	echo "" >$@; \
> +	for i in ${initexta_func}; do \
> +		echo "extern void lib$${i}_init(void);" >>$@; \
> +	done; \
> +	echo "void init_extensionsa(void);" >>$@; \
> +	echo "void init_extensionsa(void)" >>$@; \
> +	echo "{" >>$@; \
> +	for i in ${initexta_func}; do \
> +		echo  " ""lib$${i}_init();" >>$@; \
> +	done; \
> +	echo "}" >>$@; \
> +	);
> +
>  initext4.c: .initext4.dd
>  	${AM_VERBOSE_GEN}
>  	@( \
> @@ -249,8 +279,8 @@ man_run    = \
>  		fi; \
>  	done >$@;
>  
> -matches.man: .initext.dd .initextb.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
> -	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pfb_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
> +matches.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
> +	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
>  
> -targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
> -	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
> +targets.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
> +	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
> diff --git a/extensions/libxt_mangle.c b/extensions/libarp_mangle.c
> similarity index 100%
> rename from extensions/libxt_mangle.c
> rename to extensions/libarp_mangle.c
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index 24b31c5..d51aa8a 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -402,12 +402,13 @@ void nft_rule_to_arptables_command_state(struct nft_rule *r,
>  
>  	nft_rule_expr_iter_destroy(iter);
>  
> -	if (cs->target != NULL)
> -		cs->jumpto = cs->target->name;
> -	else if (cs->jumpto != NULL)
> -		cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
> +	if (cs->jumpto != NULL)
> +		return;
> +
> +	if (cs->target != NULL && cs->target->name != NULL)
> +		cs->target = xtables_find_target(cs->target->name, XTF_TRY_LOAD);
>  	else
> -		cs->jumpto = "";
> +		cs->jumpto = "CONTINUE";

Unlike ebtables-compat, this still needs to be "" instead of
"CONTINUE".

>  }
>  
>  static void nft_arp_print_header(unsigned int format, const char *chain,
> @@ -585,13 +586,13 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
>  
>  	print_fw_details(&cs.fw, format);
>  
> -	if (strlen(cs.jumpto) > 0) {
> -		printf("-j %s\n", cs.jumpto);
> +	printf("-j ");

I adapted the code here too, since arptables allow rules without
target as iptables/ip6tables.

> +
> +	if (cs.jumpto != NULL) {
> +		printf("%s", cs.jumpto);
>  	} else if (cs.target) {
> -		if (cs.target->print)
> -			/* Print the target information. */
> -			cs.target->print(&cs.fw, cs.target->t,
> -					 format & FMT_NUMERIC);
> +		printf("%s ", cs.target->name);
> +		cs.target->print(&cs.fw, cs.target->t, format & FMT_NUMERIC);
>  	}
>  
>  	if (!(format & FMT_NOCOUNTS)) {
> diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
> index 182dd9f..6553d28 100644
> --- a/iptables/xtables-arp-standalone.c
> +++ b/iptables/xtables-arp-standalone.c
> @@ -41,18 +41,7 @@
>  
>  #include "xtables-multi.h"
>  
> -extern struct xtables_globals xtables_globals;
> -extern const char *program_version, *program_name;
> -
> -static const struct xtables_afinfo afinfo_arp = {
> -        .kmod          = "arp_tables",
> -        .proc_exists   = "/proc/net/arp_tables_names",
> -        .libprefix     = "libarp_",
> -        .family        = NFPROTO_ARP,
> -        .ipproto       = IPPROTO_IP,
> -        .so_rev_match  = -1,
> -        .so_rev_target = -1,
> -};
> +extern struct xtables_globals arptables_globals;
>  
>  int xtables_arp_main(int argc, char *argv[])
>  {
> @@ -62,22 +51,17 @@ int xtables_arp_main(int argc, char *argv[])
>  		.family = NFPROTO_ARP,
>  	};
>  
> -	xtables_globals.program_name = "arptables";
> -	/* This code below could be replaced by xtables_init_all, which
> -	 * doesn't support NFPROTO_ARP yet.
> -	 */
> -	xtables_init();
> -	afinfo = &afinfo_arp;
> -	ret = xtables_set_params(&xtables_globals);
> +	arptables_globals.program_name = "arptables";
> +	ret = xtables_init_all(&arptables_globals, NFPROTO_ARP);
>  	if (ret < 0) {
> -		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
> -				xtables_globals.program_name,
> -				xtables_globals.program_version);
> +		fprintf(stderr, "%s/%s Failed to initialize arptables-compat\n",
> +			arptables_globals.program_name,
> +			arptables_globals.program_version);
>  		exit(1);
>  	}
>  
>  #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
> -	init_extensions();
> +	init_extensionsa();
>  #endif
>  
>  	ret = do_commandarp(&h, argc, argv, &table);
> diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
> index c92b9e7..20b987f 100644
> --- a/iptables/xtables-arp.c
> +++ b/iptables/xtables-arp.c
> @@ -44,6 +44,7 @@
>  #include <sys/wait.h>
>  #include <net/if.h>
>  #include <netinet/ether.h>
> +#include <iptables.h>
>  #include <xtables.h>
>  
>  #include "xshared.h"
> @@ -152,7 +153,13 @@ static struct option *opts = original_opts;
>  static unsigned int global_option_offset = 0;
>  
>  extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...);

I have changed this to calm down a compilation warning.
