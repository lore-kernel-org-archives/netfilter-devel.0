Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32C2C10F00
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 09:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB4B52082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 09:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfC0Ja3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:30:29 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39256 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbfC0Ja3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 05:30:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h94t9-00034w-3V; Wed, 27 Mar 2019 10:30:27 +0100
Date:   Wed, 27 Mar 2019 10:30:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Simon Kirby <sim@hostway.ca>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org
Subject: Re: Inability to IPVS DR with nft dnat since 9971a514ed26
Message-ID: <20190327093027.gmflo27icuhr326p@breakpoint.cc>
References: <20190327062650.GA10700@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327062650.GA10700@hostway.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simon Kirby <sim@hostway.ca> wrote:
> We have been successfully using nft dnat and IPVS in DR mode on 4.9, 4.14
> kernels, but since upgrading to 4.19, such rules now appear to miss the
> IPVS input hook and instead appear to hit localhost (and "tcpdump -ni lo"
> shows the packets) instead of being forwarded to a real server.
> 
> I bisected this to 9971a514ed2697e542f3984a6162eac54bb1da98 ("netfilter:
> nf_nat: add nat type hooks to nat core").
> 
> It should be pretty easy to see this with a minimal setup:
> 
> /etc/nftables.conf:
> 
> table ip nat {
>         chain prerouting {
>                 type nat hook prerouting priority 0;
> 
> 		ip daddr $ext_ip dnat to $vip
> 	}
> 	chain postrouting {
> 		type nat hook postrouting priority 100;
> 
> 		# In theory this hook no longer needed since this commit,
> 		# but we also need to do some unrelated snatting.
> 	}
> }
> 
> /etc/sysctl.conf:
> 	
> net.ipv4.conf.all.accept_local = 1
> net.ipv4.vs.conntrack = 1
> 
> IPVS DR setup:
> 
> ipvsadm -A -t $vip:80 -s wrr
> ipvsadm -a -t $vip:80 -r $real_ip:80 -g -w 100

I have a hard time figuring out how to expand $ext_ip, $vip and $real_ip,
and where to place those addresses on the nft machine.
