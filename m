Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391D4186E26;
	Mon, 19 Aug 2024 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724093240; cv=none; b=cncJV1cJoqlm0X+WDcOS7gl2lGC8FeAn0tkduCJ7c9nV0ctCgOdZEM3FmO6AWYJKgUV+DY2dkPaLsJP6iqnciz9nhamkQ3zU5o0vsHgXNgWbLqTObSP8mSJPQJpPvyCpVJOd5Zirv7osYSXEpmwP/j/iLPsb6genpSwXKxv+XtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724093240; c=relaxed/simple;
	bh=aB5PvFFQWqx4/EzkPINh2ocr4ZWwpS+qUOGIeJPrth4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tA4QtMj6nip3uFVbmFSMt2J28UO1mvT0t8hH38tz7eyPVOkdOIZb2hyWf5E10sTaAavaP0V/ttVxEDx71pXq2jtYs2oJI5FiKpsGfYlU8Y8E6aHkVSX80iySsAnyomOM6EbWTbpJn26a5L4tSp1DzffrYxfeOm/2YoCSbj++iFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50536 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg7PN-005isC-9Y; Mon, 19 Aug 2024 20:47:15 +0200
Date: Mon, 19 Aug 2024 20:47:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Changliang Wu <changliang.wu@smartx.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: support CTA_FILTER for flush
Message-ID: <ZsOTMHeMPgtjU6ZZ@calendula>
References: <20240620113527.7789-1-changliang.wu@smartx.com>
 <CALHBjYFn_qB=Oo3TTg0znOnNz9rX5jP+eYSZbatAN94ys8Tzmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALHBjYFn_qB=Oo3TTg0znOnNz9rX5jP+eYSZbatAN94ys8Tzmw@mail.gmail.com>
X-Spam-Score: -1.9 (-)

Please, provide an example program for libnetfilter_conntrack.

See:

commit 27f09380ebb0fc21c4cd20070b828a27430b5de1
Author: Felix Huettner <felix.huettner@mail.schwarz>
Date:   Tue Dec 5 09:35:16 2023 +0000

    conntrack: support flush filtering

for instance.

thanks

On Thu, Jul 11, 2024 at 01:40:02PM +0800, Changliang Wu wrote:
> PING
> 
> 
> Changliang Wu <changliang.wu@smartx.com> 于2024年6月20日周四 19:35写道：
> >
> > From cb8aa9a, we can use kernel side filtering for dump, but
> > this capability is not available for flush.
> >
> > This Patch allows advanced filter with CTA_FILTER for flush
> >
> > Performace
> > 1048576 ct flows in total, delete 50,000 flows by origin src ip
> > 3.06s -> dump all, compare and delete
> > 584ms -> directly flush with filter
> >
> > Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
> > ---
> >  net/netfilter/nf_conntrack_netlink.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 3b846cbdc..93afe57d9 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -1579,9 +1579,6 @@ static int ctnetlink_flush_conntrack(struct net *net,
> >         };
> >
> >         if (ctnetlink_needs_filter(family, cda)) {
> > -               if (cda[CTA_FILTER])
> > -                       return -EOPNOTSUPP;
> > -
> >                 filter = ctnetlink_alloc_filter(cda, family);
> >                 if (IS_ERR(filter))
> >                         return PTR_ERR(filter);
> > @@ -1610,14 +1607,14 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
> >         if (err < 0)
> >                 return err;
> >
> > -       if (cda[CTA_TUPLE_ORIG])
> > +       if (cda[CTA_TUPLE_ORIG] && !cda[CTA_FILTER])
> >                 err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
> >                                             family, &zone);
> > -       else if (cda[CTA_TUPLE_REPLY])
> > +       else if (cda[CTA_TUPLE_REPLY] && !cda[CTA_FILTER])
> >                 err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
> >                                             family, &zone);
> >         else {
> > -               u_int8_t u3 = info->nfmsg->version ? family : AF_UNSPEC;
> > +               u8 u3 = info->nfmsg->version || cda[CTA_FILTER] ? family : AF_UNSPEC;
> >
> >                 return ctnetlink_flush_conntrack(info->net, cda,
> >                                                  NETLINK_CB(skb).portid,
> > --
> > 2.43.0
> >
