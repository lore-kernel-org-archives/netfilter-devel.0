Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA519C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AEB065134
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhCHJrF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 04:47:05 -0500
Received: from rs2.larkmoor.net ([162.211.66.16]:44960 "EHLO rs2.larkmoor.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhCHJqg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 04:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=larkmoor.net; s=larkmoor20140928;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=IrI5qTQL3X4CKnnYfariBcxCj/PxLqubRe2zp6dDK4o=;
        b=dhia3rY4zqaXEsjz/gGxgaA7bLAzs3Uao+raBiB0PzPqYOJthTqVTMTw/pnNIsddcZwgk2wl3T7CQfnPpFLle8fHeTBubCXz9qwSSUanRktaiJfSqO1/XyUpfZC1AoKYfmVzNK21P3GdT32U7cG9rVMHHGXu1fHKtolX5fnegp0=;
Received: from [10.0.0.31]
        by gw.larkmoor.net with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <fmyhr@fhmtech.com>)
        id 1lJCTD-0000BD-0a; Mon, 08 Mar 2021 04:46:35 -0500
Subject: Re: [RFC PATCH] doc: use symbolic names for chain priorities
To:     Simon Ruderich <simon@ruderich.org>
Cc:     netfilter-devel@vger.kernel.org
References: <b1320180e5617ae9910848b7fc17daf9c3edca04.1615109258.git.simon@ruderich.org>
 <0a7f088c-f813-0425-8bec-d693d95a97a0@fhmtech.com>
 <YEW34W5oCspFnSt+@ruderich.org>
From:   Frank Myhr <fmyhr@fhmtech.com>
Message-ID: <ced3e003-45c4-a39a-62a6-0e2f4e2abc47@fhmtech.com>
Date:   Mon, 8 Mar 2021 04:46:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEW34W5oCspFnSt+@ruderich.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021/03/08 00:36, Simon Ruderich wrote:
> On Sun, Mar 07, 2021 at 10:02:52AM -0500, Frank Myhr wrote:
>> Hi Simon,
>>
>> Priority is only relevant _within a given hook_. So comparing priorities of
>> base chains hooked to prerouting and postrouting (as in your example above)
>> does not make sense. Please see:
>>
>> https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains#Base_chain_priority
>> https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks
> 
> Hello Frank,
> 
> thank you. This helped, somewhat.

I'm glad. If you have suggestions for how to make the wiki clearer I'd 
love to hear them. (Probably better to use the regular netfilter list, 
where developers are also present, rather than this netfilter-devel list.)


> The image https://people.netfilter.org/pablo/nf-hooks.png in the
> wiki lists netfilter hooks. Do these correspond to nftables
> hooks? So all prerouting hooks (type nat, type filter, etc.) for
> IP are applied to the green "Prerouting Hook" in the IP part of
> the diagram? And the "Netfilter Internal Priority" applies only
> within such a hook to order them?

Yes, nftables & the rest of netfilter (defrag, conntrack, nat, etc) use 
the same hooks. And relative priority within a hook determines the order 
in which the various processes _at that hook_ happen.


> Why is there a global order of netfilter hooks (via the priority,
> -450 to INT_MAX)? ... is it designed that way to "hint" at the packet flow
> (lower numbers first, independent of the actual hooks)?

I think such hinting is the idea, yes.


 > Wouldn't it also work to set for example
 > NF_IP_PRI_NAT_SRC to -400 because it only applies in postrouting
 > anyway?

Just to be clear, NF_IP_PRI_NAT_SRC is a named constant in the netfilter 
codebase. So not something you can change unless you edit the source 
code and compile it yourself. But you could create a base chain using 
"hook postrouting priority -400" and add rules with "snat to" statements 
to said chain, and this will happily snat your packets as you specify. 
Whether this overall config does what you want, depends on what else is 
hooked to postrouting, and their relative priorities. For example:

* Conntrack is almost always used. Using -400 for snat doesn't change 
its relative order to NF_IP_PRI_CONNTRACK_HELPER and 
NF_IP_PRI_CONNTRACK_CONFIRM (both of which are also at postrouting hook).

* If you are also mangling packets (in ways other than snat) at 
postrouting, NF_IP_PRI_MANGLE = -150. By moving your snat from usual 100 
to -400, you've re-ordered the mangle and snat processes -- unless you 
also use a nonstandard priority for your base chain that does mangling.

* There's also NF_IP_PRI_SECURITY, maybe important if you're using SELINUX.

General point: you should have a good reason for using priorities other 
than the traditional ones.


> For type nat and hook prerouting priorities like -100, 0 and 500
> would all work because we have no other hooks in that range. > However, using priority -250 would be problematic because it puts
> it before the netfilter connection tracking?

It's pretty common to filter in prerouting. And maybe to set secmark as 
well... So using priority 0 or 500 for dnat could cause trouble. Using 
-250 for dnat is problematic for the reason you state. And if you're 
using SELINUX you also have to consider NF_IP_PRI_SELINUX_FIRST at -225.


> What exactly is the difference between the chain types? Is it
> relevant for netfilter or is it only for nftables so it knows
> which rules to expect in the given chain?

I think you mean?:
https://wiki.nftables.org/wiki-nftables/index.php/Nftables_families


~
Disclosure: I'm not an nftables or netfilter developer, just a user with 
an interest in clear documentation.

Best Wishes,
Frank
