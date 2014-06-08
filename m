From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: fix refcnt leak in
 dying/unconfirmed list dumper
Date: Sun, 8 Jun 2014 17:57:04 +0200
Message-ID: <20140608155704.GA4546@localhost>
References: <1402220483-10565-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, brouer@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45804 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaFHP5a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2014 11:57:30 -0400
Content-Disposition: inline
In-Reply-To: <1402220483-10565-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Sun, Jun 08, 2014 at 11:41:23AM +0200, Florian Westphal wrote:
> 'last' keeps track of the ct that had its refcnt bumped during previous
> dump cycle.  Thus it must not be overwritten until end-of-function.
> 
> Another (unrelated, theoretical) issue: Don't attempt to bump refcnt of a conntrack
> whose reference count is already 0.  Such conntrack is being destroyed
> right now, its memory is freed once we release the percpu dying spinlock.

Very good, so the problem I reported was not related to your patchset
itself.

I'm going to resolve conflicts with this:

http://patchwork.ozlabs.org/patch/356346/

Otherwise, conntrack -L dying only shows the initial 17 entries.

Then, I'm going to make a quick test of this here, let's see if we get
to David with these fixes and the removal extra timer in ecache in
time.
