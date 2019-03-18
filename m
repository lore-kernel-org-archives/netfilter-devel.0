Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570CDC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 331B520863
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfCRPWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:22:45 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:35959 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfCRPWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:22:44 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2019 11:22:44 EDT
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5u63-0002iF-Cj; Mon, 18 Mar 2019 16:22:41 +0100
Date:   Mon, 18 Mar 2019 16:22:39 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
Message-ID: <20190318152239.qtlyyimtdwqygq2q@salvia>
References: <20190313211622.389120-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313211622.389120-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 10:15:59PM +0100, Arnd Bergmann wrote:
> With NETFILTER_XT_TARGET_TEE=y and IP6_NF_IPTABLES=m, we get a link
> error when referencing the NF_DUP_IPV6 module:
> 
> net/netfilter/xt_TEE.o: In function `tee_tg6':
> xt_TEE.c:(.text+0x14): undefined reference to `nf_dup_ipv6'
> 
> The problem here is the 'select NF_DUP_IPV6 if IP6_NF_IPTABLES'
> that forces NF_DUP_IPV6 to be =m as well rather than setting it
> to =y as was intended here. Adding a soft dependency on
> IP6_NF_IPTABLES avoids that broken configuration.

Applied, thanks Arnd.
