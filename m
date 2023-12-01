Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OskM3Utd"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1C8F3
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Dec 2023 10:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RXsg5q7m94YwxRXgndLUCnnT/ri5xuTsWEVKjcO/PL0=; b=OskM3UtdB695kINDp84FR56RPh
	oZo7gepaB+wsn2lAXMYqF30tU1J3n97O2AvI6sHJ25BbgTMLgTNicy+ORz2MS/zWKzoQzLoqQBfKy
	ECnS50iEPzxKHh+mLvdgdDRKYVIQ9XCj+0202uI0ezW16sItS8ZS+vrVkZ5fum/V07u1xSTs9XH9j
	bjW39wR/Hh+QRAogd2eaTbRXOKDZKxC4DS0yLTQ31SnPq0mBU5sfwTb0CdCAzRn0ReFVrE+iYxfpj
	SlpTsewzb6cLlgshs38t26TQAaUnVpn32R06iKMTmvhIYiI2aMyghleROmlth6yJhenamu50pOfOR
	V2je56Sg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r98hg-0007uw-0Z; Fri, 01 Dec 2023 19:57:32 +0100
Date: Fri, 1 Dec 2023 19:57:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] initial support for the afl++ (american fuzzy lop++)
 fuzzer
Message-ID: <ZWosnAaaeD0S2GPR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231201154307.13622-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201154307.13622-1-fw@strlen.de>

On Fri, Dec 01, 2023 at 04:43:04PM +0100, Florian Westphal wrote:
[...]
> diff --git a/configure.ac b/configure.ac
> index 724a4ae726c1..408be61080e5 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -91,6 +91,15 @@ AC_MSG_ERROR([unexpected CLI value: $with_cli])
>  ])
>  AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
>  
> +AC_ARG_ENABLE([fuzzer],
> +	      AS_HELP_STRING([--enable-fuzzer], [Enable fuzzer support.  NEVER use this unless you work on nftables project]),
> +	      [enable_fuzzer=yes], [enable_fuzzer=no])
> +
> +AM_CONDITIONAL([BUILD_AFL], [test "x$enable_fuzzer" = xyes])
> +AS_IF([test "x$enable_fuzzer" != xno], [
> +	AC_DEFINE([HAVE_FUZZER_BUILD], [1], [Define if you want to build with fuzzer support])
> +	], [])
> +
>  AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
>              [Use libxtables for iptables interaction])],
>  	    [], [with_xtables=no])
> @@ -128,3 +137,14 @@ nft configuration:
>    enable man page:              ${enable_man_doc}
>    libxtables support:		${with_xtables}
>    json output support:          ${with_json}"
> +
> +AS_IF([test "$enable_python" != "no"], [
> +	echo "  enable Python:		yes (with $PYTHON_BIN)"
> +	], [
> +	echo "  enable Python:		no"
> +	]
> +	)

