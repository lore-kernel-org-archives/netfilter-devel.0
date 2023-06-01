Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5F9C77B7E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 19:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjFATBT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjFATBO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 15:01:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B41318C
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 12:01:12 -0700 (PDT)
Date:   Thu, 1 Jun 2023 21:01:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     ValdikSS <iam@valdikss.org.ru>, netfilter-devel@vger.kernel.org
Subject: Re: xtables-addons: ipp2p does not block TCP traffic with nonlinear
 skb
Message-ID: <ZHjq9njpY29PuTue@calendula>
References: <2b05bb89-08bf-b3b1-c2d7-9b391953f303@valdikss.org.ru>
 <7rr4q976-5qn6-382r-0pp-66rq492r9376@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7rr4q976-5qn6-382r-0pp-66rq492r9376@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 31, 2023 at 11:41:07AM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2023-05-31 08:42, ValdikSS wrote:
> > However, it's not getting processed due to nonlinear skb:
> >
> >> static bool
> >> ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >>  /* make sure that skb is linear */
> >>  if (skb_is_nonlinear(skb)) {
> >>   if (info->debug)
> >>   	printk("IPP2P.match: nonlinear skb found\n");
> >>  	return 0;
> >>  }
> 
> It should be possible to just take the code from xt_ECHO and call
> 
> if (skb_linearize(skb) < 0)
> 	return false;
> 
> However, none of the xtables matches in the Linux kernel do this linearization,
> at least not that I can see directly. Or xt_string's call to skb_find_text is
> magic..

skb_find_text() deals with non-linear skbuff, see skb_seq_read().
