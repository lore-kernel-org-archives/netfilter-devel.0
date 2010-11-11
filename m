From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] netfilter: NF_HOOK_COND has wrong conditional
Date: Thu, 11 Nov 2010 14:09:54 -0500
Message-ID: <20101111190954.29005.61686.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, linux-kernel@vger.kernel.org
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0KKTKQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:10:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The NF_HOOK_COND returns 0 when it shouldn't due to what I believe to be an
error in the code as the order of operations is not what was intended.  C will
evalutate == before =.  Which means ret is getting set to the bool result,
rather than the return value of the function call.  The code says

if (ret = function() == 1)
when it meant to say:
if ((ret = function()) == 1)

Normally the compiler would warn, but it doesn't notice it because its
a actually complex conditional and so the wrong code is wrapped in an explict
set of () [exactly what the compiler wants you to do if this was intentional].
Fixing this means that errors when netfilter denies a packet get propagated
back up the stack rather than lost.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/netfilter.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 89341c3..03317c8 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -215,7 +215,7 @@ NF_HOOK_COND(uint8_t pf, unsigned int hook, struct sk_buff *skb,
 	int ret;
 
 	if (!cond ||
-	    (ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN) == 1))
+	    ((ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN)) == 1))
 		ret = okfn(skb);
 	return ret;
 }

