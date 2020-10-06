Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF08C4363D
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 13:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627DB20782
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 13:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="BToKl7OS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgJFNpd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 09:45:33 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40070 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFNpc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 09:45:32 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4C5Jd71Wx5zFmfB;
        Tue,  6 Oct 2020 06:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1601991931; bh=x8JKkTy+Ukd7TWeWAl4MdqYr4aN/QKXQdQAGu/82Vs4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BToKl7OSSC9fWvUgKpL0i5HxTfk+lYBbDWMf5UrjiYhSwulIMiO04v5ozYtm47UIf
         exT1MmVhp778F+mGxWN0flyTMjKb9kQb74GS7f8nPy4w0SRjnPTV4RHDM7mXr4ykms
         2hjGDgIcxECyURnDyBk0hlBUAQlh+YdCdZiQ6xdU=
X-Riseup-User-ID: 907B580780E49C65E2ADDA6884E7C217377A1B7ECFEAC0B00B8734351CFE98A5
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4C5Jcm2T4Xz8wWt;
        Tue,  6 Oct 2020 06:45:12 -0700 (PDT)
Subject: Re: [PATCH 1/1] Solves Bug 1462 - `nft -j list set` does not show
 counters
To:     Gopal Yadav <gopunop@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
References: <20201003125841.5138-1-gopunop@gmail.com>
 <2c604efb-39a3-41de-f0a6-a44c703a20df@riseup.net>
 <CAAUOv8iAPJm1mTPjFamEVQAOh1y-ahExN_+4Pk2rPkELwyxBEw@mail.gmail.com>
From:   "Jose M. Guisado" <guigom@riseup.net>
Message-ID: <b9e9fb11-1bb4-065b-4e64-f10665820606@riseup.net>
Date:   Tue, 6 Oct 2020 15:45:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAAUOv8iAPJm1mTPjFamEVQAOh1y-ahExN_+4Pk2rPkELwyxBEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6/10/20 14:42, Gopal Yadav wrote:
> Should I always run ASAN before submitting patches as a regular practice?

I usually check for leaks when submitting patches, using either ASAN or 
Valgrind.

> json_object_update_missing_new() was raising a warning so I have used
> json_object_update_missing() in the updated patch.

I've been unable to reproduce said warning when using 
json_object_update_missing_new.

You need to use the *_new function, because it will call json_decref on 
tmp for you. If not the reference to tmp is leaked.

You should version your patches, have a look at the patch submission 
guidelines in the nftables wiki [1]

[1] 
https://wiki.nftables.org/wiki-nftables/index.php/Portal:DeveloperDocs/Patch_submission_guidelines
