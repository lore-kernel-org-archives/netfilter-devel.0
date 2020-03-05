Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538CEC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 10:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F422208C3
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 10:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCEKxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 05:53:43 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgCEKxm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 05:53:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j9o8K-0007Dm-8S; Thu, 05 Mar 2020 11:53:40 +0100
Date:   Thu, 5 Mar 2020 11:53:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 00/18] Support for boolean binops with variable
 RHS operands.
Message-ID: <20200305105340.GH979@breakpoint.cc>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Kernel support for passing mask and xor values for bitwise boolean
> operations via registers allows us to support boolean binop's with
> variable RHS operands: XOR expressions pass the xor value in a register;
> AND expressions pass the mask value in a register; OR expressions pass
> both mask and xor values in registers.
> 
> NB, OR expressions are converted to `(a & (b ^ 1)) ^ b` during
> linearization (in patch 9), because it makes both linearization and
> delinearization a lot simpler.  However, it involves rearranging and
> allocating expressions after the evaluation phase.  Since nothing else
> does this, AFAICS, I'm not sure whether it's the right thing to do.
> 
> The patch-set comprises four parts:
> 
>    1 -  7: some tidying and bug-fixes;

I've pushed these to master, thanks.
