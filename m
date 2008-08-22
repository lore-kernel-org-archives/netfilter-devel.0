From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Patch] fix one typo
Date: Fri, 22 Aug 2008 12:59:30 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808221258560.10702@fbirervta.pbzchgretzou.qr>
References: <20080822163240.GH3053@hack.voiplan.pt>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: WANG Cong <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36176 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYHVQ7c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:59:32 -0400
In-Reply-To: <20080822163240.GH3053@hack.voiplan.pt>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-22 12:32, WANG Cong wrote:
>
>Fix a typo in a man page.
>
>Signed-off-by: WANG Cong <wangcong@zeuux.org>
>
>---
>diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
>index b087fc9..4b7b2d1 100644
>--- a/extensions/libxt_tcp.man
>+++ b/extensions/libxt_tcp.man
>@@ -7,7 +7,7 @@ name or a port number. An inclusive range can also be specified,
> using the format \fIport\fP\fB:\fP\fIport\fP.
> If the first port is omitted, "0" is assumed; if the last is omitted,
> "65535" is assumed.
>-If the second port greater then the first they will be swapped.
>+If the second port greater than the first they will be swapped.

Hehe... there's more than just that, an "is" and a comma!

  If the second port is greater than the first, they will be swapped.
