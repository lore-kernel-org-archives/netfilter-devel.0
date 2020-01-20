Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B1AC32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 21:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58BC22522
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 21:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgATVj4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 16:39:56 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57648 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgATVj4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 16:39:56 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1item2-0003fY-5o; Mon, 20 Jan 2020 22:39:54 +0100
Date:   Mon, 20 Jan 2020 22:39:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     sbezverk <sbezverk@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: load balancing between two chains
Message-ID: <20200120213954.GF795@breakpoint.cc>
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
 <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sbezverk <sbezverk@gmail.com> wrote:
> Changed kernel to 5.4.10, and switch to use "inc" instead of "random".  Now first curl works and second fails. Whenever second chain is selected to be used,  curl connection gets stuck. 
> 
>         chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
>                 numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-TMVEFT7EX55F4T62, 1 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 }
>                 counter packets 1 bytes 60 comment ""
>         }
> 
>         chain k8s-nfproxy-sep-TMVEFT7EX55F4T62 {
>                 counter packets 1 bytes 60 comment ""
>                 ip saddr 57.112.0.41 meta mark set 0x00004000 comment ""
>                 dnat to 57.112.0.41:8080 fully-random
>         }
> 
>         chain k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 {
>                 counter packets 0 bytes 0 comment ""
>                 ip saddr 57.112.0.52 meta mark set 0x00004000 comment ""
>                 dnat to 57.112.0.52:8989 fully-random
>         }
> 
> Any debug I could enable to see where the packet goes?

The counter after numgen should not increment, but it does.
Either numgen does something wrong, or hash alg is broken and doesn't
find a result for "1".

There was such a bug but it was fixed in 5.1...

please show:
uname -a
nft --version
