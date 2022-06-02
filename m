Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE6BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 13:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiFBNlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 09:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiFBNlP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 09:41:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BA921F5771
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 06:41:14 -0700 (PDT)
Date:   Thu, 2 Jun 2022 15:41:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        fw@strlen.de
Subject: Re: Alternative SCTP l4 tracker?
Message-ID: <Ypi998Ub9mkHP1FF@salvia>
References: <DBBP189MB14330946CBC8D2A8E953652595DE9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DBBP189MB14330946CBC8D2A8E953652595DE9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 02, 2022 at 09:47:04AM +0000, Sriram Yagnaraman wrote:
> Hi,
> 
> I am building a simple conntrack module for SCTP protocol. It is specified in a draft that still under review: https://www.ietf.org/archive/id/draft-porfiri-tsvwg-sctp-natsupp-03.txt
> The idea with the draft is to only look at SCTP INIT chunks and use timers to handle the rest of the state handling. 
> 
> I would like to minimize the number of changes I make inside the existing conntrack, since this is just a research project as of now.
> The question is if it is possible to have an external conntrack module that handles SCTP instead of the built-in SCTP l4 tracker?
> 
> I have tried the following ideas, but am not happy with any of them
> 1. Register a kprobe for nf_conntrack_sctp_packet() and do my tracking there, but getting the original function arguments is messy and the original nf_conntrack_sctp_packet is still called
> 2. Change NF_CT_PROTO_SCTP to tristate and load my module at start up instead of the original SCTP l4 tracker, and use a function pointer for nf_conntrack_sctp_packet()
> 3. Modify existing SCTP l4 tracker directly 
> 
> I would be happy to try any other suggestion someone here might have.

Number #3, you will have to send incremental patches for review.

I would suggest you start by adding a test to tools/testing/selftests/netfilter/

Florian has been adding most of the tests there, he can probably
provide a few hints/ideas on what would be good to cover.
