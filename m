Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5FEC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 08:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848772072D
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 08:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgE2Irp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 04:47:45 -0400
Received: from mail.thelounge.net ([91.118.73.15]:47389 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgE2Iro (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 04:47:44 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49YJ9V35mgzXSh;
        Fri, 29 May 2020 10:47:42 +0200 (CEST)
Subject: Re: [PATCH nf-next] netfilter: introduce support for reject at
 prerouting stage
To:     Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, devel@zevenet.com
References: <20200528171438.GA27622@nevthink>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <81ee4469-c88e-d7c9-0826-9531cff20907@thelounge.net>
Date:   Fri, 29 May 2020 10:47:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528171438.GA27622@nevthink>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 28.05.20 um 19:14 schrieb Laura Garcia Liebana:
> REJECT statement can be only used in INPUT, FORWARD and OUTPUT
> chains. This patch adds support of REJECT, both icmp and tcp
> reset, at PREROUTING stage.
> 
> The need for this patch becomes from the requirement of some
> forwarding devices to reject traffic before the natting and
> routing decisions.

on the other hand you shoot yourself in the foot if you REJECT in
response of "ctstate INVALID" which is a such better place in "-t mangle
PREROUTING" because the reject to out of order re-transmit will kill
your connections

in the worst case you even send ICMP responses back to a forged source
