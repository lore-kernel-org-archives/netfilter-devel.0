Return-Path: <SRS0=/QgY=EH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2741C388F7
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 01:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7918521534
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 01:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604192549;
	bh=nnEK121j3N48OGyZc6vjFt54IjlfuzDKV3jXkTrdzDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=kDa5Jr7lqEOZorEmurzudrVJONbA5m6J+deSwtkAH6T5weqM5mk8WPslpjGVV6lvS
	 wBaBIb1kIHTHQcOkceIRuofqzzn6NTR5cYuVcYHHKqv7O584ENuxCGbygoW5njW1an
	 wPLDkzUasw9yTQgqqNZEf14xxXDWWRXAQ95ufxBk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgKABC3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Oct 2020 21:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKABC3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Oct 2020 21:02:29 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4E420888;
        Sun,  1 Nov 2020 01:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604192548;
        bh=nnEK121j3N48OGyZc6vjFt54IjlfuzDKV3jXkTrdzDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WFaISzsQAfvblJHYIu4+i4JOhmCFm1XI0ZtZlgBMRxPZLCmHTP4Naa6CJeseQuufY
         dwEOLKA49RX+cr3+QoAZA2oYvIMchL7XrJP9MRZ4aR1GA1s0sSEguUtC08ijIqk7/Z
         BqCprdp4nXk2457rFAIovfJsEG0rDau6WnnFHQg4=
Date:   Sat, 31 Oct 2020 18:02:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] Netfilter fixes for net
Message-ID: <20201031180227.3a219bfd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031181437.12472-1-pablo@netfilter.org>
References: <20201031181437.12472-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 31 Oct 2020 19:14:32 +0100 Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Incorrect netlink report logic in flowtable and genID.
> 
> 2) Add a selftest to check that wireguard passes the right sk
>    to ip_route_me_harder, from Jason A. Donenfeld.
> 
> 3) Pass the actual sk to ip_route_me_harder(), also from Jason.
> 
> 4) Missing expression validation of updates via nft --check.
> 
> 5) Update byte and packet counters regardless of whether they
>    match, from Stefano Brivio.

Pulled, thanks Pablo!
