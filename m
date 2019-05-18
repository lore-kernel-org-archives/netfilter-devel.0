Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A714CC46470
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 19:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A39D2087E
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 19:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbfERT3Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 15:29:24 -0400
Received: from a3.inai.de ([88.198.85.195]:40808 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbfERT3Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 15:29:24 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 035AA3BB8AA1; Sat, 18 May 2019 21:29:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id F05BB3BB8A9E;
        Sat, 18 May 2019 21:29:22 +0200 (CEST)
Date:   Sat, 18 May 2019 21:29:22 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] Extract SYNPROXY infrastructure
In-Reply-To: <20190518182151.1231-1-ffmancera@riseup.net>
Message-ID: <nycvar.YFH.7.76.1905182123390.11501@n3.vanv.qr>
References: <20190518182151.1231-1-ffmancera@riseup.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2019-05-18 20:21, Fernando Fernandez Mancera wrote:

>The patch series have been tested by enabling iptables and ip6tables SYNPROXY.
>All the modules loaded as expected.

What is the subsequent plan? Making new modules brings the usual module 
overhead (16K it seems), and if there is just one user, that seems 
wasteful.

>$ lsmod | grep synproxy
>IPv4 and IPv6:
>nf_synproxy_ipv6       16384  1 ip6t_SYNPROXY
>nf_synproxy_ipv4       16384  1 ipt_SYNPROXY
>nf_synproxy_core       16384  4 ip6t_SYNPROXY,nf_synproxy_ipv6,ipt_SYNPROXY,nf_synproxy_ipv4
>nf_conntrack          159744  8 ip6t_SYNPROXY,xt_conntrack,xt_state,nf_synproxy_ipv6,ipt_SYNPROXY,nf_synproxy_ipv4,nf_synproxy_core,xt_CT

> net/ipv4/netfilter/nf_synproxy_ipv4.c         | 393 ++++++++++++++++
> net/ipv6/netfilter/nf_synproxy_ipv6.c         | 414 +++++++++++++++++
