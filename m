From: "Nishit Shah" <nishit@elitecore.com>
Subject: Re: rmmod ip_conntrack hangs.....
Date: Fri, 12 Oct 2007 20:32:06 +0530
Message-ID: <008a01c80ce0$dab87b30$4c01a8c0@elitecore.com>
References: <075601c78707$5d19c800$4c01a8c0@elitecore26>	<200704261105.l3QB59NB010836@toshiba.co.jp>    <08c701c787fc$c874e1c0$4c01a8c0@elitecore26>    <4630D096.5070706@trash.net>    <048501c80812$0d372350$4c01a8c0@elitecore.com>    <4709B274.1090102@trash.net> <1856.59.95.206.53.1192043722.squirrel@203.88.135.194> <470DB193.7020806@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0087_01C80D0E.F46BFC40"
Cc: "Yasuyuki KOZAKAI" <yasuyuki.kozakai@toshiba.co.jp>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:52124 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753904AbXJLPDJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:03:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0087_01C80D0E.F46BFC40
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

Sorry for that !!!!!
                                    I am adding the attachment !!!!

Rgds,
Nishit Shah.

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: <nishit@elitecore.com>
Cc: "Yasuyuki KOZAKAI" <yasuyuki.kozakai@toshiba.co.jp>; "Netfilter
Development Mailinglist" <netfilter-devel@vger.kernel.org>
Sent: Thursday, October 11, 2007 10:46 AM
Subject: Re: rmmod ip_conntrack hangs.....


> nishit@elitecore.com wrote:
> > Hi,
> >          I am adding the patch that patrick had submitted.
>
>
> The patch doesn't apply because your mailer replaced tabs by spaces.
> Please resend as attachment, thanks.
>

------=_NextPart_000_0087_01C80D0E.F46BFC40
Content-Type: application/octet-stream;
	name="rmmod_conntrack"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="rmmod_conntrack"

diff -Paur =
linux-2.6.16.13/include/linux/netfilter_ipv4/ip_conntrack_core.h =
linux-2.6.16.13-dev/include/linux/netfilter_ipv4/ip_conntrack_core.h=0A=
--- linux-2.6.16.13/include/linux/netfilter_ipv4/ip_conntrack_core.h	Wed =
May  3 03:08:44 2006=0A=
+++ linux-2.6.16.13-dev/include/linux/netfilter_ipv4/ip_conntrack_core.h	=
Fri Oct 12 19:39:45 2007=0A=
@@ -45,7 +45,7 @@=0A=
 	int ret =3D NF_ACCEPT;=0A=
 =0A=
 	if (ct) {=0A=
-		if (!is_confirmed(ct))=0A=
+		if (!is_confirmed(ct) && !is_dying(ct))=0A=
 			ret =3D __ip_conntrack_confirm(pskb);=0A=
 		ip_ct_deliver_cached_events(ct);=0A=
 	}=0A=
diff -Paur linux-2.6.16.13/include/net/netfilter/nf_conntrack_core.h =
linux-2.6.16.13-dev/include/net/netfilter/nf_conntrack_core.h=0A=
--- linux-2.6.16.13/include/net/netfilter/nf_conntrack_core.h	Wed May  3 =
03:08:44 2006=0A=
+++ linux-2.6.16.13-dev/include/net/netfilter/nf_conntrack_core.h	Fri =
Oct 12 19:40:52 2007=0A=
@@ -61,7 +61,7 @@=0A=
 	int ret =3D NF_ACCEPT;=0A=
 =0A=
 	if (ct) {=0A=
-		if (!nf_ct_is_confirmed(ct))=0A=
+		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))=0A=
 			ret =3D __nf_conntrack_confirm(pskb);=0A=
 		nf_ct_deliver_cached_events(ct);=0A=
 	}=0A=
diff -Paur linux-2.6.16.13/net/ipv4/netfilter/ip_conntrack_core.c =
linux-2.6.16.13-dev/net/ipv4/netfilter/ip_conntrack_core.c=0A=
--- linux-2.6.16.13/net/ipv4/netfilter/ip_conntrack_core.c	Wed May  3 =
03:08:44 2006=0A=
+++ linux-2.6.16.13-dev/net/ipv4/netfilter/ip_conntrack_core.c	Fri Oct =
12 19:30:38 2007=0A=
@@ -1251,11 +1251,18 @@=0A=
 		if (h)=0A=
 			break;=0A=
 	}=0A=
-	if (!h)=0A=
+	if (!h){=0A=
 		h =3D LIST_FIND_W(&unconfirmed, do_iter,=0A=
 				struct ip_conntrack_tuple_hash *, iter, data);=0A=
-	if (h)=0A=
+		if (h){=0A=
+			struct ip_conntrack * ct =3D tuplehash_to_ctrack(h);=0A=
+			if (iter(ct, data))=0A=
+				set_bit(IPS_DYING_BIT, &ct->status);=0A=
+		}=0A=
+		h =3D NULL;=0A=
+	}else{=0A=
 		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);=0A=
+	}=0A=
 	write_unlock_bh(&ip_conntrack_lock);=0A=
 =0A=
 	return h;=0A=
diff -Paur linux-2.6.16.13/net/netfilter/nf_conntrack_core.c =
linux-2.6.16.13-dev/net/netfilter/nf_conntrack_core.c=0A=
--- linux-2.6.16.13/net/netfilter/nf_conntrack_core.c	Wed May  3 =
03:08:44 2006=0A=
+++ linux-2.6.16.13-dev/net/netfilter/nf_conntrack_core.c	Fri Oct 12 =
19:38:23 2007=0A=
@@ -1504,11 +1504,18 @@=0A=
 		if (h)=0A=
 			break;=0A=
  	}=0A=
-	if (!h)=0A=
+	if (!h){=0A=
 		h =3D LIST_FIND_W(&unconfirmed, do_iter,=0A=
 				struct nf_conntrack_tuple_hash *, iter, data);=0A=
-	if (h)=0A=
+		if (h){=0A=
+			struct nf_conn *ct =3D nf_ct_tuplehash_to_ctrack(h);=0A=
+			if (iter(ct, data))=0A=
+				set_bit(IPS_DYING_BIT, &ct->status);=0A=
+		}=0A=
+		h =3D NULL;=0A=
+	}else{=0A=
 		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);=0A=
+	}=0A=
 	write_unlock_bh(&nf_conntrack_lock);=0A=
 =0A=
 	return h;=0A=

------=_NextPart_000_0087_01C80D0E.F46BFC40--

