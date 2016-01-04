From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] Add support for ttl translation
Date: Mon, 4 Jan 2016 18:40:24 +0100
Message-ID: <20160104174024.GA3706@salvia>
References: <cover.1451927507.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55195 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbcADRk3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 12:40:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3F7DD1324CA
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 18:40:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 26CC1DA803
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 18:40:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C376DDA7E0
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 18:40:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <cover.1451927507.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 10:49:10PM +0530, Shivani Bhardwaj wrote:
> This patchset adds ttl translation to nftables by adding ip ttl to
> the buffer everytime a ttl match is hit as it is necessary to mention
> the protocol version with ttl, that is, 
> $ sudo nft .. ttl 3 ..             won't work but
> $ sudo nft .. ip ttl 3 ..          would work.

This above is the right syntax.

> Also, since adding ip to the buffer in the code for ttl won't look
> suitable, some amendments have been done in the nft-ipv4 code.
>
> Shivani Bhardwaj (2):
>   iptables: nft-ipv4: Add ip ttl to the buffer

I don't think you need this change for nft-ipv4.
