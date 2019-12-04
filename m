Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D287FC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 10:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7B772068E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 10:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfLDKgs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 05:36:48 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58198 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfLDKgs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 05:36:48 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icS1T-0006I3-Jq; Wed, 04 Dec 2019 11:36:43 +0100
Date:   Wed, 4 Dec 2019 11:36:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191204103643.GO8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
References: <20191127160646.GK8016@orbyte.nwl.cc>
 <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
 <20191127172210.GM8016@orbyte.nwl.cc>
 <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
 <20191128130814.GQ8016@orbyte.nwl.cc>
 <00B4F260-EA79-4EC1-B7B4-8A9C9D2C96DE@cisco.com>
 <20191128151511.GU8016@orbyte.nwl.cc>
 <97A2D022-C314-4DC4-813D-C319AE9A8DB3@cisco.com>
 <20191130000416.GX8016@orbyte.nwl.cc>
 <9E56E734-8E3C-4BB5-AD31-1A8A703CEBCE@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E56E734-8E3C-4BB5-AD31-1A8A703CEBCE@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Dec 03, 2019 at 06:43:19PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Started working on nat portion and here is iptables rule which is a bit concerning.
> 
> -A KUBE-SERVICES -d 192.168.80.104/32 -p tcp -m comment --comment "default/portal:portal external IP" -m tcp --dport 8989 -m physdev ! --physdev-is-in -m addrtype ! --src-type LOCAL -j KUBE-SVC-MUPXPVK4XAZHSWAR
> 
> I can address " addrtype" with nftables "fib" and " iif type local" but I am not sure about "physdev", appreciate any suggestions.

I think you can use 'meta iiftype != "bridge"' in this case.

Cheers, Phil