This got dropped in commit b3def33efecb2 ("py: remove setup.py
integration with autotools"). A rebase conflict resolution mistake?

[...]
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 0dee1bacb0db..b3b29135b3e8 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -9,6 +9,7 @@
>  #include <nft.h>
>  
>  #include <nftables/libnftables.h>
> +#include <afl++.h>
>  #include <erec.h>
>  #include <mnl.h>
>  #include <parser.h>
> @@ -36,6 +37,17 @@ static int nft_netlink(struct nft_ctx *nft,
>  	if (list_empty(cmds))
>  		goto out;
>  
> +#if defined(HAVE_FUZZER_BUILD)
> +	switch (nft->afl_ctx_stage) {
> +	case NFT_AFL_FUZZER_ALL:
> +	case NFT_AFL_FUZZER_NETLINK_RO:
> +	case NFT_AFL_FUZZER_NETLINK_WR:
> +		break;
> +	case NFT_AFL_FUZZER_PARSER:
> +	case NFT_AFL_FUZZER_EVALUATION:
> +		goto out;
> +	}
> +#endif
>  	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
>  	list_for_each_entry(cmd, cmds, list) {
>  		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> @@ -579,6 +591,20 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
>  		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
>  					    &indesc_cmdline);
>  
> +#if defined(HAVE_FUZZER_BUILD)
> +	if (rc && nft->afl_ctx_stage == NFT_AFL_FUZZER_PARSER) {
> +		list_for_each_entry_safe(cmd, next, &cmds, list) {
> +			list_del(&cmd->list);
> +			cmd_free(cmd);
> +		}
> +		if (nft->scanner) {
> +			scanner_destroy(nft);
> +			nft->scanner = NULL;
> +		}
> +		free(nlbuf);
> +		return rc;
> +	}
> +#endif

I guess these chunks should become inline functions which are empty if
!defined(HAVE_FUZZER_BUILD).

>  	parser_rc = rc;
>  
>  	rc = nft_evaluate(nft, &msgs, &cmds);
> diff --git a/src/main.c b/src/main.c
> index 9485b193cd34..51bdf6deb86e 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -21,6 +21,7 @@
>  #include <nftables/libnftables.h>
>  #include <utils.h>
>  #include <cli.h>
> +#include <afl++.h>
>  
>  static struct nft_ctx *nft;
>  
> @@ -55,6 +56,9 @@ enum opt_indices {
>          IDX_ECHO,
>  #define IDX_CMD_OUTPUT_START	IDX_ECHO
>          IDX_JSON,
> +#ifdef HAVE_FUZZER_BUILD
> +        IDX_FUZZER,
> +#endif
>          IDX_DEBUG,
>  #define IDX_CMD_OUTPUT_END	IDX_DEBUG
>  };
> @@ -83,6 +87,11 @@ enum opt_vals {
>  	OPT_TERSE		= 't',
>  	OPT_OPTIMIZE		= 'o',
>  	OPT_INVALID		= '?',
> +
> +#ifdef HAVE_FUZZER_BUILD
> +	/* keep last */
> +        OPT_FUZZER		= 0x254

This is 596 in decimal? ;)
I guess it should be 254 or am I missing the point?

> +#endif
>  };
>  
>  struct nft_opt {
> @@ -140,6 +149,10 @@ static const struct nft_opt nft_options[] = {
>  				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
>  	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		NULL,
>  				     "Optimize ruleset"),
> +#ifdef HAVE_FUZZER_BUILD
> +	[IDX_FUZZER]	    = NFT_OPT("fuzzer",			OPT_FUZZER,		"stage",
> +				      "fuzzer stage to run (parser, eval, netlink-ro, netlink-write)"),
> +#endif
>  };
>  
>  #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
> @@ -230,6 +243,7 @@ static void show_help(const char *name)
>  		print_option(&nft_options[i]);
>  
>  	fputs("\n", stdout);
> +	nft_afl_print_build_info(stdout);
>  }
>  
>  static void show_version(void)
> @@ -271,6 +285,8 @@ static void show_version(void)
>  	       "  libxtables:	%s\n",
>  	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
>  	       cli, json, minigmp, xt);
> +
> +	nft_afl_print_build_info(stdout);
>  }
>  
>  static const struct {
> @@ -311,6 +327,38 @@ static const struct {
>  	},
>  };
>  
> +#if defined(HAVE_FUZZER_BUILD)
> +static const struct {
> +	const char			*name;
> +	enum nft_afl_fuzzer_stage	stage;
> +} fuzzer_stage_param[] = {
> +	{
> +		.name		= "parser",
> +		.stage		= NFT_AFL_FUZZER_PARSER,
> +	},
> +	{
> +		.name		= "eval",
> +		.stage		= NFT_AFL_FUZZER_EVALUATION,
> +	},
> +	{
> +		.name		= "netlink-ro",
> +		.stage		= NFT_AFL_FUZZER_NETLINK_RO,
> +	},
> +	{
> +		.name		= "netlink-write",
> +		.stage		= NFT_AFL_FUZZER_NETLINK_WR,
> +	},
> +};
> +static void afl_exit(const char *err)
> +{
> +	fprintf(stderr, "Error: fuzzer: %s\n", err);
> +	sleep(60);	/* assume we're running under afl-fuzz and would be restarted right away */
> +	exit(EXIT_FAILURE);
> +}
> +#else
> +static inline void afl_exit(const char *err) { }
> +#endif
> +
>  static void nft_options_error(int argc, char * const argv[], int pos)
>  {
>  	int i;
> @@ -344,6 +392,10 @@ static bool nft_options_check(int argc, char * const argv[])
>  				   !strcmp(argv[i], "--debug") ||
>  				   !strcmp(argv[i], "--includepath") ||
>  				   !strcmp(argv[i], "--define") ||
> +				   !strcmp(argv[i], "--define") ||

This duplicated comparison against "--define" looks like another case of
wrong rebase conflict resolution.

I'll give the remaining stuff a more thorough review next week.

Cheers, Phil
