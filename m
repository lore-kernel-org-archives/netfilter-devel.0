Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19317C33CB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 12:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3932053B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 12:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgAQMA5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 07:00:57 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:35454 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgAQMA5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 07:00:57 -0500
Received: from obook (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 253B340052;
        Fri, 17 Jan 2020 13:00:55 +0100 (CET)
Message-ID: <1e3cec29b871a86cc508e05b59405b2feaf79545.camel@strongswan.org>
Subject: Re: [PATCH netfilter/iptables] Add new slavedev match extension
From:   Martin Willi <martin@strongswan.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Date:   Fri, 17 Jan 2020 13:00:54 +0100
In-Reply-To: <20200116195939.5ordyhfwfspspafa@salvia>
References: <20191217135616.25751-1-martin@strongswan.org>
         <83ada82dbc93439d794c2407e3c91dd1b69bcbaa.camel@strongswan.org>
         <20200116195939.5ordyhfwfspspafa@salvia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


> > So I guess there is some value in these patches for those users to
> > extend their filtering with VRF support.
> 
> A single xt_slavedev module only for this is too much overhead, if
> you find an existing extension (via revision infrastructure) where
> you can make this fit in, I would consider this.

The only feasible candidate I see is the physdev match. However, there
is not much in common code-wise. And from a user perspective, slavedev
matching via physdev and the interaction between these functionalities
just makes that confusing.

So for now I'll keep the slavedev match out-of-tree, then.

Thanks,
Martin

