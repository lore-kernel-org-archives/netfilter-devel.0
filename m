From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH] extensions: libxt_conntrack: Add translation to nft
Date: Wed, 15 Jun 2016 16:17:42 +0200
Message-ID: <20160615141741.GB15155@sonyv>
References: <20160614180242.GA26384@sonyv>
 <20160615122127.GA3188@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:33951 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001AbcFOORr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 10:17:47 -0400
Received: by mail-lb0-f194.google.com with SMTP id t6so293842lbv.1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 07:17:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160615122127.GA3188@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 15, 2016 at 02:21:27PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 14, 2016 at 08:02:45PM +0200, Laura Garcia Liebana wrote:
> > Add translation of conntrack to nftables.
> > 
> > Examples:
> > 
> > $ sudo iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCEPT
> > nft add rule ip filter INPUT ct state { new,related } counter accept
> 
> No need to use a set here, instead:
> 
> nft add rule ip filter INPUT ct state new,related counter accept
> 
> > $ sudo ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
> > nft add rule ip6 filter INPUT ct state != { new,related } counter accept
> 
> Same thing here.
> 
> Thanks.

Ok, this will simplify the code.
