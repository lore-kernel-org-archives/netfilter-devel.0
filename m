Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDFDC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Feb 2022 00:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiBTAek (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 19:34:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiBTAek (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 19:34:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7947E457BD
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 16:34:20 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 79D0260212;
        Sun, 20 Feb 2022 01:33:29 +0100 (CET)
Date:   Sun, 20 Feb 2022 01:34:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/26] scanner: Some fixes, many new scopes
Message-ID: <YhGMiKReUjPCyAai@salvia>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Feb 19, 2022 at 02:27:48PM +0100, Phil Sutter wrote:
> Patch 1 adds a test for 'ct count' statement, patches 2 and 3 fix some
> keywords' scope, bulk scope introduction in the remaining ones.

Could you just push out the fixes in this batch?

My proposal is to release 1.0.2 with accumulated changes in master,
then we follow up with more updates after the release.

I'd also like to push my automerge after the release too.

> Phil Sutter (26):
>   tests: py: Test connlimit statement
>   scanner: Move 'maps' keyword into list cmd scope
>   scanner: Some time units are only used in limit scope
>   scanner: rt: Move seg-left keyword into scope
>   scanner: icmp{,v6}: Move to own scope
>   scanner: igmp: Move to own scope
>   scanner: tcp: Move to own scope
>   scanner: synproxy: Move to own scope
>   scanner: comp: Move to own scope.
>   scanner: udp{,lite}: Move to own scope
>   scanner: dccp, th: Move to own scopes
>   scanner: osf: Move to own scope
>   scanner: ah, esp: Move to own scopes
>   scanner: dst, frag, hbh, mh: Move to own scopes
>   scanner: type: Move to own scope
>   scanner: rt: Extend scope over rt0, rt2 and srh
>   scanner: monitor: Move to own Scope
>   scanner: reset: move to own Scope
>   scanner: import, export: Move to own scopes
>   scanner: reject: Move to own scope
>   scanner: flags: move to own scope
>   scanner: policy: move to own scope
>   scanner: nat: Move to own scope
>   scanner: at: Move to own scope
>   scanner: meta: Move to own scope
>   scanner: dup, fwd, tproxy: Move to own scopes
> 
>  include/parser.h          |  29 +++
>  src/parser_bison.y        | 263 +++++++++++++++------------
>  src/scanner.l             | 361 ++++++++++++++++++++++++--------------
>  tests/py/any/ct.t         |   3 +
>  tests/py/any/ct.t.json    |  19 ++
>  tests/py/any/ct.t.payload |   8 +
>  6 files changed, 436 insertions(+), 247 deletions(-)
> 
> -- 
> 2.34.1
> 
