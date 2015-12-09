From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 libnftnl 1/3] src: add trace infrastructure support
Date: Wed, 9 Dec 2015 14:55:57 +0100
Message-ID: <20151209135557.GA1516@salvia>
References: <1448649800-26153-1-git-send-email-fw@strlen.de>
 <1448649800-26153-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41013 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbbLIN4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 08:56:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 575091324CE
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:56:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 45EB9DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:56:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EBCD0DA80B
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:55:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448649800-26153-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 27, 2015 at 07:43:18PM +0100, Florian Westphal wrote:
> parses trace monitor netlink messages from the kernel and builds
> nftnl_trace struct that contains the dissected information.
> 
> Provides getters to access these attributes.

I leave it to you to push trace code to libnftnl. Thanks.
