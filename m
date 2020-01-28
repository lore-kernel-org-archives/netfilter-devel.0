Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C7CC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 13:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0184E20CC7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 13:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgA1NT0 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 08:19:26 -0500
Received: from correo.us.es ([193.147.175.20]:48672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgA1NT0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 08:19:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 17FA380B3A
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 14:19:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0622FDA878
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 14:19:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 804EAFC5FE; Tue, 28 Jan 2020 14:19:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AD36DA86B;
        Tue, 28 Jan 2020 14:18:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jan 2020 14:18:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 15ABC4301DE0;
        Tue, 28 Jan 2020 14:18:54 +0100 (CET)
Date:   Tue, 28 Jan 2020 14:18:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200128131852.5j3tjzck532fy4qg@salvia>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116144833.jeshvfqvjpbl6fez@salvia>
 <20200116145954.GC18463@azazel.net>
 <20200126111251.e4kncc54umrq7mea@salvia>
 <20200127111314.GA377617@azazel.net>
 <20200128100035.m4s54v5mfrlqvo4e@salvia>
 <20200128113139.GA437225@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200128113139.GA437225@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 28, 2020 at 11:31:39AM +0000, Jeremy Sowden wrote:
> On 2020-01-28, at 11:00:35 +0100, Pablo Neira Ayuso wrote:
> > On Mon, Jan 27, 2020 at 11:13:14AM +0000, Jeremy Sowden wrote:
> > > On 2020-01-26, at 12:12:51 +0100, Pablo Neira Ayuso wrote:
> > > > I've been looking into (ab)using bitwise to implement add/sub. I
> > > > would like to not add nft_arith for only this, and it seems to me
> > > > much of your code can be reused.
> > > >
> > > > Do you think something like this would work?
> > >
> > > Absolutely.
> > >
> > > A couple of questions.  What's the use-case?
> >
> > inc/dec ip ttl field.
> 
> If it's just a simple addition or subtraction on one value, would
> this make more sense?
> 
>         for (i = 0; i < words; i++) {
> 	        dst[i] = src[i] + delta;
> 	        delta = dst[i] < src[i] ? 1 : 0;
>         }

This can be done through _INC / _DEC instead, however...

> > > I find the combination of applying the delta to every u32 and having
> > > a carry curious.  Do you want to support bigendian arithmetic (i.e.,
> > > carrying to the left) as well?
> >
> > Userspace should convert to host endianess before doing arithmetics.
> 
> Yes, but if the host is bigendian, the least significant bytes will be
> on the right, and we need to carry to the left, don't we?
> 
>         for (i = words; i > 0; i--) {
> 	        dst[i - 1] = src[i - 1] + delta;
> 	        delta = dst[i - 1] < src[i - 1] ? 1 : 0;
>         }

I think some simplified version of bignum add/subtract is needed,
something like:

        for (i = len - 1; i >= 0; i--) {
                res[i] = a[i] + b[i] + carry;
                carry = res[i] < a[i] + b[i];
        }

where 'len' is in bytes. Values in a[] and b[] are u8 and data is
represented in big endian.
