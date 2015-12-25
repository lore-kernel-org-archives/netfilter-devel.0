From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_cpu: Add translation to nft
Date: Fri, 25 Dec 2015 13:07:27 +0100
Message-ID: <20151225120727.GE4308@salvia>
References: <20151223164158.GA19616@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLYMHf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:07:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 31E477B544
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 215E8DA801
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4DEF8DA807
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223164158.GA19616@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 10:11:58PM +0530, Shivani Bhardwaj wrote:
> Add translation for module cpu to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
> nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept
> 
> $ sudo iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
> nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept

Also applied, thanks Shivani.
