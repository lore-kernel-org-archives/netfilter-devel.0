Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6738C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 10:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiCVKdc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 06:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiCVKdb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 06:33:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73385C358;
        Tue, 22 Mar 2022 03:32:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nWbo3-0002nC-H0; Tue, 22 Mar 2022 11:32:03 +0100
Date:   Tue, 22 Mar 2022 11:32:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: bug report and future request
Message-ID: <20220322103203.GD24574@breakpoint.cc>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
 <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> Hi Florian
> 
> Look good this config but not work after set user not limit by speed.

Works for me.  Before:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  5.09 GBytes  4.37 Gbits/sec    0 sender
[  5]   0.00-10.00  sec  5.08 GBytes  4.36 Gbits/sec receiver

After:
[  5]   0.00-10.00  sec  62.9 MBytes  52.7 Mbits/sec    0 sender
[  5]   0.00-10.00  sec  59.8 MBytes  50.1 Mbits/sec receiver

> table inet nft-qos-static {
>         set limit_ul {
>                 typeof ip saddr
>                 flags dynamic
>                 elements = { 10.0.0.1 limit rate over 5 mbytes/second burst 6000 kbytes, 10.0.0.254 limit rate over 12 mbytes/second burst 6000 kbytes }
>         }
> 		set limit_dl {
>                 typeof ip saddr
>                 flags dynamic
>                 elements = { 10.0.0.1 limit rate over 5 mbytes/second burst 6000 kbytes, 10.0.0.254 limit rate over 12 mbytes/second burst 6000 kbytes }
>        }
> 
>         chain upload {
> 			type filter hook postrouting priority filter; policy accept;
> 			ip saddr @limit_ul drop
>         }
> 		chain download {
> 			type filter hook prerouting priority filter; policy accept;
> 			ip saddr @limit_dl drop
> 		}

daddr?

> With this config user with ip 10.0.0.1 not limited to 5 mbytes , 

> When back to this config :
> 
> table inet nft-qos-static {
> 	chain upload {
> 		type filter hook postrouting priority filter; policy accept;
> 		ip saddr 10.0.0.1 limit rate over 5 mbytes/second burst 6000 kbytes drop
> 	}
> 
> 	chain download {
> 		type filter hook prerouting priority filter; policy accept;
> 		ip daddr 10.0.0.1 limit rate over 5 mbytes/second burst 6000 kbytes drop
	           ~~~~~
