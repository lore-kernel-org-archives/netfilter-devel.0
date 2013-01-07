From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: arptables bug.
Date: Mon, 7 Jan 2013 04:24:15 +0100
Message-ID: <20130107032415.GA18563@1984>
References: <201301052056.18524.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33097 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab3AGDYT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:24:19 -0500
Content-Disposition: inline
In-Reply-To: <201301052056.18524.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 05, 2013 at 08:56:18PM +0000, Steven Jan Springl wrote:
> Hello
> 
> I am using arptables v0.0.3.4 in Debian Squeeze.
> 
> Issuing command:
> 
> aptables -A INPUT -i eth0 --opcode ! 1 -j DROP
> 
> Then issuing command arptables-save produces the following:
> 
> -A INPUT -j DROP -i eth0  --opcode 1
> 
> The "!" is missing from the opcode.

Patch attached to fix it.

Bart, could you please apply this to your git repo? Thanks.

--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-arptables-fix-opcode-1-in-L-n-output.patch"

>From b83962f7ad5b65468d6e1ce099e970afd336c3b1 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 7 Jan 2013 04:14:22 +0100
Subject: [PATCH] arptables: fix ! --opcode 1 in -L -n output

The imbalance in the array is likely to fix the negation of:

--h-type, --proto-type, -i and -o.
---
 userspace/arptables/arptables.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/userspace/arptables/arptables.c b/userspace/arptables/arptables.c
index 2f048c7..29ccd22 100644
--- a/userspace/arptables/arptables.c
+++ b/userspace/arptables/arptables.c
@@ -204,6 +204,7 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* 2 */ ARPT_INV_SRCDEVADDR,
 /* 3 */ ARPT_INV_TGTDEVADDR,
 /* -l */ ARPT_INV_ARPHLN,
+	0,
 /* 4 */ ARPT_INV_ARPOP,
 /* 5 */ ARPT_INV_ARPHRD,
 /* 6 */ ARPT_INV_ARPPRO,
-- 
1.7.10.4


--RnlQjJ0d97Da+TV1--
