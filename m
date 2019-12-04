Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BD6C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 22:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F88120661
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 22:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDWcS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 17:32:18 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:59398 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfLDWcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 17:32:18 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icdBv-0004je-4l; Wed, 04 Dec 2019 23:32:15 +0100
Date:   Wed, 4 Dec 2019 23:32:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Message-ID: <20191204223215.GX14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Wed, Dec 04, 2019 at 06:31:02PM +0100, Arturo Borrero Gonzalez wrote:
> On 12/4/19 4:56 PM, Phil Sutter wrote:
> > OK, static load-balancing between two services - no big deal. :)
> > 
> > What happens if config changes? I.e., if one of the endpoints goes down
> > or a third one is added? (That's the thing we're discussing right now,
> > aren't we?)
> 
> if the non-anon map for random numgen was allowed, then only elements would need
> to be adjusted:
> 
> dnat numgen random mod 100 map { 0-49 : 1.1.1.1, 50-99 : 2.2.2.2 }
> 
> You could always use mod 100 (or 10000 if you want) and just play with the map
> probabilities by updating map elements. This is a valid use case I think.
> The mod number can just be the max number of allowed endpoints per service in
> kubernetes.
> 
> @Phil,
> 
> I'm not sure if the typeof() thingy will work in this case, since the integer
> length would depend on the mod value used.
> What about introducing something like an explicit u128 integer datatype. Perhaps
> it's useful for other use cases too...

Out of curiosity I implemented the bits to support typeof keyword in
parser and scanner. It's a bit clumsy, but it works. I can do:

| nft add map t m2 '{ type typeof numgen random mod 2 : verdict; }'

(The 'random mod 2' part is ignored, but needed as otherwise it's not a
primary_expr. :D)

The output is:

| table ip t {
| 	map m2 {
| 		type integer : verdict
| 	}
| }

So integer size information is lost, this won't work when fed back.
There are two options to solve this:

A) Push expression info into kernel so we can correctly deserialize the
   original input.

B) As you suggested, have something like 'int32' or maybe better 'int(32)'.

I consider (B) to be way less ugly. And if we went that route, we could
actually use the 'int32'/'int(32)' thing in the first place. All users
have to know is how large is 'numgen' data type. Or we're even smart
here, taking into account that such a map may be used with different
inputs and mask input to fit map key size. IIRC, we may even have had
this discussion in an inconveniently cold room in Malaga once. :)

> @Serguei,
> 
> kubernetes implements a complex chain of mechanisms to deal with traffic. What
> happens if endpoints for a given svc have different ports? I don't know if
> that's supported or not, but then this approach wouldn't work either: you can't
> use dnat numgen randmo { 0-49 : <ip>:<port> }.
> 
> Also, we have the masquerade/drop thing going on too, which needs to be deal
> with and that currently is done by yet another chain jump + packet mark.
> 
> I'm not sure in which state of the development you are, but this is my
> suggestion: Try to don't over-optimize in the first iteration. Just get a
> working nft ruleset with the few optimization that make sense and are easy to
> use (and understand). For iteration #2 we can do better optimizations, including
> patching missing features we may have in nftables.
> I really want a ruleset with very little rules, but we are still comparing with
> the iptables ruleset. I suggest we leave the hard optimization for a later point
> when we are comparing nft vs nft rulesets.

+1 for optimize not (yet). At least there's a certain chance that we're
spending much effort into optimizing a path which isn't even the
bottleneck later.

Cheers, Phil
