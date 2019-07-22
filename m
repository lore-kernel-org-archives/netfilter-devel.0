Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F151C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 08:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00ECC21E6B
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 08:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGVIpn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 04:45:43 -0400
Received: from mail.us.es ([193.147.175.20]:56004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVIpn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 04:45:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30E09F2630
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 10:45:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DAF31150DD
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 10:45:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11E27909A8; Mon, 22 Jul 2019 10:45:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 003BADA708;
        Mon, 22 Jul 2019 10:45:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jul 2019 10:45:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1ED740705C3;
        Mon, 22 Jul 2019 10:45:36 +0200 (CEST)
Date:   Mon, 22 Jul 2019 10:45:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?utf-8?Q?=C4=B0brahim?= Ercan <ibrahim.metu@gmail.com>
Cc:     Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, ffmancera@riseup.net
Subject: Re: [PATCH v2] netfilter: synproxy: erroneous TCP mss option fixed.
Message-ID: <20190722084535.gnk25y2weo4h44xl@salvia>
References: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
 <1561441324-19193-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
 <20190627185744.ynxyes7an6gd7hlg@salvia>
 <20190627190019.hrlowm5lxw7grmsk@breakpoint.cc>
 <20190627190857.f6lwop54735wo6dg@salvia>
 <20190627192109.zpkn2vff3ykin6ya@breakpoint.cc>
 <20190627192705.eyy4aond5yl5jjrr@salvia>
 <20190701185825.32mmnw4jdtsj7avr@salvia>
 <CAK6Qs9mp7E3Wr4Zo8mLgsbLMwZRCaQoy=3nRx3XDJP4mcgNSEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK6Qs9mp7E3Wr4Zo8mLgsbLMwZRCaQoy=3nRx3XDJP4mcgNSEA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 11:31:45AM +0300, İbrahim Ercan wrote:
> On Mon, Jul 1, 2019 at 9:58 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi Ibrahim,
> >
> > On Thu, Jun 27, 2019 at 09:27:05PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Jun 27, 2019 at 09:21:09PM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > On Thu, Jun 27, 2019 at 09:00:19PM +0200, Florian Westphal wrote:
> > > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > [...]
> > > > > I see, probably place client_mss field into the synproxy_options
> > > > > structure?
> > > >
> > > > I worked on a fix for this too (Ibrahim was faster), I
> > > > tried to rename opts.mss so we have
> > > >
> > > > u16 mss_peer;
> > > > u16 mss_configured;
> > > >
> > > > but I got confused myself as to where which mss is to be used.
> > > >
> > > > perhaps
> > > > u16 mss_option;
> > > > u16 mss_encode;
> > > >
> > > > ... would have been better.
> > >
> > > I would leave the opts.mss as is by now. Given there will be a
> > > conflict between nf-next and nf, I was trying to minimize the number
> > > of chunks for this fix, but that's just my preference (I'll have to
> > > sort out this it seems).
> > >
> > > Then, adding follow up patches to rename fields would be great indeed
> > > as you suggest.
> >
> > @Ibrahim: Would you follow up with patch v3?
> >
> > I'd name this 'mss_backend' to opts, instead of adding client_mss as
> > parameter. Since this is the MSS that the server backend behind the
> > proxy.
> >
> > I don't mind names, if you prefer Florian's, that's also fine. I'd
> > just like not to add a new parameter to synproxy_send_client_synack().
> >
> > Thanks.
> 
> Sorry for late reply. I was offline for 3 weeks. I will send new patch asap.

Please, do, based it on kernel 5.2

Fernando already made a patch for 5.3-rc, we'll take your patch for
-stable, as a backport.
