Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BTC_ID,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DC8C2BC73
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6DEA206DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfLDPRl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 10:17:41 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58664 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfLDPRl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 10:17:41 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icWPK-0000YE-4e; Wed, 04 Dec 2019 16:17:38 +0100
Date:   Wed, 4 Dec 2019 16:17:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191204151738.GR14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Dec 04, 2019 at 01:47:47PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Thank you for your reply. It is very unfortunate indeed. Here is the scenario where I thought to use a non-anonymous vmap.
> 
> Each k8s service can have 0, 1 or more associated endpoints, backends (pods providing this service). 0 endpoint already taken care of in filter prerouting hook.  When there are 1 or more, proxy needs to load balance incoming connections between endpoints.I thought to create vmap per service with 1 rule per service . When an endpoint gets updated (add/deleted) which could happen anytime then the only vmap get corresponding update and my hope was that automagically load balancing will be adjusted to use updated endpoints list.
> 
> With what you explained, I am not sure if dynamic load balancing is possible at all. If numgen work only with static anonymous vmap and fixed modulus , the only way to address this dynamic nature of endpoints is to recreate service rule everytime when number of endpoints changes (recalculate modulus and entries in vmap). I suspect it is way less efficient.

Well, if you have a modulus of, say, 5 and your vmap contains only
entries 0 to 3 your setup is broken anyway. So I guess you will need to
adjust modulus along with entries in vmap at all times.

What is the iptables-equivalent you want to replace? Maybe that serves
as inspiration for how to solve it in nftables.

> What will happen to dataplane and packets in transit when the rule will be deleted and then recreated? I suspect it might result in dropped packets, could you please comment on the possible impact?

Well, you could replace the rule in a single transaction, that would
eliminate the timespan the rule doesn't exist. AFAICT, this is RCU-based
so packets will either hit the old or the new rule then.

Cheers, Phil
