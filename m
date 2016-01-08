From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libip6t_REJECT: Add translation to nft
Date: Fri, 8 Jan 2016 19:11:41 +0100
Message-ID: <20160108181141.GA2756@salvia>
References: <20160105144826.GA2793@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbcAHSLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 13:11:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3D5567B553
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 19:11:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F601DA804
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 19:11:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 584EEDA803
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 19:11:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160105144826.GA2793@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 05, 2016 at 08:18:26PM +0530, Shivani Bhardwaj wrote:
> Add translation for target REJECT to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp6-reject-route
> nft add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type reject-route
> 
> $ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
> nft add rule ip6 filter FORWARD tcp dport 22 counter reject with tcp reset

Applied, thanks.
