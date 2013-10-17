From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables-nftables] nft: fix interface wildcard matching
Date: Thu, 17 Oct 2013 15:27:49 +0200
Message-ID: <20131017132749.GA12189@localhost>
References: <1381932432-16754-1-git-send-email-pablo@netfilter.org>
 <CAEyr1FQtVEGHM0KD1qxDi6gLkVgrYhc0C46A2bPXE4nfewU-sQ@mail.gmail.com>
 <20131017084350.GA8423@localhost>
 <CAEyr1FShn1LJX27pePQfTP_gjcRZ=cQvfiqd-5O021rn1M+-Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37997 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab3JQN1y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:27:54 -0400
Content-Disposition: inline
In-Reply-To: <CAEyr1FShn1LJX27pePQfTP_gjcRZ=cQvfiqd-5O021rn1M+-Nw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 17, 2013 at 06:17:25PM +0530, Anand Raj Manickam wrote:
> On Thu, Oct 17, 2013 at 2:13 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Oct 17, 2013 at 02:09:05PM +0530, Anand Raj Manickam wrote:
> >> On Wed, Oct 16, 2013 at 7:37 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> >> This again breaks the delete functionality .
> >
> > This is working here with a fresh compilation:
> >
> > # xtables -I INPUT -i eth+
> > # xtables -D INPUT -i eth+
> > # xtables -I INPUT -i eth0
> > # xtables -D INPUT -i eth0
> >
> > # which xtables
> > /usr/sbin/xtables
> > # ls -la /usr/sbin/xtables
> > lrwxrwxrwx 1 root root 13 oct 17 10:42 /usr/sbin/xtables -> xtables-multi
> >
> > What problem are you noticing?
>
> Sorry about it , i guess i had  the wrong build .. works great ..

No problem.

> Do you still want to maintain the refrence for  NFT_META_IIF / NFT_META_OIF ?

Yes, currently you cannot use nftables and xtables at the same time,
but some degree of interaction is desired. This should allow xtables
to interpret add rule added using ifindex from nft.
