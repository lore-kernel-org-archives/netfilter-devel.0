From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in death_by_timeout()
Date: Tue, 25 Nov 2008 12:11:13 +0100
Message-ID: <492BDD51.2020306@trash.net>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net> <4922C2D0.9060207@trash.net> <20081125080903.GA3195@zebra.home>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050007050807090008040403"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55585 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYKYLLY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:11:24 -0500
In-Reply-To: <20081125080903.GA3195@zebra.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050007050807090008040403
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

BORBELY Zoltan wrote:
> Hi,
> 
> On Tue, Nov 18, 2008 at 02:27:44PM +0100, Patrick McHardy wrote:
>> Could you try whether this patch fixes the problem?
>>
> We didn't see any kernel crashes during a half day heavy work (without the
> patch the kernel crashed in 3-4 hours every time), but we found a lot of
> BUG messages in the log (maybe for every new entry):
> 
>     Nov 24 14:45:43 test kernel: BUG: sleeping function called from invalid context at mm/slab.c:3043
>     Nov 24 14:45:43 test kernel: in_atomic():1, irqs_disabled():0
>     Nov 24 14:45:43 test kernel: 3 locks held by test/3586:
>     Nov 24 14:45:43 test kernel:  #0:  (nfnl_mutex){--..}, at: [<d081500f>] nfnetlink_rcv+0xf/0x30 [nfnetlink]
>     Nov 24 14:45:43 test kernel:  #1:  (nf_conntrack_lock){-+..}, at: [<d08c979f>] ctnetlink_new_conntrack+0x7f/0x770 [nf_conntrack_netlink]
>     Nov 24 14:45:43 test kernel:  #2:  (rcu_read_lock){..--}, at: [<d08c98ee>] ctnetlink_new_conntrack+0x1ce/0x770 [nf_conntrack_netlink]

Crap, I missed a spot. Does this patch help?



--------------050007050807090008040403
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3b009a3..5f4a651 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1138,7 +1138,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		}
 	}
 
-	nf_ct_acct_ext_add(ct, GFP_KERNEL);
+	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])

--------------050007050807090008040403--
