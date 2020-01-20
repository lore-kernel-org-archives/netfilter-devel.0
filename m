Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4F4C33CAA
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 17:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0291F21D7E
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 17:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgATRG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 12:06:59 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56688 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727285AbgATRG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 12:06:59 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1itaVs-0002Lb-NA; Mon, 20 Jan 2020 18:06:56 +0100
Date:   Mon, 20 Jan 2020 18:06:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     sbezverk <sbezverk@gmail.com>
Cc:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: load balancing between two chains
Message-ID: <20200120170656.GE795@breakpoint.cc>
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sbezverk <sbezverk@gmail.com> wrote:
> HI Phil,
> 
> There is no loadblancer, curl is executed from the actual node with both pods, so all traffic is local to the node.
> 
> As per your suggestion I modified nfproxy rules:
> 
>         chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
>                 numgen random mod 2 vmap { 0 : goto k8s-nfproxy-sep-I7XZOUOVPIQW4IXA, 1 : goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ }
>                 counter packets 3 bytes 180 comment ""
>         }
> 
>         chain k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ {
>                 counter packets 0 bytes 0 comment ""
>                 ip saddr 57.112.0.38 meta mark set 0x00004000 comment ""
>                 dnat to 57.112.0.38:8080 fully-random
>         }
> 
>         chain k8s-nfproxy-sep-I7XZOUOVPIQW4IXA {
>                 counter packets 1 bytes 60 comment ""
>                 ip saddr 57.112.0.36 meta mark set 0x00004000 comment ""
>                 dnat to 57.112.0.36:8989 fully-random
>         }

Weird, it looks like it generates 0 and something else, not 1.

Works for me on x86_64 with 5.4.10 kernel:

table ip test {
        chain output {
                type filter hook output priority filter; policy accept;
                jump k8s-nfproxy-svc-M53CN2XYVUHRQ7UB
        }

        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
                numgen random mod 2 vmap { 0 : goto k8s-nfproxy-sep-I7XZOUOVPIQW4IXA, 1 : goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ }
                counter packets 0 bytes 0
        }

        chain k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ {
                counter packets 68602 bytes 5763399
                ip saddr 57.112.0.38 meta mark set 0x00004000 comment ""
        }

        chain k8s-nfproxy-sep-I7XZOUOVPIQW4IXA {
                counter packets 69159 bytes 5809685
                ip saddr 57.112.0.36 meta mark set 0x00004000 comment ""
        }
}

(I removed nat rules and then ran ping -f 127.0.0.1).

Does it work when you use "numgen inc" instead of "numgen rand" ?
