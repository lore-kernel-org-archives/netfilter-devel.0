From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 4/6] src: rename EXPORT_SYMBOL to
 EXPORT_SYMBOL_ALIAS
Date: Tue, 24 Nov 2015 11:11:56 +0100
Message-ID: <20151124101156.GA2683@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59996 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbbKXKML (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:12:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B40F2613A3
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:12:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A3B5EDA86E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:12:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C3BADA876
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:12:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448359331-12692-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:02:09AM +0100, Florian Westphal wrote:
> Future symbols don't need backwards-compat aliases.

Florian, good point.

I have just pushed out this to make sure ongoing work uses the right
macro and avoid rebases.

Thanks.
