Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E75C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5283A205ED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfLDRAf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:00:35 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58840 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbfLDRAe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 12:00:34 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icY0u-0001cZ-Q5; Wed, 04 Dec 2019 18:00:32 +0100
Date:   Wed, 4 Dec 2019 18:00:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191204170032.GV14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <BC928D69-611E-4F9E-A457-7C78F6D0779A@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC928D69-611E-4F9E-A457-7C78F6D0779A@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Dec 04, 2019 at 04:13:45PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> It is not static, SVC chain jump rules will be updated on every endpoint change,  the dynamic nature is  achieved by manipulating rules. It is doable with nftables, I understand that, but I was also looking for a more efficient way to do it, my concern is if we use 1 to 1 conversion, we will end up with the same iptables scalability/performance  limitations.
> 
> Here is how rules look after a third and forth endpoint gets dynamically added to the service.
> 
> -A KUBE-SVC-57XVOCFNTLTR3Q27 -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-FS3FUULGZPVD4VYB
> -A KUBE-SVC-57XVOCFNTLTR3Q27 -m statistic --mode random --probability 0.33332999982 -j KUBE-SEP-MMFZROQSLQ3DKOQA
> -A KUBE-SVC-57XVOCFNTLTR3Q27 -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-TEWRTAGT3CD3D47Z
> -A KUBE-SVC-57XVOCFNTLTR3Q27 -j KUBE-SEP-4WMWD734WJQW264U

Ah, that's nice. The rules are updated in a way that with a single added
rule probabilities are equalized again. This is something I fear we
can't do with a map in nftables yet, I guess it would need a new object
type (or maybe a special set/map type or something. All you can do for
now is copy the above in nftables.

Cheers, Phil
