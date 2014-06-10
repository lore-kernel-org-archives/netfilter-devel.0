From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] fix nft -i command crashes when try to input
 multi line command
Date: Tue, 10 Jun 2014 13:22:12 +0200
Message-ID: <20140610112212.GA10526@localhost>
References: <CAHSpA5_tm8PJKSCYwo4RObrzm25tGNX+j_7=K8ySB5+NdK0N9g@mail.gmail.com>
 <20140610105552.GA9228@localhost>
 <CAHSpA59UwPmKGqOV_qGAGnzX7D84akiNMc4XLYpioxCAp7XrEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37603 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaFJLWS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:22:18 -0400
Content-Disposition: inline
In-Reply-To: <CAHSpA59UwPmKGqOV_qGAGnzX7D84akiNMc4XLYpioxCAp7XrEA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 10, 2014 at 04:35:09PM +0530, Guruswamy Basavaiah wrote:
> Hello,
>  Steps to reproduce.
>  [root@localhost ~]# nft -i
> nft> add table filter
> nft> list table \
> 
> readline: readline_callback_read_char() called with no handler!
> Aborted (core dumped)
> [root@localhost ~]#

I see, thanks.

Perhaps we can do something similar to python, I'd suggest:

nft> list table \
.... filter
table ip filter {
        chain INPUT {
                type filter hook input priority 0;
        }
}

I mean use "...." if we are in the context of a multiline.
