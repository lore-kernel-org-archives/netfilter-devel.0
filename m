From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] examples: selective rule dumping
Date: Thu, 21 Jul 2016 15:36:30 +0200
Message-ID: <20160721133630.GA2050@salvia>
References: <578F7E7A.5080901@toulouse.viveris.com>
 <20160720180523.GA30217@salvia>
 <579081B5.1000100@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: jalvarez <jalvarez@toulouse.viveris.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58080 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbcGUNgk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 09:36:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 44A23210569
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 15:36:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34948100A53
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 15:36:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1D128100A45
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 15:36:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <579081B5.1000100@toulouse.viveris.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 21, 2016 at 10:03:01AM +0200, jalvarez wrote:
> Here are the changes then.
> I didn't put it in nft-rule-get.c at first to avoid breaking the expected
> behavior of the example.

Thanks.

Problem with this patch: You MUA seems to mangle it, so both patch -p1
< patch and git am tell me that your patch is corrupted. I can also
see indents are converted to spaces instead of tabs.

I suggest you use git-send-email to deliver patches to the mailing
list to resolve this.
