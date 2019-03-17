Return-Path: <SRS0=LKNA=RU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C85EC43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 17:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6069F2082F
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 17:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Aawe8I73"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfCQRK4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:10:56 -0400
Received: from mx1.riseup.net ([198.252.153.129]:56320 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfCQRKz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 13:10:55 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 973AD1A1627;
        Sun, 17 Mar 2019 10:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552842655; bh=XxKmQwVdgMKSAjX9pDnG1wswNVodWPXkIID/56jhVOc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Aawe8I732T+HDDFzvfikzFO9Ak/g7z4TdtQ82MTHjh3mp+O6Gb7jj0QJZygGN1No7
         HN7lSoIPywM8uVP1g0uZD4v+wkSd5R5i7zVj58NKhPrC/VDLL9JDbMjyJ2fwJgXVmS
         JBj3hFONiuKXHBrAdXKaj4MHQq6pkh+njcJnl+Y4=
X-Riseup-User-ID: 020A19009AE3DC2A1AE4D76630AFE6CE92DD5F624326CAEFD1719DE716E6A0F9
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id AB94D222CC1;
        Sun, 17 Mar 2019 10:10:52 -0700 (PDT)
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <1eb195ad-028e-5760-c4c8-1062441231c9@riseup.net>
 <20190316090559.yky2tctzfzhyjs6g@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <218d665e-0662-6d5e-cc1e-b2c4aefd5833@riseup.net>
Date:   Sun, 17 Mar 2019 18:10:59 +0100
MIME-Version: 1.0
In-Reply-To: <20190316090559.yky2tctzfzhyjs6g@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 3/16/19 10:05 AM, Pablo Neira Ayuso wrote:
> On Fri, Mar 15, 2019 at 09:21:56PM +0100, Fernando Fernandez Mancera wrote:
> [...]
>> We can hide the flags for the json support if needed by counting the
>> numbers of colons.
> 
> No need to parse colons, we can map:
> 
>         osf genre
>         osf version
> 
> to json, I think.
> 

Yes, you are right. Then, if everyone agree I can start to work on these
changes. Thanks! :-)
