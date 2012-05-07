From: Krishna Kumar2 <krkumar2@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/4] netfilter: "fail-open" feature support for NFQUEUE
Date: Mon, 7 May 2012 19:21:18 +0530
Message-ID: <OF72EDDD93.E0BF0FC1-ON652579F7.002FC182-652579F7.004C26E2@in.ibm.com>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain> <20120507081029.GB5015@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, sri@us.ibm.com,
	Sulakshan Vajipayajula <svajipay@in.ibm.com>, vivk@us.ibm.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51883 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2EGNvy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 09:51:54 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Mon, 7 May 2012 19:21:51 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q47Dpm7f4391312
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 19:21:48 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47JLa3e022036
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 05:21:36 +1000
In-Reply-To: <20120507081029.GB5015@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote on 05/07/2012 01:40:29 PM:

> Re: [RFC] [PATCH 0/4] netfilter: "fail-open" feature support for NFQUEUE
>
> Krishna Kumar <krkumar2@in.ibm.com> wrote:
> > Many users of an IBM security product, which uses netfilter's NFQUEUE
> > target to process packets in userspace, face a problem of dropped
> > connections during heavy load. Incoming packets are queued and
> > processed by the security module, which does deep packet analysis to
> > decide whether to accept or reject them. However during heavy load,
> > NFQUEUE queue (default 1024 entries) fills up and connections fail
> > after large number of packets drop during enqueue. Increasing the
> > queue size delays the problem and also worsens latency.
> >
> > This patch set implements a "failopen" support to help keep connections
> > open during such failures. This is achieved by allowing acceptance of
> > packets temporarily when the queue is full, which enables existing
> > connections to be kept alive. Customers prefer this option as similar
> > feature is available on other systems.
> >
> > This patch set implements failopen for NFQUEUE (though a similar patch
> > for IPQUEUE is also implemented but not submitted at this time). I will
> > submit the iptables changes which controls turning failopen mode on/off
> > later. The original requirement for sysctl option is not implemented -
> > please let me know whether that is acceptable/preferable.
>
> I think that exposing this feature as userspace-changeable via netlink
> (eg. by adding "NFQA_CFG_FAILOPEN" attribute) rather than via ruleset
> would make most sense, as only the application can know wheter it
> can cope with missing packets.

Thanks for your review. With this change, is there any reason to
modify xt_NFQ_info_v2's bypass field, since app can specify this
option directly? I tested without this for now and it works.

Thanks,
- KK

