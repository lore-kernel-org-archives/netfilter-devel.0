From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: x_tables: deal with bogus nextoffset values
Date: Fri, 18 Mar 2016 23:02:00 +0100
Message-ID: <20160318220200.GA1574@salvia>
References: <1457571362-25441-1-git-send-email-fw@strlen.de>
 <20160310141231.GA13006@salvia>
 <20160318130340.GA9843@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	hawkes@google.com
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbcCRWCJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 18:02:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 347FF4B0F5
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 23:02:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 25AEFDA8F7
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 23:02:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE2F3DA8FA
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 23:02:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160318130340.GA9843@unicorn.suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Michal,

On Fri, Mar 18, 2016 at 02:03:40PM +0100, Michal Kubecek wrote:
> I can't see this patch neither in nf nor in nf-next even if the other
> one (netfilter: x_tables: check for size overflow) is in nf-next. Was it
> omitted on purpose or is it a mistake?

We've been considering different solutions for this, so this is still
under debate, just proposed a new one here:

http://patchwork.ozlabs.org/patch/599721/

Thanks.
