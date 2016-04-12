From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] NFQUEUE: Fix bug with order of fanout and bypass
Date: Tue, 12 Apr 2016 19:56:41 +0200
Message-ID: <20160412175641.GB4311@breakpoint.cc>
References: <20160412171857.GA9814@shivani>
 <20160412172837.GA4311@breakpoint.cc>
 <CAKHNQQEaV9-DWByD7vaxQYL5nPKjAvZyo_3YKxMGGGCLyUCkRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37489 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964927AbcDLR4o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 13:56:44 -0400
Content-Disposition: inline
In-Reply-To: <CAKHNQQEaV9-DWByD7vaxQYL5nPKjAvZyo_3YKxMGGGCLyUCkRA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> > I think that this would make it a bit clearer and
> > it also avoids the v3/v2/v1 stacking.
> >
> Sure.
> Just to make sure I get this right, should I be using two objects of
> structures xt_NFQ_info_v3 and xt_NFQ_info_v2 (since v3 does not have
> bypass) and make switch cases accordingly in v3?

I meant something like this (untested):

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 8115457..9750ce0 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -108,11 +108,14 @@ static void NFQUEUE_parse_v3(struct xt_option_call *cb)
 {
 	struct xt_NFQ_info_v3 *info = cb->data;
 
-	NFQUEUE_parse_v2(cb);
+	NFQUEUE_parse_v1(cb);
 	switch (cb->entry->id) {
 	case O_QUEUE_CPU_FANOUT:
 		info->flags |= NFQ_FLAG_CPU_FANOUT;
 		break;
+	case O_QUEUE_BYPASS:
+		info->flags |= NFQ_FLAG_BYPASS;
+		break;
 	}
 }

> Should I be doing this for all the functions (save, xlate, print)
> since the same stacking is there too?

Hmm, I think it would make sense to disentangle this as well
(as a 2nd cleanup patch).

The ->bypass/->flag overloading works but its not really obvious...

I don't have a strong opinion however, if you think your v1 patch
is ok I'm fine with it as well.
