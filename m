Return-Path: <SRS0=BYf1=4P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6476C11D3D
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 19:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855AA24690
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 19:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgB0Tmd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 14:42:33 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43866 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgB0Tmd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 14:42:33 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j7P3F-00070L-2T; Thu, 27 Feb 2020 20:42:29 +0100
Date:   Thu, 27 Feb 2020 20:42:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Ipv6 address in concatenation
Message-ID: <20200227194229.GP19559@breakpoint.cc>
References: <54A7EDF2-F83D-44D7-994C-2C8E35E586AD@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A7EDF2-F83D-44D7-994C-2C8E35E586AD@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> Hello,
> 
> I started testing  nfproxy in ipv6 enabled kubernetes cluster and it seems ipv6 address cannot be a part of concatenation expression. Is there a known issue or it is me doing something incorrect?
> From my side the code is the same, I just change ip4_addr to ip6_addr when I build sets.

types are irrelvant for the kernel.  They are ONLY used by the nft tool
so it knows how to format output.

I suspect you need to fix up the generated payload expressions
for ipv6.  Essentially, in the ipv6 case, you have a concatenation

ipv4_addr . ipv4_addr . ip4_addr . ipv4_addr . inet_service

(ipv6 address needs 4 32-bit registers)

i.e., you need to use a different destination register when you store
the tcp/udp port, else you will clobber a part of the ipv6 address.

