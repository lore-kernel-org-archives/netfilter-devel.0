Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC3EC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 18:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C39207FD
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 18:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgA1StX convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 13:49:23 -0500
Received: from correo.us.es ([193.147.175.20]:53034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbgA1StW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 13:49:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7EED120826
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 19:49:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9675EDA713
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 19:49:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C0A2DA711; Tue, 28 Jan 2020 19:49:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6631EDA707;
        Tue, 28 Jan 2020 19:49:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jan 2020 19:49:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4AF8142EF4E0;
        Tue, 28 Jan 2020 19:49:19 +0100 (CET)
Date:   Tue, 28 Jan 2020 19:49:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200128184918.d663llqkrmaxyusl@salvia>
References: <20200119181203.60884-1-jeremy@azazel.net>
 <20200127093304.pqqvrxgyzveemert@salvia>
 <20200127111343.GB377617@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200127111343.GB377617@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Mon, Jan 27, 2020 at 11:13:43AM +0000, Jeremy Sowden wrote:
> On 2020-01-27, at 10:33:04 +0100, Pablo Neira Ayuso wrote:
> > On Sun, Jan 19, 2020 at 06:12:03PM +0000, Jeremy Sowden wrote:
> > > When a unary expression is inserted to implement a byte-order
> > > conversion, the expression being converted has already been
> > > evaluated and so expr_evaluate_unary doesn't need to do so.  For
> > > most types of expression, the double evaluation doesn't matter since
> > > evaluation is idempotent.  However, in the case of payload
> > > expressions which are munged during evaluation, it can cause
> > > unexpected errors:
> > >
> > >   # nft add table ip t
> > >   # nft add chain ip t c '{ type filter hook input priority filter; }'
> > >   # nft add rule ip t c ip dscp set 'ip dscp | 0x10'
> > >   Error: Value 252 exceeds valid range 0-63
> > >   add rule ip t c ip dscp set ip dscp | 0x10
> > >                               ^^^^^^^
> >
> > I'm still hitting this after applying this patch.
> >
> > nft add rule ip t c ip dscp set ip dscp or 0x10
> > Error: Value 252 exceeds valid range 0-63
> > add rule ip t c ip dscp set ip dscp or 0x10
> >                             ^^^^^^
> > Probably problem is somewhere else? I'm not sure why we can assume
> > here that the argument of the unary expression should not be
> > evaluated.
> 
> I'll take another look.

I think stmt_evaluate_payload() is incomplete, this function was not
made to deal with non-constant expression as values.

Look:
        tcp dport set tcp sport

works because it follows the 'easy path', ie. no adjustment to make
the checksum calculation happy (see payload_needs_adjustment() in
stmt_evaluate_payload().

However:

        ip dscp set ip dscp

bails out with:

        nft add rule ip t c ip dscp set ip dscp
        Error: Value 252 exceeds valid range 0-63
        add rule ip t c ip dscp set ip dscp
                                    ^^^^^^^

because this follows the more complicated path. Looking at this code,
this path assumes a constant value, ie. ip dscp set 10. A more complex
thing such a non-constant expression (as in the example above) will
need a bit of work.

Probably you can start making a patchset make this work:

        add rule ip t c tcp dport set tcp dport lshift 1

which triggers:

BUG: invalid binary operation 4
nft: netlink_linearize.c:592: netlink_gen_binop: Assertion `0' failed.

since it's missing the bytecode to generate the left-shift. Not very
useful for users, but we can get something already merged upstream and
you'll be half-way done. Merge also a few tests.

Then, once the more fundamental rshift/lshift bits are merged, look at
this 'harder' path. Just a proposal.

For reference, the expression tree that stmt_evaluate_payload() to
make the checksum adjustment looks like this:

           xor
          /   \
        and   value
        / \
payload_   mask
 bytes

payload_bytes extends the payload expression to get up to 16-bits.
The left hand side is there to fetch bits that need to be left
untouched. The right hand side represent the bits that need to be set.

In the new non-constant scenario, the 'value' tree is actually a
binary operation:

         shift
        /    \
   payload   imm

The unary should not really be there, it's likely related to some
incorrect byteorder issue that kicks in with non-constant expression.

So more work on stmt_evaluate_payload() is required.
