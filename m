Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21F110C9
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 23:43:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rAmZK-0005xe-HO; Wed, 06 Dec 2023 08:43:42 +0100
Date: Wed, 6 Dec 2023 08:43:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] initial support for the afl++ (american fuzzy lop++)
 fuzzer
Message-ID: <20231206074342.GC8352@breakpoint.cc>
References: <20231201154307.13622-1-fw@strlen.de>
 <ZW/YVpeUtn5dfcmA@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW/YVpeUtn5dfcmA@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > +__AFL_FUZZ_INIT();
> > +/* this get passed via afl-cc, declares prototypes
> > + * depending on the afl-cc flavor.
> > + */
>
> This comment seems out of place?

I wanted to add some explanation as to where this
macro is defined/coming from.

> > +	len = strlen(buf);
> > +
> > +	rv = write(fd, buf, len);
> 
> So this sets input->fname to name and writes into the opened fd, but
> what if savebuf() noticed buf fits into input->buffer and thus set
> input->use_filename = false?

What about it?  The idea is to have an on-disk copy in case afl or the
vm its running in crashes.

> > +#if defined(HAVE_FUZZER_BUILD)
> > +	if (rc && nft->afl_ctx_stage == NFT_AFL_FUZZER_PARSER) {
> > +		list_for_each_entry_safe(cmd, next, &cmds, list) {
> > +			list_del(&cmd->list);
> > +			cmd_free(cmd);
> > +		}
> > +		if (nft->scanner) {
> > +			scanner_destroy(nft);
> > +			nft->scanner = NULL;
> > +		}
> > +		free(nlbuf);
> > +		return rc;
> > +	}
> > +#endif
> 
> You want to keep nft->cache and thus don't make this just 'goto err',
> right?

Yes, idea was to exercise cache too.  Its reset on each new fuzzer input
round already.

