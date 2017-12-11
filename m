From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Skip defrag if NOTRACK
 is set
Date: Mon, 11 Dec 2017 00:13:26 -0700
Message-ID: <3abaf0e337d821dfc60297b048c1ecf9@codeaurora.org>
References: <1510623446-9115-1-git-send-email-subashab@codeaurora.org>
 <20171209151018.GA5551@salvia>
 <dd0bf36c855a8e2ea41039f2282fb9ff@codeaurora.org>
 <20171210145355.GA24947@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58330 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKHN1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Dec 2017 02:13:27 -0500
In-Reply-To: <20171210145355.GA24947@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I'm actually refering to module_param(), that is specified at modprobe
> time. Such parameter would set an alternative hook priority for the
> raw table, ie. before the defrag hook. I guess there must be a way to
> store these module parameters in Android, so whenever modprobe is
> invoked, either explicitly or via module autoload, this module
> parameter is passed to the iptable_raw module.

Thanks for the clarification Pablo. I'll try this and send a new patch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
