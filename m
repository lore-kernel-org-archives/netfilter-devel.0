Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E81C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 18:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ACCC20645
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 18:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pera7xoM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbfFXSZR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 14:25:17 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38028 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfFXSZR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 14:25:17 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so4298657qtl.5
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2019 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MSKud/FwQZDwM6P71UGex+uDKU8c3KRRw26M7ns98Us=;
        b=Pera7xoM//QykYppbA+pNARP01PXm3pNlJMkXYn43dFJOUg+b/cp6eqkolX8Vu01jh
         DUIjd+UnTF6gqkVEJ01dxyGegh5iCciF9TQ0WtGYV/6r0yeqgxWdverA6FyId6dH5QbF
         ZPgeQ/C+vnnCFvO/rmv8fXwRza+eWtwqtuAxsDHuGpCq3IYd2EAA3MPrPwI/PwvBObXM
         6u8LdQETxhxvL1Qt7psFXLstBLY9ZCb8cGyh25k7KF7iK6cS4dSzgOx/4GPnL9cm6V2Q
         qc0maxO43rno6RK9q6jEZOocXT96FEJnkZr8nuFtelUj2J+PVbcJ5Ie9Zev/2L02AM/t
         VyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MSKud/FwQZDwM6P71UGex+uDKU8c3KRRw26M7ns98Us=;
        b=AajtWrhwE8/aYyrbE9fNr6csGV41oqytGYkXVDgKUsHWVw/S6EU7urtg2Z4XzXRi5F
         EQRKNJmPargOTxF2+Rc+0A8/blA0nLjhnB6p/0rV89YRKGkW1NMuGWkkZOnLD+azENSE
         TSu62KNYhvAFQRFcO55VSrDJ8hgpXhlDg4x75A/VD7NJ9+pyzowoetqv/BOPQWbZritk
         c9LRnNi9+fzFgSTiqP0QW5GFvD6vQkdLipAF+FuIH1aEPgMebE7L/x5a6PHmJTAy/q7t
         E5uKUyJcDgBqgyLy6mlEf8hSKmxSTaRsoCtTfgbqKLb7KLQCD0Hsw8uYtBnQWLi1IV+7
         2kxQ==
X-Gm-Message-State: APjAAAWHb6GnopHjaCoalsSh8gP3ALHNjF3gaNAlXiklSmTiZLxvCm3n
        14UgcvsQNKw8So02IED+jg==
X-Google-Smtp-Source: APXvYqwquxZVOL7j8pVPV+h0EpxcgjjkDCJksjim38WbaiRveYdEjxONqobdIGfrV8MpHuzQhtQOEQ==
X-Received: by 2002:aed:3b02:: with SMTP id p2mr43309383qte.62.1561400716260;
        Mon, 24 Jun 2019 11:25:16 -0700 (PDT)
Received: from ubuntu ([104.238.32.30])
        by smtp.gmail.com with ESMTPSA id w16sm8380622qtc.41.2019.06.24.11.25.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Jun 2019 11:25:15 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:25:07 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl v2] src: libnftnl: add support for matching IPv4
 options
Message-ID: <20190624182507.GA4993@ubuntu>
References: <20190620115429.3678-1-ssuryaextr@gmail.com>
 <20190621160653.ektgcsz2oo47etsh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621160653.ektgcsz2oo47etsh@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 06:06:53PM +0200, Pablo Neira Ayuso wrote:
> 
> Would you mind to install libnftnl with this patch on top and run:
> 
> nftables/tests/py/# python nft-tests.py
> 
> to check if this breaks testcases, if so a patch to update tests in
> nftables would be great too.

Updated the testcases payload files. Will spin another nftables patch
version.

Thanks,
Stephen.
