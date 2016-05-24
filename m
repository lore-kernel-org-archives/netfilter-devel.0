From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: helper: Fix helper unregister count.
Date: Tue, 24 May 2016 11:26:08 +0200
Message-ID: <20160524092608.GA2132@salvia>
References: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
 <CA+6hz4pj-wp5Vye6GSxiZM1-Bfq=qcJCUJD0hjEbmmtRsTfhow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taehee Yoo <ap420073@gmail.com>, Patrick McHardy <kaber@trash.net>,
	kadlec@blackhole.kfki.hu,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcEXJ0O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 05:26:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2C0D41EFDA1
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:26:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 18B6515D623
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:26:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A346C15D633
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:26:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4pj-wp5Vye6GSxiZM1-Bfq=qcJCUJD0hjEbmmtRsTfhow@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 24, 2016 at 12:18:58PM +0800, Feng Gao wrote:
> Hi,
> 
> I have committed the patches. see the following links
> http://patchwork.ozlabs.org/patch/565169/
> http://patchwork.ozlabs.org/patch/565170/
> http://patchwork.ozlabs.org/patch/565171/
> 
> But i don't know why they are not accepted yet.
> I have did all advises of Pablo.

I prefer to take these small patch fixes from Taehee Yoo, so I can
pass back this to -stable. Once they are applied, I'd suggest you
rebase your large rework to introduce these new helper functions to
register conntrack helpers.

Thanks.
