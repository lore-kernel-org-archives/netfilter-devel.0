From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: fix lookup of tcp port names
Date: Fri, 28 Oct 2011 22:26:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1110282224490.3090@blackhole.kfki.hu>
References: <20111028181613.6702aeb7@s6510.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20111028181613.6702aeb7@s6510.linuxnetplumber.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Stephen,

On Fri, 28 Oct 2011, Stephen Hemminger wrote:

> The protocol argument to getservbyname() must be lowercase tcp not
> uppercase TCP. This fixes the bug observed by:
> 
>  # ipset add foo http
>  ipset v6.9.1: Syntax error: 'http' is invalid as number
>  Syntax error: cannot parse 'http' as a TCP port
> ---
>  lib/parse.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/parse.c b/lib/parse.c
> index 241d5ae..3ca702c 100644
> --- a/lib/parse.c
> +++ b/lib/parse.c
> @@ -307,7 +307,7 @@ int
>  ipset_parse_tcp_port(struct ipset_session *session,
>  		     enum ipset_opt opt, const char *str)
>  {
> -	return ipset_parse_tcpudp_port(session, opt, str, "TCP");
> +	return ipset_parse_tcpudp_port(session, opt, str, "tcp");
>  }
>  
>  /**
> @@ -330,7 +330,7 @@ ipset_parse_single_tcp_port(struct ipset_session *session,
>  	assert(opt == IPSET_OPT_PORT || opt == IPSET_OPT_PORT_TO);
>  	assert(str);
>  
> -	return ipset_parse_port(session, opt, str, "TCP");
> +	return ipset_parse_port(session, opt, str, "tcp");
>  }
>  
>  /**
> -- 
> 1.7.2.5

Ohh, thanks! Somehow port names haven't been tested by the testsuite....

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
