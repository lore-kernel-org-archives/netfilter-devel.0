From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Skip defrag if NOTRACK
 is set
Date: Sat, 09 Dec 2017 19:06:14 -0700
Message-ID: <dd0bf36c855a8e2ea41039f2282fb9ff@codeaurora.org>
References: <1510623446-9115-1-git-send-email-subashab@codeaurora.org>
 <20171209151018.GA5551@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdLJCGP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Dec 2017 21:06:15 -0500
In-Reply-To: <20171209151018.GA5551@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Would it work for you if this is specific via global modparam? I'm
> telling this because:
> 
> 1) This is changing the default behaviour, which is always tricky.
> 2) This is already solved in nftables, so whatever solution that we
>    apply, it should be iptables specific.
> 
> If modparam is fine, just placing a line into
> /etc/modprobe.d/options.conf (or similar) should be good enough to
> store that you're requesting raw hook registration before defrag.
> 
> Let me know,
> Thanks!

Hi Pablo

Can you explain a bit more about the /etc/modprobe.d/ option and how
it would be configured for this? /etc/modprobe.d/ doesnt exist on
Android based Linux systems so it might be a problem for me.

Would it be an acceptable solution to create a kernel config for this
particular feature instead?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
