From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [PATCH nft] evaluate: fix "list set" unexpected behaviour
Date: Wed, 1 Jun 2016 12:14:43 +0200
Message-ID: <CAAaDf4vyLjjP74eMsqsH1dwV9JckbG4vVioVmLWW4GTD98mw5g@mail.gmail.com>
References: <20160601085117.6717-1-pablombg@gmail.com>
	<20160601092056.GA2711@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:36270 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbcFAKOo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 06:14:44 -0400
Received: by mail-yw0-f180.google.com with SMTP id x189so13517974ywe.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 03:14:43 -0700 (PDT)
In-Reply-To: <20160601092056.GA2711@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-06-01 11:20 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> I'd suggest:
>
>                     set == NULL && set->flags & (SET_F_EVAL | SET_F_MAP)

Oh, sure. Thank you for pointing that out.
