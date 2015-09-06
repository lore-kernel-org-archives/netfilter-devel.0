From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables: Spelling fixes
Date: Sun, 6 Sep 2015 09:15:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr>
References: <20150905210746.GA13600@salvia> <1441520550-526-1-git-send-email-ville.skytta@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Ville_Skytt=C3=A4?= <ville.skytta@iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:36190 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbbIFHPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2015 03:15:55 -0400
In-Reply-To: <1441520550-526-1-git-send-email-ville.skytta@iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2015-09-06 08:22, Ville Skytt=C3=A4 wrote:
>=20
>-/* print a given ip including mask if neccessary */
>+/* Print a given ip including mask if necessary.
>+ */
> static void print_ip(const char *prefix, const struct in6_addr *ip,
> 		     const struct in6_addr *mask, int invert)
> {

Hm that really looks worse than it did before.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
