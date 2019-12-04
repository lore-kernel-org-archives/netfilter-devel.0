Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67F2C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C78E20833
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfLDP4V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 10:56:21 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58732 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbfLDP4V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 10:56:21 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icX0l-000111-TD; Wed, 04 Dec 2019 16:56:19 +0100
Date:   Wed, 4 Dec 2019 16:56:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191204155619.GU14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 04, 2019 at 03:42:00PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Hi Phil,
> 
> I can also minimize any impact by inserting a new rule in front of the old one, and then delete the old one. So in this case there should no any impact. Here is iptables rules I try to mimic:

Yes, that's more or less equivalent to doing it in a single transaction.

> // -A KUBE-SVC-57XVOCFNTLTR3Q27 -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-FS3FUULGZPVD4VYB
> // -A KUBE-SVC-57XVOCFNTLTR3Q27 -j KUBE-SEP-MMFZROQSLQ3DKOQA
> // !
> // ! Endpoint 1 for KUBE-SVC-57XVOCFNTLTR3Q27
> // !
> // -A KUBE-SEP-FS3FUULGZPVD4VYB -s 57.112.0.247/32 -j KUBE-MARK-MASQ
> // -A KUBE-SEP-FS3FUULGZPVD4VYB -p tcp -m tcp -j DNAT --to-destination 57.112.0.247:8080
> // !
> // ! Endpoint 2 for KUBE-SVC-57XVOCFNTLTR3Q27
> // !
> // -A KUBE-SEP-MMFZROQSLQ3DKOQA -s 57.112.0.248/32 -j KUBE-MARK-MASQ
> // -A KUBE-SEP-MMFZROQSLQ3DKOQA -p tcp -m tcp -j DNAT --to-destination 57.112.0.248:8080
> 
> As you can see SVC chain KUBE-SVC-57XVOCFNTLTR3Q27 load balance between 2 endpoints.

OK, static load-balancing between two services - no big deal. :)

What happens if config changes? I.e., if one of the endpoints goes down
or a third one is added? (That's the thing we're discussing right now,
aren't we?)

Cheers, Phil
