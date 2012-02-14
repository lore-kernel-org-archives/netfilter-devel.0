From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4] ring_buffer: Export for_each_buffer_cpu()
Date: Tue, 14 Feb 2012 01:05:38 +0100
Message-ID: <20120214000538.GB24029@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-5-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
	jengelh@medozas.de, rostedt@goodmis.org, basti@b-bl.de
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42704 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab2BNAFl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:05:41 -0500
Content-Disposition: inline
In-Reply-To: <1328911856-19260-5-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 10, 2012 at 11:10:54PM +0100, Richard Weinberger wrote:
> In order to make ring_buffer usable to other modules
> for_each_buffer_cpu() needs to be exported.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I've taken this one as well since we need it for the ring_buffer
support for your extension for xt_LOG.
