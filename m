From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: udp: add translation to nft
Date: Wed, 23 Apr 2014 14:29:07 +0200
Message-ID: <20140423122907.GA18536@localhost>
References: <a23cb222241de735c0f1bd19492ed7ea752b65f8.1397632430.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57764 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbaDWM3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:29:32 -0400
Content-Disposition: inline
In-Reply-To: <a23cb222241de735c0f1bd19492ed7ea752b65f8.1397632430.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 16, 2014 at 09:19:40AM +0200, Ana Rey wrote:
> Some examples:
> 
>  $ sudo iptables-translate -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
> add rule ip filter INPUT iifname eth0 udp sport 53 counter accept
> 
>  $ sudo ./iptables-translate -A OUTPUT -p udp -o eth0 --dport 53:66 -j DROP
> add rule ip filter OUTPUT oifname eth0 udp dport 53-66 counter drop
> 
>  $ sudo ./iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
> nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept

Applied to the xlate branch of iptables, will merge that branch into
master once we get a significant amount of iptables to nft translations.

Thanks Ana.
