From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: problem with xtables-addons and CentOS 5.3
Date: Tue, 28 Apr 2009 01:43:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904280110180.30770@fbirervta.pbzchgretzou.qr>
References: <49F49944.3010800@solutti.com.br> <alpine.LSU.2.00.0904271110320.6706@fbirervta.pbzchgretzou.qr> <49F582F4.5080604@solutti.com.br> <alpine.LSU.2.00.0904271224480.6706@fbirervta.pbzchgretzou.qr> <49F61DF9.4060508@solutti.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ML netfilter-devel <netfilter-devel@vger.kernel.org>
To: Leonardo Rodrigues <leolistas@solutti.com.br>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44380 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZD0Xnl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:43:41 -0400
In-Reply-To: <49F61DF9.4060508@solutti.com.br>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-04-27 23:04, Leonardo Rodrigues wrote:
>
>=C2=A0=C2=A0=C2=A0 after compiling a vanilla kernel, i could successfu=
lly compile
>xtables-addons 1.14 on CentOS 5.3 x86_64 box.
>
>=C2=A0=C2=A0=C2=A0 Jan .... what do you thinkg about changing the warn=
ing
>
>echo "WARNING: This distribution is not officially supported.";
>
>=C2=A0=C2=A0=C2=A0 to something like:
>
>echo "WARNING: This distribution is not officially supported when usin=
g
>CentOS/RHEL supplied kernel.";
>echo "When using a kernel compiled from scratch, from official kernel
>sources (not CentOS/RHEL ones),"
>echo "xtables-addons can be compiled and works fine."


Ok so I changed it, because accuracy is in my interest.

-echo "WARNING: This distribution is not officially supported.";
+echo "WARNING: This distribution's shipped kernel is not supported.";
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
