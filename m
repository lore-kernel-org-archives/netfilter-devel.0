From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_log: autoload
 nf_conntrack_netlink module NFQA_CFG_F_CONNTRACK config flag
Date: Fri, 6 Nov 2015 09:46:41 +0900
Message-ID: <20151106004640.GA11266@gmail.com>
References: <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34537 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031055AbbKFAqr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 19:46:47 -0500
Received: by padhx2 with SMTP id hx2so95179077pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2015 16:46:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151016170532.GA18148@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Sorry for being late.
 
On Fri, Oct 16, 2015 at 07:05:32PM +0200, Pablo Neira Ayuso wrote:
> can get resolved the broken atomicity problems in first place when
> applying configuration updates to nfnetlink_queue in a similar way to
> what I did for nfnetlink_log?

I tried it, would you review the following patches?

> can destroy a queue in NFQNL_CFG_CMD_UNBIND, then we can keep going on
> configuring it when it is actually destroyed. This is working only by

I'm wondering how we handle obsolete commands
NFQNL_CFG_CMD_PF_BIND / UNBIND, especially with a valid queue_num
and configurations. These patches follows current behavior, do
nothing, ignores another nlas and just returns success. Should I
update patches to handle configuraion nlas with obsolute commands?

Thanks,
