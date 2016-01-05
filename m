From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH nf-next 1/3] netfilter: nfnetlink_queue: remove
 duplicated obsolete commands handling
Date: Tue, 5 Jan 2016 09:24:57 +0900
Message-ID: <20160105002456.GA27154@gmail.com>
References: <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
 <20151106004947.GB11266@gmail.com>
 <20151108221454.GA21221@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36558 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbcAEAZC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 19:25:02 -0500
Received: by mail-pf0-f171.google.com with SMTP id 65so165070310pff.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 16:25:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151108221454.GA21221@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for being late often.

On Sun, Nov 08, 2015 at 11:14:54PM +0100, Pablo Neira Ayuso wrote:
> commit 0360ae412d09bc6f4864c801effcb20bfd84520e
> Author: Florian Westphal <fw@strlen.de>
> Date:   Fri Nov 23 06:22:21 2012 +0000
> 
>     netfilter: kill support for per-af queue backends
> 
> The former behaviour before Florian's patch is that
> NFQNL_CFG_CMD_PF_BIND and NFQNL_CFG_CMD_PF_UNBIND are terminal.
> 
> This code is there not to break backward compatibility, ie. old
> userspace that rely on these commands.
> 
> After this patch, we inspect if there is an existing queue for this,
> which was not happening before.

I tried to follow your advice, would you see again?

> As I said, my concerns go in the direction of possible breakage of old
> code, we shouldn't break backward.

I'm worry about appended patches 3/5 and 5/5 may not follow it.
After these patches applied, userspace can not update instance's
options with invalid command. is it acceptable?

Thanks,

