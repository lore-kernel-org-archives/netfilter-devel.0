From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch 3/6] ipset: pass ipset_arg argument pointer
Date: Tue, 25 Jan 2011 21:42:58 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252139400.19580@blackhole.kfki.hu>
References: <20110124213631.195499507@jonathan.eitzenberger.org> <20110124214012.012613658@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40102 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AYUnA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:43:00 -0500
In-Reply-To: <20110124214012.012613658@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Jan 2011, Holger Eitzenberger wrote:

> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> 
> Index: ipset/src/ipset.c
> ===================================================================
> --- ipset.orig/src/ipset.c
> +++ ipset/src/ipset.c
> @@ -208,7 +208,6 @@ call_parser(int *argc, char *argv[], con
>  {
>  	int i = 1, ret = 0;
>  	const struct ipset_arg *arg;
> -	const char *optstr;
>  	
>  	/* Currently CREATE and ADT may have got additional arguments */
>  	if (!args)
> @@ -221,7 +220,6 @@ call_parser(int *argc, char *argv[], con
>  				i++;
>  				continue;
>  			}
> -			optstr = argv[i];
>  			/* Shift off matched option */
>  			D("match %s", arg->name[0]);
>  			ipset_shift_argv(argc, argv, i);
> @@ -236,10 +234,7 @@ call_parser(int *argc, char *argv[], con
>  				/* Fall through */
>  			case IPSET_OPTIONAL_ARG:
>  				if (i + 1 <= *argc) {
> -					ret = ipset_call_parser(session,
> -							arg->parse,
> -							optstr, arg->opt,
> -							argv[i]);
> +					ret = ipset_call_parser(session, arg, argv[i]);
>  					if (ret < 0)
>  						return ret;
>  					ipset_shift_argv(argc, argv, i);
> @@ -247,10 +242,7 @@ call_parser(int *argc, char *argv[], con
>  				}
>  				/* Fall through */
>  			default:
> -				ret = ipset_call_parser(session,
> -							arg->parse,
> -							optstr, arg->opt,
> -							optstr);
> +				ret = ipset_call_parser(session, arg, argv[1]);

We can't do this, because then the flag-style options (no arg) cannot be 
parsed. So I cannot apply this patch and the next two ones based on it.

>  				if (ret < 0)
>  					return ret;
>  			}
> Index: ipset/include/libipset/parse.h
> ===================================================================
> --- ipset.orig/include/libipset/parse.h
> +++ ipset/include/libipset/parse.h
> @@ -17,6 +17,7 @@
>  #define IPSET_PROTO_SEPARATOR	":"
>  
>  struct ipset_session;
> +struct ipset_arg;
>  
>  typedef int (*ipset_parsefn)(struct ipset_session *s,
>  			     enum ipset_opt opt, const char *str);
> @@ -84,8 +85,8 @@ extern int ipset_parse_ignored(struct ip
>  extern int ipset_parse_elem(struct ipset_session *session,
>                              enum ipset_opt opt, const char *str);
>  extern int ipset_call_parser(struct ipset_session *session,
> -			     ipset_parsefn parse, const char *optstr,
> -			     enum ipset_opt optional, const char *str);
> +							 const struct ipset_arg *arg,
> +							 const char *str);
>  
>  /* Compatibility parser functions */
>  extern int ipset_parse_iptimeout(struct ipset_session *session,
> Index: ipset/lib/parse.c
> ===================================================================
> --- ipset.orig/lib/parse.c
> +++ ipset/lib/parse.c
> @@ -1416,15 +1416,14 @@ ipset_parse_ignored(struct ipset_session
>   */
>  int
>  ipset_call_parser(struct ipset_session *session,
> -		  ipset_parsefn parse, const char *optstr,
> -		  enum ipset_opt opt, const char *str)
> +				  const struct ipset_arg *arg,
> +				  const char *str)
>  {
>  	if (ipset_data_flags_test(ipset_session_data(session),
> -				  IPSET_FLAG(opt)))
> -		syntax_err("%s already specified", optstr);
> +				  IPSET_FLAG(arg->opt)))
> +		syntax_err("%s already specified", arg->name[0]);
>  
> -	return parse(session, opt, parse == ipset_parse_ignored
> -				   ? optstr : str);
> +	return arg->parse(session, arg->opt, str);
>  }
>  
>  #define parse_elem(s, t, d, str)					\

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
