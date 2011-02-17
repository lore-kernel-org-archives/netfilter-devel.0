From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFH] bridge: add new target NFQUEUE for ebtables
Date: Thu, 17 Feb 2011 11:47:57 +0100
Message-ID: <4D5CFCDD.10007@trash.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-4-git-send-email-chifflier@edenwall.com> <4D4BFE3C.3060407@trash.net> <4D4C01B2.2030605@edenwall.com> <4D4C020A.9000909@trash.net> <4D5104C4.3010105@edenwall.com> <4D59C047.5050404@trash.net> <4D5C01E5.8000302@wzdftpd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@wzdftpd.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53199 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1BQKr7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:47:59 -0500
In-Reply-To: <4D5C01E5.8000302@wzdftpd.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 16.02.2011 17:57, schrieb Pierre Chifflier:
> Hi,
> 
> Thanks for your reply Patrick.
> So I did the following:
> - rebased on today's nf-next-2.6
> - apply only the first patch (which makes afinfo optional)
> - revert all other patches
> - apply the recent fix on nf_iterate since it was the cause of my oops
> 
> I patched ebtables to use xt_NFQUEUE (using a struct xt_NFQ_info_v1 with
> arguments queuenum 1 and queues_total 1), and removed any other change.
> 
> When I add a rule with the NFQUEUE target with ebtables, I almost
> immediately get a panic (full backtrace later in this mail).
> 
> What is weird is that I got a NULL skb  in ebt_in_hook (frame 2) while
> the skb was not NULL earlier - like if it was stolen by some hook. Any
> idea on what could cause that ?

The backtrace doesn't seem to be fully accurate. Please also post
the full oops output corresponding to the backtrace.

Two more questions:

- is the bridge device in promiscous mode?
- do you have IGMP snooping enabled?
