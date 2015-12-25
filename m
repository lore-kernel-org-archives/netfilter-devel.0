From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_realm: Add translation to nft
Date: Fri, 25 Dec 2015 13:15:54 +0100
Message-ID: <20151225121554.GD4822@salvia>
References: <20151225062844.GA9545@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46904 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbbLYMP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:15:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 18AF07B544
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:15:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0A2B2DA809
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:15:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3508DDA809
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:15:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151225062844.GA9545@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 11:58:44AM +0530, Shivani Bhardwaj wrote:
> Add translation for routing realm to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A PREROUTING -m realm --realm 4
> nft add rule ip filter PREROUTING rtclassid 0x4 counter
> 
> $ sudo iptables-translate -A PREROUTING -m realm --realm 5/5
> nft add rule ip filter PREROUTING rtclassid and 0x5 == 0x5 counter
> 
> $ sudo iptables-translate -A PREROUTING -m realm ! --realm 50
> nft add rule ip filter PREROUTING rtclassid != 0x32 counter

Did you test this case?

sudo iptables-translate -A PREROUTING -m realm ! --realm 5/5
