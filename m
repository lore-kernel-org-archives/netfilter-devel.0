Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1,WEIRD_PORT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1B4C33CAA
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 05:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9877C217F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 05:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAUFYV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 00:24:21 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58764 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbgAUFYV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 00:24:21 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1itm1S-0005XI-TO; Tue, 21 Jan 2020 06:24:18 +0100
Date:   Tue, 21 Jan 2020 06:24:18 +0100
From:   Florian Westphal <fw@strlen.de>
To:     sbezverk <sbezverk@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: load balancing between two chains
Message-ID: <20200121052418.GJ795@breakpoint.cc>
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
 <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
 <20200120213954.GF795@breakpoint.cc>
 <BC7FFB04-4465-4B3B-BA5B-17BEA0FC909B@gmail.com>
 <20200120220012.GH795@breakpoint.cc>
 <20200120221225.GI795@breakpoint.cc>
 <F21D35D7-3662-4E47-AACA-65E65DDC28F0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F21D35D7-3662-4E47-AACA-65E65DDC28F0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sbezverk <sbezverk@gmail.com> wrote:
> Hello,
> 
> After changing code to  set element id as a non big-endian, loadbalancing started working, the side effect though,  set shows large number for elements ID.
> 
> sbezverk@kube-4:~$ curl http://57.141.53.140:808
> Still alive pod1 :)
> sbezverk@kube-4:~$ curl http://57.141.53.140:808
> Still alive from pod3 :)
> sbezverk@kube-4:~$ curl http://57.141.53.140:808
> Still alive from pod2 :)
> sbezverk@kube-4:~$ curl http://57.141.53.140:808
> Still alive pod1 :)
> 
>         chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB { # handle 60
>                 numgen inc mod 3 vmap { 0 : goto k8s-nfproxy-sep-TMVEFT7EX55F4T62, 16777216 : goto k8s-nfproxy-sep-23NTSA2UXPPQIPK4, 33554432 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 } # handle 155
>                 counter packets 0 bytes 0 comment "" # handle 136
>         }
> 
> Let me know if you plan to fix it eventually.

This is becuase nft tool stores the key endianess in metadata, so it
can know if it needs to byteswap or not.

See mnl_nft_set_add() in src/mnl.c in nftables source code. Look for
NFTNL_UDATA_SET_KEYBYTEORDER .  If your library sets this to 1
(BYTEORDER_HOST_ENDIAN), nft will display the correct values.


