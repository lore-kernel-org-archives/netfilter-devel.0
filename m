From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to register conntrack notifier
Date: Fri, 13 Nov 2009 11:50:54 +0100
Message-ID: <4AFD3A0E.7090602@netfilter.org>
References: <894367326@web.de> <4AE835A7.7040400@netfilter.org>	 <873dce860911120252x6b00c4c6n564e09a88c341c19@mail.gmail.com>	 <4AFBFC05.2000802@netfilter.org> <873dce860911130039q2e0ecf38nfeaeaa8cd030cadc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nils Rennebarth <Nils.Rennebarth@web.de>,
	netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbZKMKcQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:32:16 -0500
In-Reply-To: <873dce860911130039q2e0ecf38nfeaeaa8cd030cadc@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Pesce wrote:
> Ok, so newer kernels opted for performance, giving that on 99% of the
> time only nf_conntrack_netlink uses event notifier callbacks, which is
> usually the case...

Looking at the kernel code, there's no other client of that notifier 
chain that ctnetlink.

> But I am curious...what if another kernel module needs to receive
> conntrack events? Are there any way to keep track of events in kernel
> space while nf_conntrack_netlink is holding the one and only callback
> hook?

Then, that new module would need to be submitted to mainline. Of course 
it should be something that proves to be useful for the general public. 
Sorry, we won't introduce the notifier chain again for an out-of-tree 
module.
