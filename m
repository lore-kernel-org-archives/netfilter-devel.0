Return-Path: <SRS0=19L1=VX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0918C7618B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8B22086D
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfGZHgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:36:51 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:20180 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:51 -0400
Received: from [IPv6:2a01:e34:ec0c:ae81:259a:5cf4:cd92:2659] (unknown [IPv6:2a01:e34:ec0c:ae80:259a:5cf4:cd92:2659])
        by smtp3-g21.free.fr (Postfix) with ESMTPS id 162F113F854;
        Fri, 26 Jul 2019 09:36:44 +0200 (CEST)
Subject: Re: [PATCH iptables]: restore legacy behaviour of iptables-restore
 when rules start with -4/-6
To:     Phil Sutter <phil@nwl.cc>
References: <f056f1bb-2a73-5042-740c-f2a16958deb0@free.fr>
 <20190725104035.GP22661@orbyte.nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
From:   Adel Belhouane <bugs.a.b@free.fr>
Message-ID: <fa2088a4-f147-4756-11a5-7105bfaabfff@free.fr>
Date:   Fri, 26 Jul 2019 09:36:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725104035.GP22661@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Phil,

Le 25/07/2019 à 12:40, Phil Sutter a écrit :
> 
> Would you mind creating a testcase in iptables/tests/shell? I guess
> testcases/ipt-restore is suitable, please have a look at
> 0003-restore-ordering_0 in that directory for an illustration of how we
> usually check results of *-restore calls.
> 

I moved the examples to two testcase files taking example on what you
suggested and resent a patch.

regards,
Adel
