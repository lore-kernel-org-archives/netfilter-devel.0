Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87667C73C7F
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 08:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69ECD2064A
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 08:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfGJIHc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 04:07:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:49738 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbfGJIHc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 04:07:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hl7dS-00068x-HX; Wed, 10 Jul 2019 10:07:30 +0200
Date:   Wed, 10 Jul 2019 10:07:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Naruto Nguyen <narutonguyen2018@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Question about nf_conntrack_proto for IPsec
Message-ID: <20190710080730.c4bjujzkqcjxevmf@breakpoint.cc>
References: <CANpxKHHXzrEpJPSj3x83+WE23G1W0KPz9XbG=fCVzS21+-BpfQ@mail.gmail.com>
 <20190626111322.gks5qptax3iqrjao@breakpoint.cc>
 <CANpxKHGa6DpV-9n8La7wh6r7MbEZpzGTWOO1AhmhWv072b4LAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpxKHGa6DpV-9n8La7wh6r7MbEZpzGTWOO1AhmhWv072b4LAg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Naruto Nguyen <narutonguyen2018@gmail.com> wrote:
> Could you please elaborate more on how generic tracker tracks ESP connection?

All protocols that do not have a more specific l4 tracker are tracked
based on l3 protocol + l4 proto number.

IOW, any ESP packet sent between the same endpoint addresses is seen
as matching a single esp flow.

We could easily add the ESP SPI as additional distinction marker if needed.
