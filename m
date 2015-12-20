From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Support of different targets in nftables
Date: Sun, 20 Dec 2015 11:34:16 +0100
Message-ID: <20151220103416.GA1024@salvia>
References: <CAKHNQQEvQ9-RTOFjyrvonCZ-miiwucBcw_M+KufJ2yhjrK2a7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40913 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbbLTKeX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Dec 2015 05:34:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AF8BE389442
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 11:34:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9EEE1DA803
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 11:34:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C5658DA801
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 11:34:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQEvQ9-RTOFjyrvonCZ-miiwucBcw_M+KufJ2yhjrK2a7g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 20, 2015 at 02:59:58PM +0530, Shivani Bhardwaj wrote:
> Hi,
> 
> While doing the translations, I see that iptables-translate is able to
> produce output only for the target ACCEPT. For all others, it shows
> 
> nft # <rules>
> 
> Why is it so?

This tool you're working on was a proof-of-concept and it incomplete.

So get ready to find incomplete stuff and bugs in it, please, in case
you find issues, you don't have to ask, you can just send a patch to
fix them.

Thank you.
