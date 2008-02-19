From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER 07/07]: Use __u32 in struct nf_inet_addr
Date: Tue, 19 Feb 2008 18:11:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802191808540.26109@fbirervta.pbzchgretzou.qr>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
 <20080219162541.13631.48514.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37734 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYBSRLi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:11:38 -0500
In-Reply-To: <20080219162541.13631.48514.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 19 2008 17:25, Patrick McHardy wrote:
>[NETFILTER]: Use __u32 in struct nf_inet_addr
>
>As reported by David Woodhouse <dwmw2@infradead.org>, using u_int32_t =
in
>struct nf_inet_addr breaks the busybox build. Fix by using __u32.

=2E.. that's why I say we should use uint32_t (with just one underscore=
),
because that is available in userspace thorugh <stdint.h>,
while u_int32_t is not (at first glance=C2=B2).


=C2=B2 db1/db.h and ALSA do seem to use it, though.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
