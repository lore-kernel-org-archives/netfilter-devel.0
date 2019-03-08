Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59E6C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 21:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A631020652
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 21:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=demfloro.ru header.i=@demfloro.ru header.b="FT25lT+v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfCHVfm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 16:35:42 -0500
Received: from mx.demfloro.ru ([185.52.0.75]:57788 "EHLO mx.demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfCHVfm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 16:35:42 -0500
Received: from fire.localdomain (unknown [IPv6:2001:470:28:88::100])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: demfloro)
        by mx.demfloro.ru (Postfix) with ESMTPSA id 44GLQN0Dk4z9MJn;
        Fri,  8 Mar 2019 21:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru; s=052018;
        t=1552080940; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y7nZaSChMz0r8a7eHA7+Mu8+tsWlceflRQ0tJR7jmVo=;
        b=FT25lT+vCwMbCLl0h3yziB2m/pXc591UWumjKUemT+fEMZPOzlJQyWU8y1ffnhpsB0b9gD
        uMaqWMke0anRv4JmYLy2pcOEqovgHbJJqsuYCZLf5xUenpS6kjHfe+wI2Rmh29W0HrVgDE
        JyBDD9wyt7HkAGdXBAGRiulkDw8txjX30hdXf2RiT+u+enzwgICrUuu7MO9xPWDPXDe7OH
        fx+tqF+CMglDqa3o+C/eEzVxEQYFfHgcpDwfOr6dNVB8e8uu0HOKoxWZqBGW2EvCObtxW0
        MDZzOlAne5e+5d1+2AKU9aOmpkToH4kAHEA7gyW2veCrq3n3zYR29vn8F0NLew==
Date:   Sat, 9 Mar 2019 00:35:34 +0300
From:   Dmitrii Tcvetkov <demfloro@demfloro.ru>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference in nft_set_elem_destroy()
Message-ID: <20190309003534.4f114b38@fire.localdomain>
In-Reply-To: <20190308105039.xmf3ho3nixhfnnmh@breakpoint.cc>
References: <20190308131746.5899877a@fire.localdomain>
        <20190308105039.xmf3ho3nixhfnnmh@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru;
        s=arc052018; t=1552080940;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y7nZaSChMz0r8a7eHA7+Mu8+tsWlceflRQ0tJR7jmVo=;
        b=Bc2MSetKEHKw0jEgeV7B8+WpMxWf3uRydAC/p0AEY4hOVLfBq6S+EkZNZBdI/MMLAUvFDB
        CSZmNiVPIdxuUQt2zmsooHTxamP1C9x4ZJRkv5LYsYvsuihds/MClYwxaQJj/0PxcKpO7E
        SThMmVeqvuQM5a2szVgVQnOJaQa4SZKId6ApM/s4+gRbyJttdKW9a2yBGDZvITxz5NkjuA
        yH5W3TCV1DvEdCKEEA5GcZrMwkMPp4+9hsWXdMTaCAvJEeLDyMTYhwurJCxQicqRbanKdl
        nMAxcq++iZQ6QHOPug2zvNnHI7YbjsgGYEzSdvA4gPKMfwNyCFE/jepk1jvYsQ==
ARC-Seal: i=1; s=arc052018; d=demfloro.ru; t=1552080940; a=rsa-sha256;
        cv=none;
        b=iB6lkVt6kVh9J5gDX2e9Xjo1o7nL3/HOgyhhvE1LwsQAslPdtTJtDtBDDiSTodouuQhZkB
        cFQU0Cvy7Feuo/M/72sMp7Ru1YmnT/APs6NTeuPv1KNXx87i2Zx+GxFdPaO4GqPZu8ZjwH
        UvgXqb2lnDUvNOUOmkwy4lFazA0H9XQdntVIU8IMt2oeNnF8blld4VG31CXsX9T0RvCVY/
        ozu82r+0XB8ZA5huPPT6q3Hh8hW/aT87N1cXcFzfbUU2jnlqCADtAcAWinmAknFmAoyEMh
        v3KHJ3ucYBCOCjEiX1u/ckyFmKP7pr5OYd9Gd7kUR96BdLlnwxCV7+P3oGjtiw==
ARC-Authentication-Results: i=1;
        mx.demfloro.ru;
        auth=pass smtp.auth=demfloro smtp.mailfrom=demfloro@demfloro.ru
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 8 Mar 2019 11:50:39 +0100
Florian Westphal <fw@strlen.de> wrote:

> Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:
> > After upgrade to 5.0 on XPS 13 9360 I get NULL pointer dereference
> > in dmesg (attached). Distro is Arch Linux, kernel is built with
> > custom config (attached), but distro kernel[1] reproduces the issue
> > on the laptop as well.
> > 
> > Bisect led me to commit f6ac858589768 (netfilter: nf_tables: unbind
> > set in rule from commit path), bisect log attached. The commit
> > doesn't revert cleanly on top of v5.0, and conflicts aren't trivial
> > for me to resolve.
> 
> Please see
> https://patchwork.ozlabs.org/patch/1053232/
> 
> this probably resolves this crash as well.

Thank you! With the patch nft loads ruleset fine.
