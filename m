Return-Path: <SRS0=r5Yn=RM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D38C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Mar 2019 09:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2214A207E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Mar 2019 09:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYZ+XKSL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfCIJHb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:07:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38997 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfCIJHa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 04:07:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id l12so7316013wrp.6;
        Sat, 09 Mar 2019 01:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t1+DagdXb5qvLSg6yYqsox3wUiznj2VbLCJfNL8S6Eo=;
        b=AYZ+XKSL5ILOPNz0xvKZUuWuff/VkAkUTo9srfPL5UHuGrC8pd18uscBGw6zjeaSQo
         jawzCwM123idCqViknJLSy3BUTRELddi+nftdtOfq5FrBlisfFK+BotaSm5uiwDzs/V/
         6TwbyN9cCVY8Efhfup94NSCTKBFowWMw3AhkVomJmEb+5r7vKqsERXsnP/MohFl2yWbA
         S7ypPMJ1+zOwmg91iH86KrmuUtuuUswWC6N/aUMh5/gndXzMWzsty2T5FZgWQB2P0SEo
         wGB8hSfv3Rr2yZXWMYcf0F3UTUDCp3jc0DbUAIn6QwSShlrfTTeB+FeP2jD7XYDi8wgA
         JMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t1+DagdXb5qvLSg6yYqsox3wUiznj2VbLCJfNL8S6Eo=;
        b=aOfbnizFNi8Nbc3KfEVFqUGxOi5r445hrUXbhZsFRCYqTTbLxL9aDcRhRVzpquVgmJ
         KIrB01bOcl8pfSv8Qi6JpgnVK/oLSKMBp1IKK3MBQV6qt/YPEihzIf0N+73BS3RXjp7v
         YLXBSo/xpcVfhvWuXiQILV/x0b4CYcD5oEJhbyBGh4+SV/dFT1zpaBj08BnClshmPpxP
         vlaAe9V/JZygnotR875iXmZia5TxOaH5AJBzIkDxNsYuzQ6fHMuypMKAW7PQ5bcDaFqq
         ITZ9xL2pZKMuGamZ6Eg3zg4ILzj/r2TCvcDIt8CNT7kGmxTLr5kUHcO4wJnKyBfMTOwx
         N7Ig==
X-Gm-Message-State: APjAAAXLro98r1JUQUYtXqNOQNPLMC7/xYeHeKs6ptmj9c7eRwtcBg3x
        Upc3fgyNl0lSgPshAbAqFuDAFaw/QPF5J7vj66Y=
X-Google-Smtp-Source: APXvYqx1MBcl0mRIZZFZi3XFtlCHQnv5hO5U/KbefsHKjz2F37DmeRvgkoBtLT9RNurHh0MpH84hNIRdBvbPOF2e884=
X-Received: by 2002:a5d:62cc:: with SMTP id o12mr13566070wrv.242.1552122449012;
 Sat, 09 Mar 2019 01:07:29 -0800 (PST)
MIME-Version: 1.0
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
 <20190308155049.by7f4uzjxqnf3xu7@salvia>
In-Reply-To: <20190308155049.by7f4uzjxqnf3xu7@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 9 Mar 2019 17:07:17 +0800
Message-ID: <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling sctp_compute_cksum
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Neil Horman <nhorman@tuxdriver.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 8, 2019 at 11:50 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Sun, Mar 03, 2019 at 04:17:21PM +0800, Xin Long wrote:
> > sctp_hdr(skb) only works when skb->transport_header is set
> > properly.
> >
> > But in the path of nf_conntrack_in:
> >
> >   sctp_packet() -> sctp_error() -> sctp_compute_cksum().
> >
> > skb->transport_header is not guaranteed to be right value
> > for sctp. It will cause to fail to check the checksum for
> > sctp packets.
> >
> > So fix it by setting skb transport_header before calling
> > sctp_compute_cksum().
>
> I see a few more calls to sctp_compute_cksum() in the netfilter tree.
> I guess they are broken too.
>
> In netfilter, skb->transport_header is never set from the input path,
> I think this introduces an assymmetry with other transport protocols.
>
> May we have a variant of sctp_compute_cksum() which does not rely on
> sctp_hdr() instead?
I posted one before this:
  https://marc.info/?l=linux-netdev&m=155109395226858&w=2
But from sctp side, Neil preferred sctp_hdr().

We need to either add skb_set_transport_header() in sctp_s/dnat_handler()
and sctp_manip_pkt(), or bring that patch back?

Now it seems not good to set skb->transport_header in netfilter code.
Hi Neil, what's your point now?
