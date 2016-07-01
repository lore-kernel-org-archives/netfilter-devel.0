From: subashab@codeaurora.org
Subject: Re: [PATCH v5] xtables: Add an interval option for xtables lock wait
Date: Fri, 01 Jul 2016 11:14:58 -0600
Message-ID: <384253a17bf0b4e253fc47a93588c51c@codeaurora.org>
References: <1466729046-3070-1-git-send-email-subashab@codeaurora.org>
 <20160701132216.GA3252@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33471 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbcGARPR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 13:15:17 -0400
In-Reply-To: <20160701132216.GA3252@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I'm attaching a patch that applies on top of this.
> 
> That I can remember, you only needed to reduce the wait interval, not
> to make it ever larger, so I'm simplifying this so -W only takes
> microseconds.
> 
> I have only included some missing error check in case -W is specified
> but -w is not.
> 
> I can collapse this patch to yours, unless you have any concern.

Thanks Pablo. Sure, that is fine.

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project.
