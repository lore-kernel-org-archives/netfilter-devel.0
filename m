From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [OOPS,TPROXY,xt_owner]: Oops accessing socket in owner_mt()
Date: Mon, 28 Apr 2014 09:20:46 -0700
Message-ID: <1398702046.29914.122.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140415133220.GG6576@imap.eitzenberger.org>
	 <20140428155731.GA29816@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Holger Eitzenberger <holger@eitzenberger.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38274 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbaD1QUt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:20:49 -0400
Received: by mail-pa0-f45.google.com with SMTP id kq14so5354414pab.32
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 09:20:49 -0700 (PDT)
In-Reply-To: <20140428155731.GA29816@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2014-04-28 at 17:57 +0200, Pablo Neira Ayuso wrote:
> Hi Holger,

> Not your fault, but I think we should also check for ...
> 
>         ... || skb->sk->sk_state == TCP_TIME_WAIT)
> 
> since early demux was introduced, we may have skb->sk pointing to a
> timewait socket.

Hmm... strange... I thought I already checked this code was fine.

And it should be because :

static struct xt_match owner_mt_reg __read_mostly = {
        .name       = "owner",
        .revision   = 1,
        .family     = NFPROTO_UNSPEC,
        .checkentry = owner_check,
        .match      = owner_mt,
        .matchsize  = sizeof(struct xt_owner_match_info),
        .hooks      = (1 << NF_INET_LOCAL_OUT) |
                      (1 << NF_INET_POST_ROUTING),
        .me         = THIS_MODULE,
};



