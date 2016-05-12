From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: fix timestamp attribute
Date: Thu, 12 May 2016 17:23:40 +0200
Message-ID: <20160512152340.GA23624@salvia>
References: <1463057034-27694-1-git-send-email-fw@strlen.de>
 <20160512150732.GA16949@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44305 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbcELPXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2016 11:23:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7652113C0DB
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 17:23:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 64D5A2687D2
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 17:23:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D3082687C3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 17:23:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160512150732.GA16949@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 12, 2016 at 05:07:32PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 12, 2016 at 02:43:54PM +0200, Florian Westphal wrote:
> > Since 4.4 we erronously use timestamp of the netlink skb (which is zero).
> > 
> > Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1066
> > Fixes: b28b1e826f818c30ea7 ("netfilter: nfnetlink_queue: use y2038 safe timestamp")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Argh, my fault. Thanks for fixing up this, applied.

And enqueued for stable 4.4, btw.
