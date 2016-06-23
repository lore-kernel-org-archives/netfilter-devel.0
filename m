From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 4/4] netfilter: nft_meta: add explicitly
 nf_logger_find_get call
Date: Thu, 23 Jun 2016 19:33:02 +0200
Message-ID: <20160623173302.GA2241@salvia>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
 <1465389800-27842-5-git-send-email-zlpnobody@163.com>
 <20160608125932.GA29699@breakpoint.cc>
 <5734c851.1513c.1554ee8d637.Coremail.zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55467 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbcFWRdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:33:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A70468D051A
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:33:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 96DF29EBB4
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:33:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3C7949EBAF
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:33:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5734c851.1513c.1554ee8d637.Coremail.zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 14, 2016 at 08:35:29PM +0800, Liping Zhang wrote:
> Hi Florian,
> 
> At 2016-06-08 20:59:32, "Florian Westphal" <fw@strlen.de> wrote:
> >
> >With nftables we have a new infrastructure in place that emits trace info via
> >nfnetlink.
> >
> >So loading nf_log_ipX isn't needed anymore in nft.
> 
> Yes, in nftables, user can use "nft monitor" to get the trace info.
> But I think it is a little choas now, sometimes we can see trace info 
> in kmsg(when nf_log_ipX is loaded), sometimes there's nothing in
> kmsg(when nf_log_ipX is not installed).
> 
> This is confusing, especially for newbie.

Now that we got nft monitor, I think we need a way to deprecate the
old mode, I suggest a /proc interface (enabled by default) to disable
the ring buffer log mode. We can document this in the nftables HOWTO
on the wiki site.

I'm going to keep this back by now. We have the Netfilter Workshop
next week en Netherlands, I will be talking on the existing logging
infrastructure and this.

Will get back to you with feedback.
