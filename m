From: BORBELY Zoltan <bozo@andrews.hu>
Subject: Re: Support NAT-ed expect entries from user space
Date: Tue, 17 Jun 2008 00:17:59 +0200
Message-ID: <20080616221759.GM2860@phoenix.home>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org> <4856D28C.3030302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep25-int.chello.at ([62.179.121.45]:23350 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYFPW1Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:27:16 -0400
Received: from edge02.upc.biz ([192.168.13.237]) by viefep25-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080616222712.LRIB8769.viefep25-int.chello.at@edge02.upc.biz>
          for <netfilter-devel@vger.kernel.org>;
          Tue, 17 Jun 2008 00:27:12 +0200
Content-Disposition: inline
In-Reply-To: <4856D28C.3030302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Jun 16, 2008 at 10:52:28PM +0200, Patrick McHardy wrote:
> I'm wondering, how is this expectation creation working at all?
> The NULL expectfn makes me think it will crash as soon as the
> expectation arrives. This *needs* support from the helpers to
> properly set the expectfn.

The nf_nat_follow_master did the trick for me if I set the expectation
entry from user space. With NULL expectfn it didn't work.

> And more specific to this problem: back when Harald was working
> on userspace helpers, the idea was to add a dummy helper specifically
> so we have one to assign to the connection. The helper would (IIRC)
> just queue the expected packets and userspace could take it from
> there. Of course queuing could be made optional and (f.i.) it could
> just use nf_nat_follow_master.

I'd like to create a cross-platform user space ftp proxy, not a nf
conntrack+nat helper module, so my goals are a bit different. The
netfilter code contains everything I need, and the netlink interface
is quite good to instruct the kernel code to do as the proxy wants.

> And related to this patch: the direction needs to be provided
> by userspace to be generically useful. The saved_port (and saved_ip
> possibly) could either be provided by userspace or selected
> based on a couple of flags.

Yes, it's a good idea to send these parameters as attributes to the
expect creation netlink message.

Bye,
Bozo