> > diff --git a/src/main.c b/src/main.c
> > index 9485b193cd34..51bdf6deb86e 100644
> > --- a/src/main.c
> > +++ b/src/main.c
> > @@ -21,6 +21,7 @@
> >  #include <nftables/libnftables.h>
> >  #include <utils.h>
> >  #include <cli.h>
> > +#include <afl++.h>
> >  
> >  static struct nft_ctx *nft;
> >  
> > @@ -55,6 +56,9 @@ enum opt_indices {
> >          IDX_ECHO,
> >  #define IDX_CMD_OUTPUT_START	IDX_ECHO
> >          IDX_JSON,
> > +#ifdef HAVE_FUZZER_BUILD
> > +        IDX_FUZZER,
> > +#endif
> >          IDX_DEBUG,
> >  #define IDX_CMD_OUTPUT_END	IDX_DEBUG
> >  };
> > @@ -83,6 +87,11 @@ enum opt_vals {
> >  	OPT_TERSE		= 't',
> >  	OPT_OPTIMIZE		= 'o',
> >  	OPT_INVALID		= '?',
> > +
> > +#ifdef HAVE_FUZZER_BUILD
> > +	/* keep last */
> > +        OPT_FUZZER		= 0x254
> > +#endif
> >  };
> >  
> >  struct nft_opt {
> > @@ -140,6 +149,10 @@ static const struct nft_opt nft_options[] = {
> >  				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
> >  	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		NULL,
> >  				     "Optimize ruleset"),
> > +#ifdef HAVE_FUZZER_BUILD
> > +	[IDX_FUZZER]	    = NFT_OPT("fuzzer",			OPT_FUZZER,		"stage",
> > +				      "fuzzer stage to run (parser, eval, netlink-ro, netlink-write)"),
> > +#endif
> >  };
> >  
> >  #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
> > @@ -230,6 +243,7 @@ static void show_help(const char *name)
> >  		print_option(&nft_options[i]);
> >  
> >  	fputs("\n", stdout);
> > +	nft_afl_print_build_info(stdout);
> >  }
> >  
> >  static void show_version(void)
> > @@ -271,6 +285,8 @@ static void show_version(void)
> >  	       "  libxtables:	%s\n",
> >  	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
> >  	       cli, json, minigmp, xt);
> > +
> > +	nft_afl_print_build_info(stdout);
> >  }
> >  
> >  static const struct {
> > @@ -311,6 +327,38 @@ static const struct {
> >  	},
> >  };
> >  
> > +#if defined(HAVE_FUZZER_BUILD)
> > +static const struct {
> > +	const char			*name;
> > +	enum nft_afl_fuzzer_stage	stage;
> > +} fuzzer_stage_param[] = {
> > +	{
> > +		.name		= "parser",
> > +		.stage		= NFT_AFL_FUZZER_PARSER,
> > +	},
> > +	{
> > +		.name		= "eval",
> > +		.stage		= NFT_AFL_FUZZER_EVALUATION,
> > +	},
> > +	{
> > +		.name		= "netlink-ro",
> > +		.stage		= NFT_AFL_FUZZER_NETLINK_RO,
> > +	},
> > +	{
> > +		.name		= "netlink-write",
> > +		.stage		= NFT_AFL_FUZZER_NETLINK_WR,
> > +	},
> > +};
> > +static void afl_exit(const char *err)
> > +{
> > +	fprintf(stderr, "Error: fuzzer: %s\n", err);
> > +	sleep(60);	/* assume we're running under afl-fuzz and would be restarted right away */
> > +	exit(EXIT_FAILURE);
> > +}
> > +#else
> > +static inline void afl_exit(const char *err) { }
> > +#endif
> > +
> >  static void nft_options_error(int argc, char * const argv[], int pos)
> >  {
> >  	int i;
> > @@ -344,6 +392,10 @@ static bool nft_options_check(int argc, char * const argv[])
> >  				   !strcmp(argv[i], "--debug") ||
> >  				   !strcmp(argv[i], "--includepath") ||
> >  				   !strcmp(argv[i], "--define") ||
> > +				   !strcmp(argv[i], "--define") ||
> > +#if defined(HAVE_FUZZER_BUILD)
> > +				   !strcmp(argv[i], "--fuzzer") ||
> > +#endif
> >  				   !strcmp(argv[i], "--file")) {
> >  				skip = true;
> >  				continue;
> 
> If my series ([nft PATCH 0/2] Review nft_options_check()) is applied
> before this one, the above change is not needed anymore.

I already applied your series, I will toss this part.

> > +--fuzzer supports hook scripts, see the examples in tests/afl++/hooks/
> > +Remove or copy the scripts and remove the '-sample' suffix.  Scripts need to be executable.
> 
> s/\.$/, root-owned and not writable by others./
> 
> Also, I don't see any detection of the '-sample' suffix and this patch
> doesn't create such files.

Yes, this is a left-over from old version, I'll remove this.

> > @@ -0,0 +1,6 @@
> > +Fuzzing is sometimes VERY slow, this happens when current inputs contain
> > +"host names".  Either --fuzzer could set NFT_CTX_INPUT_NO_DNS to avoid this,
> > +or nft needs a new command line option so both (dns and no dns) can be combined.
> 
> Overriding nsswitch.conf's hosts-entry would be neat, but seems not
> supported by glibc.

I'll auto set NO_DNS flag.

> > diff --git a/tests/afl++/hooks/init b/tests/afl++/hooks/init
> > new file mode 100755
> > index 000000000000..503257afa2f1
> > --- /dev/null
> > +++ b/tests/afl++/hooks/init
> 
> Is this supposed to run by default? I guess unless one clones the tree
> as root, nft_exec_hookscript() will reject it because sb.st_uid != 0,
> right? Not sure if the check is sensible given the circumstances.
> Otherwise just document the need to chown in the README?

Can do.  Its supposed to be run by default, yes, but it doesn't do
much except on debug kernels atm.

Thanks for your review, I will try to follow and fix as much as I can.
