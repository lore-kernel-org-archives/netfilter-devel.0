Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CCCC48BE9
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 13:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 172C7212F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 13:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731163AbfFXNcp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 09:32:45 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54006 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729145AbfFXNcp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 09:32:45 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfP5O-0001Ry-Ty; Mon, 24 Jun 2019 15:32:42 +0200
Date:   Mon, 24 Jun 2019 15:32:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?utf-8?Q?=C4=B0brahim?= Ercan <ibrahim.metu@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Is this possible SYN Proxy bug?
Message-ID: <20190624133242.vobuzktcqthmiork@breakpoint.cc>
References: <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
 <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc>
 <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
 <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com>
 <20190621111021.2nqtvdq3qq2gbfqy@breakpoint.cc>
 <CAK6Qs9m88cgpFPaVp2qfQsepgtoa02vap1wzkdkgaSuTMm_ELw@mail.gmail.com>
 <20190624102006.t27x6ptnl647mcji@breakpoint.cc>
 <CAK6Qs9mYTbynefS-AT7N+FPo-hbFFGxEncrU_dvO6Yjc6OFG1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK6Qs9mYTbynefS-AT7N+FPo-hbFFGxEncrU_dvO6Yjc6OFG1g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

İbrahim Ercan <ibrahim.metu@gmail.com> wrote:
> > > When I examine traffic from pcap file, I saw connections opens
> > > successfully but somehow something goes wrong after then.
> >
> > Do you have an example pcap of a connection stalling?
> 
> I will ready and send it to you soon. Can I send a file to this mail
> list? Or should I send it directly your personal email?

You could pastebin tcpdump text mode, upload a file somewhere, create
a bugzilla ticket on https://bugzilla.netfilter.org/ and attach the pcap
there or send it to my personal email.
