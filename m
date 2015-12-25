From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_mark: Fix inversion code
Date: Fri, 25 Dec 2015 13:06:47 +0100
Message-ID: <20151225120647.GC4308@salvia>
References: <20151223141318.GA15560@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLYMGz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:06:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A547C7B550
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:06:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 94698DA7E0
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:06:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BE357DA7FF
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:06:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223141318.GA15560@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 07:43:19PM +0530, Shivani Bhardwaj wrote:
> Fix the code associated with invert flag.
> 
> Examples:
> 
> $ sudo iptables-translate -I INPUT -p tcp -m mark ! --mark 0xa/0xa
> nft insert rule ip filter INPUT ip protocol tcp mark and 0xa != 0xa counter
> 
> $ sudo iptables-translate -I INPUT -p tcp -m mark ! --mark 0x1
> nft insert rule ip filter INPUT ip protocol tcp mark != 0x1 counter

Applied, thanks.
