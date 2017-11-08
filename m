From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Add sysctl to disable
 per interface
Date: Wed, 08 Nov 2017 13:46:03 -0700
Message-ID: <b0a138969da40368de9a117a1045c5c5@codeaurora.org>
References: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
 <20171107103013.GA5512@breakpoint.cc>
 <8c74f85d5f668516766ed208cb8eb415@codeaurora.org>
 <20171108043451.GC1530@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        steffen.klassert@secunet.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdKHUqE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2017 15:46:04 -0500
In-Reply-To: <20171108043451.GC1530@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> We can probably skip defrag if explicit notrack is requested via rule.

Hi Pablo

Thanks for the suggestion. I tried this and it appears that defrag
occurs before NOTRACK is hit in raw table in PREROUTING. This is because
the defrag priority happens to be higher than that of RAW.

[include/uapi/linux/netfilter_ipv4.h]

enum nf_ip_hook_priorities {
	NF_IP_PRI_FIRST = INT_MIN,
	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
	NF_IP_PRI_RAW = -300,
	NF_IP_PRI_SELINUX_FIRST = -225,
	NF_IP_PRI_CONNTRACK = -200,

By changing the ordering of NF_IP_PRI_CONNTRACK_DEFRAG to -210 (some 
lower value)
instead of -400 (before CONNTRACK), I was able to skip the defrag when 
NOTRACK was
set. Do you think this is a possible solution.

diff --git a/include/uapi/linux/netfilter_ipv4.h 
b/include/uapi/linux/netfilter_ipv4.h
index 91ddd1f..13dc767 100644
--- a/include/uapi/linux/netfilter_ipv4.h
+++ b/include/uapi/linux/netfilter_ipv4.h
@@ -56,9 +56,9 @@

  enum nf_ip_hook_priorities {
         NF_IP_PRI_FIRST = INT_MIN,
-       NF_IP_PRI_CONNTRACK_DEFRAG = -400,
         NF_IP_PRI_RAW = -300,
         NF_IP_PRI_SELINUX_FIRST = -225,
+       NF_IP_PRI_CONNTRACK_DEFRAG = -210,
         NF_IP_PRI_CONNTRACK = -200,
         NF_IP_PRI_MANGLE = -150,
         NF_IP_PRI_NAT_DST = -100,

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
