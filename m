Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACD7C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 08:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7213214AF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 08:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P83dDWvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfCLIj7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:39:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46125 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbfCLIj7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 04:39:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id i16so1628875wrs.13;
        Tue, 12 Mar 2019 01:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uoLt4wESGf9vHMX04cuwgXj8AbCdFKB1d6jh7KiwYEk=;
        b=P83dDWvMh/N0kJH8Y8vxz/u0T3kwhNyshoNH/cBT4NPnT5QRE02MIZLMvRQE8Bc+GB
         yPdVnQEJakWijmHVngGsDUcQPZt6X8U2Jxde0nM0wIAgFwEHv3WCZfpqED6gtH/25Vl8
         YA5Nrqbw4fDSD67my5ijb5hsZozruG9MMHiqHF/g6o6r3fz3AEfkwibY0KJk5QscguP0
         B1KshEcGpBuX22XZi8jTSoog8xFcRc/QpkOilSCKHBEqUd4gXVaxupIwYr43XhBDe2iQ
         Y5IFC0BsRczhYx5hoaQFs2BgeK3SM/u1hgdF7syrXSKvjUxIbH6qFtzwkmDfrluwp82u
         dGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uoLt4wESGf9vHMX04cuwgXj8AbCdFKB1d6jh7KiwYEk=;
        b=FQ/gM4juHtwK738UXhSw2Zive52BTpVfG+AWO1tnoWFJA4k55+psl8f5NWk48ctaXN
         0JNSgIuPTDrQkJj1uq1NmL0vU0ESbKRPAVz+SmrZbNMFFgP07vudCYd8ZG99WtqwHypn
         KmlVbQg8ZqQ8+qRvg5V7Ltjl85TPGLyReq3B5Awnr3NK7LyXzvFhuz+/ngcc04OIMJg7
         xmNn/X5+FEbD8CjyILtN6bLtcyZ27H6DAEGJrYrMHF3mSSKThN5JHQHCG1RRlaqJgbb9
         a6MeJQ+O9JV00TBys3a+Zgz8QQdQUdPSMeLX7TGcwN/h4tq6CnDao1sPpdYxk6oTHHeo
         WGFQ==
X-Gm-Message-State: APjAAAV7notIClUprTR1uDekwNKzyfRKgOGWEjDMskdzMRUWg2Geep3u
        MXctjmjnZjuER52rejHmsP0fLOfa1BiIHAvJq+0=
X-Google-Smtp-Source: APXvYqw65RDBLse7NWukevI6jpdkiNFDss1FLGKtvUyruy4AXRESy18riIO8QCBEWZY/sEtYeQcxpq2zpCWQsNF0UnA=
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr3590080wrn.242.1552379997323;
 Tue, 12 Mar 2019 01:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
 <20190308155049.by7f4uzjxqnf3xu7@salvia> <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
 <20190309092434.oflik6j57yrhpkh5@breakpoint.cc> <20190311110752.GA30241@hmswarspite.think-freely.org>
In-Reply-To: <20190311110752.GA30241@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Mar 2019 16:39:46 +0800
Message-ID: <CADvbK_dUUyECm57EPmqHyQnh-mkVNz5u-0MCrhtpo80PCr51fA@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling sctp_compute_cksum
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 7:08 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Sat, Mar 09, 2019 at 10:24:34AM +0100, Florian Westphal wrote:
> > Xin Long <lucien.xin@gmail.com> wrote:
> > >   https://marc.info/?l=linux-netdev&m=155109395226858&w=2
> > > But from sctp side, Neil preferred sctp_hdr().
> > >
> > > We need to either add skb_set_transport_header() in sctp_s/dnat_handler()
> > > and sctp_manip_pkt(), or bring that patch back?
> > >
> > > Now it seems not good to set skb->transport_header in netfilter code.
> >
> > I think its fine, but I wonder why we need to do it.
> >
> > Since 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3 ipv4 input path sets
> > transport header before netfilter.  The only problem is that linear
> > access is illegal without may_pull checks, but in this case the
> > make_writable call takes care of this already.
> >
> Yes, this.  It seems to me we should be setting the transport header prior to
> ever getting into the netfilter code, which does imply that we need the may_pull
> check to linearize enough of the packet to do so, just like tcp and udp do.
>
> > So, why was this patch needed?

The issue was reported when going to nf_conntrack by br_netfilter's
bridge-nf-call-iptables, which could be:

br_prerouting->inet_prerouting->
br_forward->inet_forward->
br_postrouting->inet_postrouting

> > If we need it, do we also need to add it in other locations that
> > deal with sctp csum (e.g. in ipvs?).
So ipvs hooks are in inet_local_in/out, sctp_s/dnat_handler() won't
be affected.
But the one in sctp_manip_pkt() that may be in inet_pre/postrouting
will need to set it.

I will post v2 with skb_set_transport_header(skb, dataoff) added in
sctp_manip_pkt().

agreed?

> >
> This is a fair question, and I'm not yet sure of the answer.
>
> > Thanks,
> > Florian
> >
