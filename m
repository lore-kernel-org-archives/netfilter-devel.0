From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Fwd: Re: [netfilter-core] Bug on conntrack?]
Date: Thu, 19 Nov 2009 17:17:56 +0100
Message-ID: <4B056FB4.4050201@trash.net>
References: <422110e23c4d48d73c9162967345ea58.squirrel@mail.dhost.ro>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010200070803000309050908"
Cc: netfilter-devel@vger.kernel.org
To: alex@dhost.ro
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46096 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZKSQRv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:17:51 -0500
In-Reply-To: <422110e23c4d48d73c9162967345ea58.squirrel@mail.dhost.ro>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010200070803000309050908
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

alex@dhost.ro wrote:
>  Hy i'm trying to add a rule in firewall but i receive this error:
> 
>  iptables v1.4.2: conntrack: Bad value for "--expires" option: "1:1000"
>  Try `iptables -h' or 'iptables --help' for more information.
>  iptables v1.4.2: conntrack: Bad value for "--expires" option: "1:1000"
>  Try `iptables -h' or 'iptables --help' for more information.
> 
>  The lines that i want to add are:
>  $IPTABLES -A RST_LOOP_OUT -d $IP_LOOP -p tcp --sport $PORT_LOOP
> --tcp-flags ALL PSH,ACK -m conntrack --ctexpire 1:1000 -j REJECT
> --reject-with tcp-reset
> 
>  $IPTABLES -A RST_LOOP_OUT -d $IP_LOOP -p tcp --sport $PORT_LOOP
> --tcp-flags ALL FIN,PSH,ACK -j REJECT -m conntrack --ctexpire 1:1000
> --reject-with tcp-reset
> 
>  If  i give a single value to --ctexpire it works (ex: --ctexpire 1 ) I've
> searched on google a lot of days but without any result. could you help
> me? Thank's

Does this patch help?


--------------010200070803000309050908
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index d30871f..5ca734d 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -273,7 +273,7 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo2 *info, const char *s)
 		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
 	max = min;
 	if (*end == ':')
-		if (!xtables_strtoui(s, &end, &max, 0, UINT32_MAX))
+		if (!xtables_strtoui(end + 1, &end, &max, 0, UINT32_MAX))
 			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
 	if (*end != '\0')
 		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);

--------------010200070803000309050908--
