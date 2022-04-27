Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF04C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiD0P7T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241341AbiD0P7H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:59:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FE487A9BF
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:55:48 -0700 (PDT)
Date:   Wed, 27 Apr 2022 17:55:20 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@chinatelecom.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] nf_flow_table_offload: offload the vlan encap in
 the flowtable
Message-ID: <YmlnaJ2ELDhALNz8@salvia>
References: <1649169515-4337-1-git-send-email-wenx05124561@163.com>
 <YmlO009uqhJNnBq7@salvia>
 <42afa9bb-e265-33e7-c0dc-75d40689ade1@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42afa9bb-e265-33e7-c0dc-75d40689ade1@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 27, 2022 at 11:28:16PM +0800, wenxu wrote:
> 
> On 2022/4/27 22:10, Pablo Neira Ayuso wrote:
> > On Tue, Apr 05, 2022 at 10:38:35AM -0400, wenx05124561@163.com wrote:
> >> From: wenxu <wenxu@chinatelecom.cn>
> >>
> >> This patch put the vlan dev process in the FLOW_OFFLOAD_XMIT_DIRECT
> >> mode. Xmit the packet with vlan can offload to the real dev directly.
> >>
> >> It can support all kinds of VLAN dev path:
> >> br0.100-->br0(vlan filter enable)-->eth
> >> br0(vlan filter enable)-->eth
> >> br0(vlan filter disable)-->eth.100-->eth
> > I assume this eth is a bridge port.
> 
> Yes it is. And it also can support the case without bridge as following.
> 
> eth.100-->eth.
> 
> >
> >> The packet xmit and recv offload to the 'eth' in both original and
> >> reply direction.
> > This is an enhancement or fix?
>
> It's an enhancement and  it make the vlan packet can offload through the real dev.

What's the benefit from the existing approach?

> > Is this going to work for VLAN + PPP?
> >
> > Would you update tools/testing/selftests/netfilter/nft_flowtable.sh to
> > cover bridge filtering usecase? It could be done in a follow up patch.
>
> I will do for both  if this patch reivew ok .

OK.
