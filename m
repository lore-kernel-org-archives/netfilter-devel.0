From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: fix error checks in tc handle parser
Date: Tue, 16 Feb 2016 19:25:53 +0100
Message-ID: <20160216182553.GA20686@salvia>
References: <1454324556-29019-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39268 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbcBPSZ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:25:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C921ADA882
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:25:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B9FB4ADCC
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:25:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E87F922016
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:25:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454324556-29019-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 12:02:36PM +0100, Florian Westphal wrote:
> 'meta priority foobar' did not return an error -- instead
> we used min/max values with undefined content.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

I know this is still not the full fix for this, but I would like to
make sure this doesn't get lost, so go push it. Thanks.

