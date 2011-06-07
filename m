From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-multi: fix absence of xml translator in IPv6-only
 builds
Date: Tue, 7 Jun 2011 11:29:33 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106071129230.25037@frira.zrqbmnf.qr>
References: <1307410029-6104-1-git-send-email-zenczykowski@gmail.com> <alpine.LNX.2.01.1106071110580.25037@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56469 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1FGJ3e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:29:34 -0400
In-Reply-To: <alpine.LNX.2.01.1106071110580.25037@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-07 11:12, Jan Engelhardt wrote:

>On Tuesday 2011-06-07 03:27, Maciej =C5=BBenczykowski wrote:
>
>>index 0000000..615724b
>>--- /dev/null
>>+++ b/xtables-multi.h
>>@@ -0,0 +1,6 @@
>>+#ifndef _XTABLES_MULTI_H
>>+#define _XTABLES_MULTI_H 1
>>+
>>+extern int iptables_xml_main(int, char **);
>>+
>>+#endif /* _XTABLES_MULTI_H */
>=20
>Simply put this in xshared.h.

Applied anyway, cleanup follows later.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
