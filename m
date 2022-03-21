Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF0FC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 23:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiCUXGS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiCUXGL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 19:06:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809E13BA7A2;
        Mon, 21 Mar 2022 15:53:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nWPZ8-0007mP-IB; Mon, 21 Mar 2022 22:27:50 +0100
Date:   Mon, 21 Mar 2022 22:27:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: bug report and future request
Message-ID: <20220321212750.GB24574@breakpoint.cc>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> if have 1k rule
> 
> table inet nft-qos-static {
>         chain upload {
>                 type filter hook postrouting priority filter; policy accept;
>                 ip saddr 10.0.0.9 limit rate over 12 mbytes/second burst 50000 kbytes drop
> .........
> ip saddr 10.0.0.254 limit rate over 12 mbytes/second burst 50000 kbytes drop
>         }

1k rules? Thats insane.  Don't do that.
There is no need for that many rules, its also super slow.

Use a static/immutable ruleset with a named set and then add/remove elements from the set.

table inet nft-qos-static {
	set limit_ul {
		typeof ip saddr
		flags dynamic
		elements = { 10.0.0.9 limit rate over 12 mbytes/second burst 50000 kbytes, 10.0.0.254 limit rate over 12 mbytes/second burst 50000 kbytes }
	}

	chain upload {
		type filter hook postrouting priority filter; policy accept;
		ip saddr @limit_ul drop
	}
}

static ruleset: no need to add/delete a rule:

nft add element inet nft-qos-static limit_ul "{ 10.1.2.4 limit rate over 1 mbytes/second burst 1234 kbytes  }"
nft delete element inet nft-qos-static limit_ul "{ 10.1.2.4 limit rate over 1 mbytes/second burst 1234 kbytes }"

You can add/delete multiple elements in { }, sepearate by ",".

