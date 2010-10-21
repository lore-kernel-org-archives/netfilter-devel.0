From: Regid Ichira <regid.i@hotmail.com>
Subject: [PATCH] iptables/extensions/libipt_icmp.c: Add numeric values to
 the output of iptables -p icmp -h
Date: Fri, 22 Oct 2010 00:35:22 +0200
Message-ID: <COL119-W2688936E4B76AA876D401DF55D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from col0-omc1-s1.col0.hotmail.com ([65.55.34.11]:16269 "EHLO
	col0-omc1-s1.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221Ab0JUWfX convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:35:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


=A0 I think the addition of numeric types/codes to the output of=20
=A0=A0=A0 iptables -p icmp -h
would make it clearer, in particular when referring to other texts.
=20
--- extensions/libipt_icmp.c.orig=A0=A0=A0=A0=A0=A0 2010-10-21 04:43:27=
=2E000000000 +0300
+++ extensions/libipt_icmp.c=A0=A0=A0 2010-10-21 14:31:15.000000000 +03=
00
@@ -81,7 +81,7 @@
=A0print_icmptypes(void)
=A0{
=A0=A0=A0=A0=A0=A0=A0 unsigned int i;
-=A0=A0=A0=A0=A0=A0 printf("Valid ICMP Types:");
+=A0=A0=A0=A0=A0=A0 printf("Valid, numeric values and named, ICMP Types=
 and codes:");
=20
=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < ARRAY_SIZE(icmp_codes); ++i) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (i && icmp_codes[i].ty=
pe =3D=3D icmp_codes[i-1].type) {
@@ -90,10 +90,12 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 =3D=3D icmp_codes[i-1].code_max))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 printf(" (%s)", icmp_codes[i].name);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 e=
lse
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 printf("\n=A0=A0 %s", icmp_codes[i].name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 printf("\n%5s%2u%2s%s", "", icmp_codes[i].code_min,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 "", icmp_codes[i].name);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pri=
ntf("\n%s", icmp_codes[i].name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pri=
ntf("\n%2s%3u%2s%s", "", icmp_codes[i].type,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "", =
icmp_codes[i].name);
=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 printf("\n");
=A0} 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
