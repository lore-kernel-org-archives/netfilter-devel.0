Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F89C7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E3B20880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:30:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="ZACAFv5J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbfGPSaI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 14:30:08 -0400
Received: from mx1.riseup.net ([198.252.153.129]:54776 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbfGPSaI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 14:30:08 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 86D5A1B9353;
        Tue, 16 Jul 2019 11:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563301807; bh=sgRjBuBT5kTPbje+tb3ByG9HGR+6CSYQn7kPGOH4mJc=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=ZACAFv5JtZVKUtJP/aMdL84eTzkJkfepyZazT9Baq9hCiOks7IOThNqoRMCXVWR/0
         wxdECeZYJl5zqau3ETUAE0Sb7UeyfyuJ88PIM5d0OWqsFIntQSzvRdbxkarkXwskZy
         gt97abLbWBDz27Z+w37OIs0z/5rCH+fmgOyet4Uc=
X-Riseup-User-ID: 03CCA4FCAB827C7EAA2815D6A0221E5C48C601E580F57D6F5E991CA52D58422E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 214482225E3;
        Tue, 16 Jul 2019 11:30:05 -0700 (PDT)
Date:   Tue, 16 Jul 2019 20:30:00 +0200
In-Reply-To: <20190716182739.5b637icvzsdovfh5@breakpoint.cc>
References: <20190716115120.21710-1-pablo@netfilter.org> <20190716164711.GF1628@orbyte.nwl.cc> <63707D89-2251-4B96-BE53-880E12FF0F6A@riseup.net> <20190716180004.dwueos7c4yn75udi@breakpoint.cc> <20190716181253.dtmvpgqiykgx563m@salvia> <20190716182607.wdqq2de7nz2s5gce@salvia> <20190716182739.5b637icvzsdovfh5@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nft] evaluate: bogus error when refering to existing non-base chain
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        charles@ccxtechnologies.com
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <DEFECAF2-2BE0-418F-8E9E-AB29606AC0CF@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 16 de julio de 2019 20:27:39 CEST, Florian Westphal <fw@strlen=2Ede> esc=
ribi=C3=B3:
>Pablo Neira Ayuso <pablo@netfilter=2Eorg> wrote:
>> Having said this, if you want a test for this specific case, I really
>> don't mind :-)
>
>Fair enough, Fernando, if you think you have more important things to
>work on then just ignore this=2E

I am going to send a patch with a test for this case=2E It should be easy =
:-)
