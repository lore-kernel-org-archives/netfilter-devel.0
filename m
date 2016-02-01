From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: fix error checks in tc handle parser
Date: Mon, 1 Feb 2016 18:53:30 +0100
Message-ID: <20160201175330.GA2355@salvia>
References: <1454324556-29019-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47670 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbcBARxf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 12:53:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B7E066C2C
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:53:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A51F4DA7FF
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:53:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0C60DA860
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:53:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454324556-29019-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 12:02:36PM +0100, Florian Westphal wrote:
> 'meta priority foobar' did not return an error -- instead
> we used min/max values with undefined content.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Fine with me. IIRC, the scanner is still broken though.
