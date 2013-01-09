From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ipset PATCH] Fix wrong bracket placing
Date: Wed, 9 Jan 2013 23:40:51 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301092225080.9826@blackhole.kfki.hu>
References: <1952176.MYFl3FrgUH@storm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60807 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab3AIWky (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:40:54 -0500
In-Reply-To: <1952176.MYFl3FrgUH@storm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thomas,

On Thu, 27 Dec 2012, Thomas Jarosch wrote:

> cppcheck (vaguely) reported:
> [lib/parse.c:448]: (style) Suspicious condition (assignment + comparison); Clarify expression with parentheses.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  lib/parse.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/parse.c b/lib/parse.c
> index 550048c..d06e9cd 100644
> --- a/lib/parse.c
> +++ b/lib/parse.c
> @@ -445,8 +445,8 @@ ipset_parse_proto(struct ipset_session *session,
>  		uint8_t protonum;
>  		int err;
>  
> -		if (!((err = string_to_u8(session, str, &protonum) == 0) &&
> -		      (protoent = getprotobynumber(protonum)) != NULL))
> +		if (!((err = string_to_u8(session, str, &protonum)) == 0) &&
> +		      (protoent = getprotobynumber(protonum)) != NULL)
>  			return syntax_err("cannot parse '%s' "
>  					  "as a protocol", str);
>  	}
> -- 
> 1.7.11.7
> 

Your patch fixes the warning but modifies the condition. So I simplified 
the condition and am going to apply the next patch:

diff --git a/lib/parse.c b/lib/parse.c
index 550048c..951d2f3 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -442,11 +442,10 @@ ipset_parse_proto(struct ipset_session *session,
        protoent = getprotobyname(strcasecmp(str, "icmpv6") == 0
                                  ? "ipv6-icmp" : str);
        if (protoent == NULL) {
-               uint8_t protonum;
-               int err;
+               uint8_t protonum = 0;
 
-               if (!((err = string_to_u8(session, str, &protonum) == 0) &&
-                     (protoent = getprotobynumber(protonum)) != NULL))
+               if (string_to_u8(session, str, &protonum) ||
+                   (protoent = getprotobynumber(protonum)) == NULL)
                        return syntax_err("cannot parse '%s' "
                                          "as a protocol", str);
        }

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
