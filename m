Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D477AC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 15:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5998603E9
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Aug 2021 15:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbhHEPxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:53:11 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21578 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhHEPxL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 11:53:11 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1628178766; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=S6Th5NnuaF/BXu9Ql+jqC5m5TSsQH7Meuddg5rVzWLeJU/ZROj+Pi9MUhBE/wnyLQnmNabKq41Fp2lQ8gyZxAI4YTvPphlYkFzfkHVCa08GcdRhi5SNQoIhsYlwEwaJddOdQcrMzZ3LDEiurhza6YWXmb9n8w7cPtjHSQEPaIwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1628178766; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+Il9M70e3NVz0vY8H1OjZVq7hSv1G20x/xCFvNG4drs=; 
        b=daNwtW3zrM4aCL2tNIw1ri+3QWXrG2bhWa8TnpSqAKTkIrixoW81EDNv/N4pQb/85srYWk2H8ZBGuUc9ZlOdxsUNdimg7LFs7yB7YpAfsKlUY9uts6PkT7Q3N5/Wqfq5iaT4izSXDPoHtqh/YnI+TD/D3pO+Z+3Nde7Wqu5mYyM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1628178766;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:To;
        bh=+Il9M70e3NVz0vY8H1OjZVq7hSv1G20x/xCFvNG4drs=;
        b=dKKXTqPAeGB73rTcM7YmL5J/zRX0yZdc/YYuxAc97GqQpysspyz6QfGxBFE/cdeC
        JEriOmM4kANl5GxltjlJOuG5zTJ8sJdaQxJOvBPDFRhQfsg92gJamgIJqbBfZkb/3dn
        JaJuzFnbK3HbXqU4fuuXk59fPLD4Vw7jqz95hzxo=
Received: from smtpclient.apple (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1628178755824214.3116990364233; Thu, 5 Aug 2021 08:52:35 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v4 1/2] netfilter: add new sysctl toggle for lightweight
 tunnel netfilter hooks
From:   Ryoga Saito <contact@proelbtn.com>
In-Reply-To: <20210805115252.GA13060@salvia>
Date:   Fri, 6 Aug 2021 00:52:30 +0900
Cc:     netfilter-devel@vger.kernel.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <179E1D33-F193-4A91-8332-1AB76F765DAF@proelbtn.com>
References: <20210802113433.6099-1-contact@proelbtn.com>
 <20210802113433.6099-2-contact@proelbtn.com> <20210805115252.GA13060@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, Pablo

Thanks for your review. I=E2=80=99ll fix them in v5.

Ryoga Saito

