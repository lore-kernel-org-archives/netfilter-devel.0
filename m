Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F311C33CA4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 16:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60845205F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 16:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgAJQeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 11:34:16 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:58662 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgAJQeQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 11:34:16 -0500
Received: from obook (216.224.197.178.dynamic.wless.zhbmb00p-cgnat.res.cust.swisscom.ch [178.197.224.216])
        by mail.strongswan.org (Postfix) with ESMTPSA id 99A0C41897;
        Fri, 10 Jan 2020 17:34:13 +0100 (CET)
Message-ID: <83ada82dbc93439d794c2407e3c91dd1b69bcbaa.camel@strongswan.org>
Subject: Re: [PATCH netfilter/iptables] Add new slavedev match extension
From:   Martin Willi <martin@strongswan.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Date:   Fri, 10 Jan 2020 17:34:12 +0100
In-Reply-To: <20191217135616.25751-1-martin@strongswan.org>
References: <20191217135616.25751-1-martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo,

> This patchset introduces a new Netfilter match extension to match
> input interfaces that are associated to a layer 3 master device. The
> first patch adds the new match to the kernel, the other provides an
> extension to userspace iptables to make use of the new match.

These patches have been marked as superseded in patchworks, likely due
to Florian's nftables version that has been merged.

While I very much appreciate the addition of VRF interface matching to
nftables, some users still depend on plain iptables for filtering. So I
guess there is some value in these patches for those users to extend
their filtering with VRF support.

Is there a chance of bringing in slavedev matching for iptables, or do
we have a policy to implement new features in nftables, only?

Thanks,
Martin 



