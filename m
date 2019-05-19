Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AC4C04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 21:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7964520657
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 21:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="TpA3zCZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfESVC7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 17:02:59 -0400
Received: from mx1.riseup.net ([198.252.153.129]:54900 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfESVC7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 17:02:59 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 1F49B1A2224;
        Sun, 19 May 2019 14:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558299779; bh=06XxsKUUvIv0LQbF4ulSKevJWb2at7xPReMP7cei/cs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TpA3zCZvw0ol6xO+cNhAOqsdon9PnEtcXD5EYOQvkzwXWSRV4dzNLRnhiSpaB/qPc
         5g+B7h8XOaxLNEM8vfy7zK9o50ezUQGewmeskvL+ZQEE1XYBOuIZpWKjyjjORjdRL4
         wylRgK//uVjzjm4NPa610BTvR7xJ1iGXyPiihHF8=
X-Riseup-User-ID: 7AB46C56EBCC815368B4DAE06EBF7120F191097156538CF7DEBC46372908C53A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id D3955120236;
        Sun, 19 May 2019 14:02:57 -0700 (PDT)
Subject: Re: [PATCH 0/5] Extract SYNPROXY infrastructure
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20190518182151.1231-1-ffmancera@riseup.net>
 <nycvar.YFH.7.76.1905182123390.11501@n3.vanv.qr>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <60cb782f-9b67-7263-556d-85e439ad9c40@riseup.net>
Date:   Sun, 19 May 2019 23:03:11 +0200
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.1905182123390.11501@n3.vanv.qr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On 5/18/19 9:29 PM, Jan Engelhardt wrote:
> On Saturday 2019-05-18 20:21, Fernando Fernandez Mancera wrote:
> 
>> The patch series have been tested by enabling iptables and ip6tables SYNPROXY.
>> All the modules loaded as expected.
> 
> What is the subsequent plan? Making new modules brings the usual module 
> overhead (16K it seems), and if there is just one user, that seems 
> wasteful.
>

The idea is to simplify these two modules in a single one (as Florian
suggested and it have be done in the v2). At this point, we only need to
implement the nft_synproxy module which is going to be the frontend
module for the nftables support.

In my opinion, SYNPROXY still being useful and it would be nice to
support it in nftables, furthermore there are some improvements planned
to do for the SYNPROXY nftables module. Thank you!

>> $ lsmod | grep synproxy
>> IPv4 and IPv6:
>> nf_synproxy_ipv6       16384  1 ip6t_SYNPROXY
>> nf_synproxy_ipv4       16384  1 ipt_SYNPROXY
>> nf_synproxy_core       16384  4 ip6t_SYNPROXY,nf_synproxy_ipv6,ipt_SYNPROXY,nf_synproxy_ipv4
>> nf_conntrack          159744  8 ip6t_SYNPROXY,xt_conntrack,xt_state,nf_synproxy_ipv6,ipt_SYNPROXY,nf_synproxy_ipv4,nf_synproxy_core,xt_CT
> 
>> net/ipv4/netfilter/nf_synproxy_ipv4.c         | 393 ++++++++++++++++
>> net/ipv6/netfilter/nf_synproxy_ipv6.c         | 414 +++++++++++++++++
