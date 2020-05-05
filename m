Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B47C47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 13:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0550A20746
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 13:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="PI/wadli"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgEENWU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 09:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbgEENWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 09:22:20 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D38FC061A0F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 06:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588684937;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=n9TKkUDm80CvCjr3SEAsSCm4v/YWgxF06ZI8/aYRHrE=;
        b=PI/wadliAczTcAKgqdQMPmXrcUeqrTM2S1b7HY5gdGfvdlJ7CeH4YCOkGfbXUuYmtK
        sZn/I9fCfZTGrnP8/SYymu6LRUA/ChOGTShgQBfR+P8XofwKOT7kBEquWpDHYokpldDw
        zWs4MtZSsu81ORyv940I0/8fbYx49sTY5c7SfeedxHcxlOUm0psXBrhFZFhv5Fe+K6VF
        OP9/ygIQP9HplTiAVyYw0QtQVbtDulPd0QldG/e+6PdV0IegEVfI79uijYnFoR7Nn++2
        eLFrSHzXVOxkTmSWfykjdaqnAcE0NvO9GYgUXDUly6ujsTzVJhNimzUrqcrPLnAo1/ug
        FZUg==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4vmpMrAs8OZgAsWbSDyXetO/IBA+8ke6XddTw=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 AUTH)
        with ESMTPSA id g05fffw45DMHxDV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 5 May 2020 15:22:17 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 9113B154262;
        Tue,  5 May 2020 15:22:16 +0200 (CEST)
Received: from 4+8OFFEKxBd9OEurqTJGR+eZaxX/sfwA1zTJhFSjvM80eM5BOrYbCw==
 (ciXw0nLglReZl7mBePRtkK836r9u/Yy2)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Tue, 05 May 2020 15:22:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 15:22:07 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] rule: fix out of memory write if num_stmts is too low
In-Reply-To: <20200505121756.GA8781@salvia>
References: <20200504204858.15009-1-michael-dev@fami-braun.de>
 <20200505121756.GA8781@salvia>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <284c0e0cba6ddfa50872e7250d8b35c7@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Am 05.05.2020 14:17, schrieb Pablo Neira Ayuso:
> On Mon, May 04, 2020 at 10:48:58PM +0200, Michael Braun wrote:
>> Running bridge/vlan.t with ASAN, results in the following error.
>> This patch fixes this
>> 
>> flush table bridge test-bridge
>> add rule bridge test-bridge input vlan id 1 ip saddr 10.0.0.1
> 
> Thanks for your patch. Probably this patch instead?

That fixes the testcase for me as well.

Though there are some more places that call list_add / list_add_tail on 
rule->stmts, so I'm unsure if this patch catches all similar cases, e.g:

src/evaluate.c: list_add(&nstmt->list, &ctx->rule->stmts);
src/evaluate.c: list_add(&nstmt->list, &ctx->rule->stmts);
src/netlink_delinearize.c:      list_add_tail(&stmt->list, 
&ctx->rule->stmts);
src/netlink_delinearize.c:              list_add_tail(&stmt->list, 
&ctx->rule->stmts);
src/netlink_delinearize.c:              list_add_tail(&ctx->stmt->list, 
&ctx->rule->stmts);
src/parser_json.c:              list_add_tail(&stmt->list, 
&rule->stmts);
src/parser_json.c:              list_add_tail(&stmt->list, 
&rule->stmts);
src/xt.c:       list_add_tail(&stmt->list, &ctx->rule->stmts);
src/xt.c:       list_add_tail(&stmt->list, &ctx->rule->stmts);

Regards,
M. Braun
