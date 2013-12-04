From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: nft: fix memory leaks in nft_fini
Date: Wed, 4 Dec 2013 12:25:16 +0100
Message-ID: <20131204112516.GA12780@localhost>
References: <1385981114-3131-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41977 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab3LDLZV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:25:21 -0500
Content-Disposition: inline
In-Reply-To: <1385981114-3131-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 02, 2013 at 11:45:14AM +0100, Ana Rey wrote:
> Those errors are shown with valgrind tool:
> 
> valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80
> 
> ==12554== 40 bytes in 1 blocks are still reachable in loss record 1 of 10
> ==12554==    at 0x4C2935B: malloc (vg_replace_malloc.c:270)
> ==12554==    by 0x574D755: mnl_nlmsg_batch_start (nlmsg.c:447)
> ==12554==    by 0x416520: nft_action (nft.c:2281)
> ==12554==    by 0x41355E: xtables_main (xtables-standalone.c:75)
> ==12554==    by 0x5B87994: (below main) (libc-start.c:260)
> 
> ==12554== 135,168 bytes in 1 blocks are still reachable in loss record 9 of 10
> ==12554==    at 0x4C2935B: malloc (vg_replace_malloc.c:270)
> ==12554==    by 0x415A24: mnl_nft_batch_alloc (nft.c:102)
> ==12554==    by 0x416520: nft_action (nft.c:2281)
> ==12554==    by 0x41355E: xtables_main (xtables-standalone.c:75)
> ==12554==    by 0x5B87994: (below main) (libc-start.c:260)
> 
> These objects are allocated from nft_init but they were not released
> appropriately in the exit path.

Applied, thanks.
