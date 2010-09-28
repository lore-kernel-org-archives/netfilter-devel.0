From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: ctnetlink: add support for user-space
 expectation helpers
Date: Tue, 28 Sep 2010 21:08:50 +0200
Message-ID: <4CA23D42.1030202@trash.net>
References: <20100921092843.3279.6914.stgit@decadence> <20100921093529.3279.30748.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40157 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0I1TI4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:08:56 -0400
In-Reply-To: <20100921093529.3279.30748.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.09.2010 11:35, schrieb Pablo Neira Ayuso:
> This patch adds the basic infrastructure to support user-space
> expectation helpers via ctnetlink and the netfilter queuing
> infrastructure NFQUEUE. Basically, this patch:
> 
> * adds NF_CT_EXPECT_USERSPACE flag to identify user-space
> created expectations. I have also added a sanity check in
> __nf_ct_expect_check() to avoid that kernel-space helpers
> may create an expectation if the master conntrack has no
> helper assigned.
> * adds some branches to check if the master conntrack helper
> exists, otherwise we skip the code that refers to kernel-space
> helper such as the local expectation list and the expectation
> policy.
> * allows to set the timeout for user-space expectations with
> no helper assigned.
> 
> This patch also modifies ctnetlink to skip including the helper
> name in the Netlink messages if no kernel-space helper is set
> (since no user-space expectation has not kernel-space kernel
> assigned).
> 
> You can access an example user-space FTP conntrack helper at:
> http://people.netfilter.org/pablo/nf-ftp-helper-userspace-POC.tar.bz

Applied, thanks Pablo. I've also fixed up the URL to include
userspace-conntrack-helpers/ in the path :)
