From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 3/3] Make use of pr_fmt where applicable
Date: Tue, 4 Nov 2014 17:50:32 +0100
Message-ID: <20141104165032.GA18775@salvia>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
 <40d37c4aa802e3ad7572b6818624f36abefc1791.1414586968.git.mleitner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42475 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbaKDQsv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:48:51 -0500
Content-Disposition: inline
In-Reply-To: <40d37c4aa802e3ad7572b6818624f36abefc1791.1414586968.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 29, 2014 at 10:51:15AM -0200, Marcelo Ricardo Leitner wrote:
> And also remove PRINTR macro, as it was used only once, wasn't helping
> much and was actually making it harder to use pr_err().

I like this one, but it seems to depend on the previous :-(.

git am /tmp/v4-3-3-Make-use-of-pr_fmt-where-applicable.patch
Applying: Make use of pr_fmt where applicable
error: patch failed: net/netfilter/nfnetlink_log.c:583
error: net/netfilter/nfnetlink_log.c: patch does not apply
Patch failed at 0001 Make use of pr_fmt where applicable
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

Would you resend? Thanks!
