Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2D0C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B30C2074B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhA0NmD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 08:42:03 -0500
Received: from mail.thelounge.net ([91.118.73.15]:57347 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbhA0Nk4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 08:40:56 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DQl8q6PR5zXRQ;
        Wed, 27 Jan 2021 14:40:11 +0100 (CET)
Subject: Re: https://bugzilla.kernel.org/show_bug.cgi?id=207773
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <9ab32341-ca2f-22e2-0cb0-7ab55198ab80@thelounge.net>
 <alpine.DEB.2.23.453.2101271435390.11052@blackhole.kfki.hu>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <80fb46c6-6061-6a5b-b64e-a661600a4c9f@thelounge.net>
Date:   Wed, 27 Jan 2021 14:40:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.23.453.2101271435390.11052@blackhole.kfki.hu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 27.01.21 um 14:38 schrieb Jozsef Kadlecsik:
> Hi,
> 
> On Wed, 27 Jan 2021, Reindl Harald wrote:
> 
>> for the sake of god may someone look at this?
>> https://bugzilla.kernel.org/show_bug.cgi?id=207773
> 
> Could you send your iptables rules and at least the set definitions
> without the set contents? I need to reproduce the issue.

is offlist OK?
that's the companies "datacenter firewall"
