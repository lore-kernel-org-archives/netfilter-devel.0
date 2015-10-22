From: Alin Nastac <alin.nastac@gmail.com>
Subject: [PATCH] ebtables: Allow RETURN target rules in user defined chains
Date: Thu, 22 Oct 2015 16:41:03 +0200
Message-ID: <5628F57F.1010504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33811 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964939AbbJVOlH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Oct 2015 10:41:07 -0400
Received: by wikq8 with SMTP id q8so35311458wik.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2015 07:41:05 -0700 (PDT)
Received: from cplx250.edegem.eu.thmulti.com (14.125.146.82.ipv4.evonet.be. [82.146.125.14])
        by smtp.gmail.com with ESMTPSA id jd7sm17237639wjb.19.2015.10.22.07.41.04
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 22 Oct 2015 07:41:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebtables has a bug that prevents creation of rules with RETURN target, any attempt will result in an
    RETURN not allowed on base chain
error even if the chain where you want to create the rule is a user defined chain.

Reproduction scenario:
    root@OpenWrt:~# ebtables -N foo
    root@OpenWrt:~# ebtables -A OUTPUT -j foo
    root@OpenWrt:~# ebtables -A foo -j mark --mark-or 3 --mark-target RETURN
    --mark-target RETURN not allowed on base chain.

My email client will probably replace tabs in the patch below, but it is a one-liner patch after all, easy to spot the actual 
change.

diff --git a/libebtc.c b/libebtc.c
--- a/libebtc.c
+++ b/libebtc.c
@@ -1102,7 +1102,7 @@ void ebt_check_for_loops(struct ebt_u_replace *replace)
                         /* check if we've dealt with this chain already */
                         if (entries2->hook_mask & (1<<i))
                                 goto letscontinue;
-                       entries2->hook_mask |= entries->hook_mask;
+                       entries2->hook_mask |= entries->hook_mask & ~(1 << NF_BR_NUMHOOKS);
                         /* Jump to the chain, make sure we know how to get back */
                         stack[sp].chain_nr = chain_nr;
                         stack[sp].n = j;

