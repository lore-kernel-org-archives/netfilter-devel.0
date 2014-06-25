From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] Correct initial value of bytes counter in
 nftables rule
Date: Wed, 25 Jun 2014 14:15:42 +0200
Message-ID: <20140625121542.GA21463@localhost>
References: <1403180627-5631-1-git-send-email-ycnian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Yanchuan Nian <ycnian@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42465 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaFYMPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:15:50 -0400
Content-Disposition: inline
In-Reply-To: <1403180627-5631-1-git-send-email-ycnian@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 19, 2014 at 08:23:47PM +0800, Yanchuan Nian wrote:
> Packages can be accounted by nftables through such command.
> % nft add rule filter output ip daddr 8.8.8.8 counter
> 
> You can also give the initial values of packets and bytes.
> % nft add rule filter output ip daddr 8.8.8.8 counter  packets 10 bytes 20
> 
> But packets and bytes are both initialized to 10 in above command for there is
> a mistake in the program.

Applied, thanks.
