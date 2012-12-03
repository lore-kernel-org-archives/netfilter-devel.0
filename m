From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove extra timer from ecache extension
Date: Mon, 3 Dec 2012 19:32:14 +0100
Message-ID: <20121203183214.GA23029@1984>
References: <1354306565-2289-1-git-send-email-fw@strlen.de>
 <20121203143933.GB5599@1984>
 <20121203151706.GD11627@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44544 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2LCScR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:32:17 -0500
Content-Disposition: inline
In-Reply-To: <20121203151706.GD11627@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 03, 2012 at 04:17:06PM +0100, Florian Westphal wrote:
[...]
> I can re-spin the patch on top of your dying-list changes, if
> you prefer to test all patches at the same time.

Please, do so. You can use nf-next tree, I have applied those to it.

As promised, I'll send a follow-up patch to fix the issue that you
spotted regarding the dying list and the output path of nf_conntrack.

Thanks.
