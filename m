From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_connmark: Add translation to nft
Date: Tue, 22 Dec 2015 17:47:39 +0100
Message-ID: <20151222164739.GD18134@salvia>
References: <20151222105547.GA5130@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33412 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbbLVQrn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:47:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CB3F423CF60
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:47:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BE2C0DA85F
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:47:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F05A6DA862
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:47:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222105547.GA5130@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 04:25:47PM +0530, Shivani Bhardwaj wrote:
> Add translation for connmark to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m connmark --mark 1
> nft add rule ip filter INPUT ct mark 0x1 counter
> 
> $ sudo iptables-translate -A INPUT -m connmark --mark 10/10 -j ACCEPT
> nft add rule ip filter INPUT ct mark and 0xa == 0xa counter accept
> 
> $ sudo  sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 40 -m connmark --mark 0x40
> nft add rule ip mangle PREROUTING tcp dport 40 ct mark 0x40 counter

Please, fix the -m connmark ! --mark 10/10 case.
