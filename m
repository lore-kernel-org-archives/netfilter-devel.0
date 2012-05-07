From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] [PATCH 0/4] netfilter: "fail-open" feature support for
 NFQUEUE
Date: Mon, 7 May 2012 10:10:29 +0200
Message-ID: <20120507081029.GB5015@breakpoint.cc>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, svajipay@in.ibm.com,
	vivk@us.ibm.com, sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48778 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab2EGIKa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 04:10:30 -0400
Content-Disposition: inline
In-Reply-To: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar <krkumar2@in.ibm.com> wrote:
> Many users of an IBM security product, which uses netfilter's NFQUEUE
> target to process packets in userspace, face a problem of dropped
> connections during heavy load. Incoming packets are queued and
> processed by the security module, which does deep packet analysis to
> decide whether to accept or reject them. However during heavy load,
> NFQUEUE queue (default 1024 entries) fills up and connections fail
> after large number of packets drop during enqueue. Increasing the
> queue size delays the problem and also worsens latency.
> 
> This patch set implements a "failopen" support to help keep connections
> open during such failures. This is achieved by allowing acceptance of
> packets temporarily when the queue is full, which enables existing
> connections to be kept alive. Customers prefer this option as similar
> feature is available on other systems.
> 
> This patch set implements failopen for NFQUEUE (though a similar patch
> for IPQUEUE is also implemented but not submitted at this time). I will
> submit the iptables changes which controls turning failopen mode on/off
> later. The original requirement for sysctl option is not implemented -
> please let me know whether that is acceptable/preferable.

I think that exposing this feature as userspace-changeable via netlink
(eg. by adding "NFQA_CFG_FAILOPEN" attribute) rather than via ruleset
would make most sense, as only the application can know wheter it
can cope with missing packets.
