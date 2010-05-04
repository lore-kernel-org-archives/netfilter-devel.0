From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Document --state UNTRACKED
Date: Tue, 4 May 2010 09:13:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005040913330.9626@obet.zrqbmnf.qr>
References: <201005040832.00376.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Simon Lodal <simonl@parknet.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33705 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab0EDHNo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 May 2010 03:13:44 -0400
In-Reply-To: <201005040832.00376.simonl@parknet.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-05-04 08:32, Simon Lodal wrote:

>
>--state UNTRACKED was missing in man page.

As is --ctstate UNTRACKED

>Signed-off-by: Simon Lodal <simonl@parknet.dk>
>
>diff -ruNp a/extensions/libxt_state.man b/extensions/libxt_state.man
>--- a/extensions/libxt_state.man        2010-03-01 15:11:28.000000000 +0100
>+++ b/extensions/libxt_state.man        2010-05-04 08:20:27.000000000 +0200
>@@ -19,3 +19,6 @@ directions, and
> meaning that the packet is starting a new connection, but is
> associated with an existing connection, such as an FTP data transfer,
> or an ICMP error.
>+.B UNTRACKED
>+meaning that the packet is not tracked at all, which happens if you use
>+the NOTRACK target in mangle table.
>
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

