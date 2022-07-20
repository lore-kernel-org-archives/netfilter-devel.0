Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9976DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 16:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiGTQHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGTQHl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 12:07:41 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E5B3FA28
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 09:07:36 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 68B345876D2BF; Wed, 20 Jul 2022 18:07:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5538160C4DEB6;
        Wed, 20 Jul 2022 18:07:34 +0200 (CEST)
Date:   Wed, 20 Jul 2022 18:07:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Erik Skultety <eskultet@redhat.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
In-Reply-To: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
Message-ID: <784718-9pp7-o170-or1q-rnns2802nqs@vanv.qr>
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2022-07-20 15:06, Erik Skultety wrote:

>The fact that the 'opt' table field reports spaces instead of '--' for
>IPv6 as it would have been the case with IPv4 has a bit of an
>unfortunate side effect that it completely confuses the 'jc' JSON
>formatter tool (which has an iptables formatter module).
>Consider:
>    # ip6tables -L test
>    Chain test (0 references)
>    target     prot opt source   destination
>    ACCEPT     all      a:b:c::  anywhere    MAC01:02:03:04:05:06
>
>Then:
>    # ip6tables -L test | jc --iptables
>    [{"chain":"test",
>      "rules":[
>          {"target":"ACCEPT",
>           "prot":"all",
>           "opt":"a:b:c::",
>           "source":"anywhere",
>           "destination":"MAC01:02:03:04:05:06"
>          }]
>    }]
>
>which as you can see is wrong simply because whitespaces are considered
>as a column delimiter.

Even if you beautify the opt column with a dash, you still have
problems elsewhere. "MAC01" for example is not the destination
at all.

If you or jc is to parse anything, it must only be done with the
iptables -S output form.
