From: <gregkh@suse.de>
Subject: patch nf_nat-fix-memset-error.patch queued to -stable tree
Date: Tue, 11 Dec 2007 16:01:38 -0800
Message-ID: <20071212000233.788C01454450@imap.suse.de>
References: <474D2D3B.5030909@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: lizf@cn.fujitsu.com, davem@davemloft.net, gregkh@suse.de,
	kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbXLLACf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:02:35 -0500
In-Reply-To: <474D2D3B.5030909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: nf_nat: fix memset error

to the 2.6.23-stable tree.  Its filename is

     nf_nat-fix-memset-error.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Wed Nov 28 00:56:55 2007
From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 28 Nov 2007 09:56:27 +0100
Subject: nf_nat: fix memset error
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <474D2D3B.5030909@trash.net>

From: Li Zefan <lizf@cn.fujitsu.com>

This patch fixes an incorrect memset in the NAT code, causing
misbehaviour when unloading and reloading the NAT module.
Applies to stable-2.6.22 and stable-2.6.23.

Please apply, thanks.
[NETFILTER]: nf_nat: fix memset error

Upstream commit e0bf9cf15fc30d300b7fbd821c6bc975531fab44

The size passing to memset is the size of a pointer. Fixes
misbehaviour when unloading and reloading the NAT module.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -681,7 +681,7 @@ static int clean_nat(struct nf_conn *i, 
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }


Patches currently in stable-queue which might be from lizf@cn.fujitsu.com are

queue-2.6.23/nf_nat-fix-memset-error.patch
