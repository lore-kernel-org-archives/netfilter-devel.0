From: Jim Robinson <jrobinson@infoblox.com>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Mon, 24 Sep 2012 13:34:58 -0700
Message-ID: <5060C3F2.9020901@infoblox.com>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr> <1348302412-2811-1-git-send-email-jengelh@inai.de> <58f14b4c-67ab-48aa-bbaf-3ce244500b93@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>, <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.infoblox.com ([205.234.19.209]:53911 "EHLO mx1.infoblox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab2IXUfG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:35:06 -0400
In-Reply-To: <58f14b4c-67ab-48aa-bbaf-3ce244500b93@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


[Retry with text formatting to try to make the vger.kernel.org spam 
filter happy this time]


Patrick McHardy wrote:
 >
 > Jan Engelhardt <jengelh@inai.de> schrieb:
 >
 >> Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
 >> a running state is saved to userspace and then reinstated from there.
 >>
 >> Make sure that priv is initialized with some values when that happens.
 >>
 >> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
 >> ---
 >> net/netfilter/xt_limit.c |    8 ++++----
 >> 1 file changed, 4 insertions(+), 4 deletions(-)
 >>
 >> diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
 >> index 5c22ce8..a4c1e45 100644
 >> --- a/net/netfilter/xt_limit.c
 >> +++ b/net/netfilter/xt_limit.c
 >> @@ -117,11 +117,11 @@ static int limit_mt_check(const struct
 >> xt_mtchk_param *par)
 >>
 >>     /* For SMP, we only want to use one set of state. */
 >>     r->master = priv;
 >> +    /* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
 >> +       128. */
 >> +    priv->prev = jiffies;
 >> +    priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 >>     if (r->cost == 0) {
 >> -        /* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
 >> -           128. */
 >> -        priv->prev = jiffies;
 >> -        priv->credit = user2credits(r->avg * r->burst); /* Credits 
full. */
 >>         r->credit_cap = priv->credit; /* Credits full. */
 >>         r->cost = user2credits(r->avg);
 >>     }
 > I don't think we can do any better than this. We could reuse the old 
state from userspace, but that might have changed in the kernel as well.
 >
 > Perhaps for the future we can find some way to optionally associate 
elements of the new ruleset with the old one and keep states when 
parameters haven't changed. Probably hard though since the new ruleset 
is constructed in the kernel while the old one is still active.
 >

Can you possibly elaborate on why my initial patch does not actually fix 
the problem? Specifically, the concern seems to be that the values in 
'r->master' in limit_mt_check() may not be reliable. In my testing I saw 
that r->master was the same (both address and values) as had been being 
used in limit_mt() calls for the rule. So if you could elaborate on the 
circumstances that could cause the values to not be the same, it would 
be appreciated.  In particular I don't understand the reference to 
'userspace'.

Below is the debugging trace I included as one the attachments I sent. 
It shows the calls applied to the same rate limit rule. Note that 
'r->master' in limit_mt_check() is the same address as 'r->master' in 
the previous limit_mt() calls. My testing indicated that the values were 
the same as well. Also note that the call to limit_mt_check() was 
triggered by an iptables change unrelated to that rule.

BTW, I am not at all saying you're wrong - you're the experts here. I'm 
just trying to understand why my patch doesn't actually fix the problem. 
This is for my own benefit and also because I'll have to explain it to 
my own powers-that-be, since the proposed fix basically resets the 
values and will guarantee a match in the next mt_limit() call(s) 
regardless of what should actually happen.

And as something of an aside, can you say why limit_mt_check() is called 
on all the rate limit rules when an unrelated iptables change occurs? 
This is what I observed.

Thanks
Jim

     limit_mt(): par=ffff880028203bd0 r=ffffc90003cfb138 
master=ffff88020f930fa0
     limit_mt(): par=ffff880028203bd0 r=ffffc90003cfb138 
master=ffff88020f930fa0
     limit_mt(): par=ffff880028203bd0 r=ffffc90003cfb138 
master=ffff88020f930fa0
     # bug triggered here
     limit_mt_check(): par=ffff880176a3bd98 r=ffffc90003d39138 
master=ffff88020f930fa0
                       new-master=ffff88020f930140 [this is the 
kmalloc()ed 'priv']
     limit_mt_destroy(): par=ffff880176a3bd38 r=ffffc90003cfb138 
master=ffff88020f930fa0
     limit_mt(): par=ffff880028203bd0 r=ffffc90003d39138 
master=ffff88020f930140
     limit_mt(): par=ffff880028203bd0 r=ffffc90003d39138 
master=ffff88020f930140
     limit_mt(): par=ffff880028203bd0 r=ffffc90003d39138 
master=ffff88020f930140




