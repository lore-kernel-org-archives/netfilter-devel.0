From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4] xt_log: Make printk() in sb_close() optional
Date: Tue, 14 Feb 2012 01:12:48 +0100
Message-ID: <20120214001248.GB24194@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-6-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
	jengelh@medozas.de, rostedt@goodmis.org, basti@b-bl.de
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566Ab2BNAMu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:12:50 -0500
Content-Disposition: inline
In-Reply-To: <1328911856-19260-6-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 10, 2012 at 11:10:55PM +0100, Richard Weinberger wrote:
> Make printk() in sb_close() optional such that other modules
> can build a log string without printing it using printk().

Applied, thanks.
