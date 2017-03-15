From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH iptables 1/2] iptables: remove duplicated argument parsing
 code
Date: Wed, 15 Mar 2017 17:49:15 -0600
Message-ID: <30ea803326b87cfdc78ebe8d3b373a04@codeaurora.org>
References: <20170315134553.35772-1-lorenzo@google.com>
 <20170315134553.35772-2-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        jscherpelz@google.com, zlpnobody@gmail.com
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdCOXtQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 19:49:16 -0400
In-Reply-To: <20170315134553.35772-2-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-03-15 07:45, Lorenzo Colitti wrote:
> 1. Factor out repeated code to a new xs_has_arg function.
> 2. Add a new parse_wait_time option to parse the value of -w.
> 3. Make parse_wait_interval take argc and argv so its callers
>    can be simpler.
> 
> Signed-off-by: Lorenzo Colitti <lorenzo@google.com>

Hi Lorenzo

I am seeing a compilation failure with this patch.
It might require a fix like below.

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 45a7644..bde8ba6 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1012,9 +1012,10 @@ void do_parse(struct nft_handle *h, int argc, 
char *argv[],
                                               "iptables-restore");
                         }
                         if (optarg)
-                               parse_wait_interval(optarg, 
&wait_interval);
+                               parse_wait_interval(argc, argv,
+                                                   &wait_interval);
                         else if (xs_has_arg(argc, argv))
-                               parse_wait_interval(argv[optind++],
+                               parse_wait_interval(argc, argv,
                                                     &wait_interval);

                         wait_interval_set = true;

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
