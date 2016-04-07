From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: arp_tables: register table in initns
Date: Thu, 7 Apr 2016 12:01:11 +0200
Message-ID: <20160407100111.GA6178@salvia>
References: <1459242316-8100-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55221 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbcDGKBa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 06:01:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E8D4610078E
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 12:01:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D36C8DA388
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 12:01:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6B14FAD81
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 12:01:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459242316-8100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 29, 2016 at 11:05:16AM +0200, Florian Westphal wrote:
> arptables is broken since we didn't register the table anymore --
> even 'arptables -L' fails.

Applied, thanks Florian.
