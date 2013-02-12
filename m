From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ctnetlink: don't permit ct creation with
 random tuple
Date: Tue, 12 Feb 2013 23:35:49 +0100
Message-ID: <20130212223549.GA7045@localhost>
References: <1360660958-29494-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:42857 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751319Ab3BLWfx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:35:53 -0500
Content-Disposition: inline
In-Reply-To: <1360660958-29494-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 12, 2013 at 10:22:38AM +0100, Florian Westphal wrote:
> Userspace can cause kernel panic by not specifying orig/reply
> tuple: kernel will create a tuple with random stack values.
> 
> Problem is that tuple.dst.dir will be random, too, which
> causes nf_ct_tuplehash_to_ctrack() to return garbage.

Applied, thanks Florian.
