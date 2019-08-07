Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2088C31E40
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 00:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7012F208C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 00:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaloft-com.20150623.gappssmtp.com header.i=@metaloft-com.20150623.gappssmtp.com header.b="F5lF1Buz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfHGA5y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 20:57:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36471 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfHGA5x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 20:57:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so42498004pgm.3
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Aug 2019 17:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaloft-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CTH1W6riE42Abyp8O6SbecF3dybUpMO2woK3eu8b3v4=;
        b=F5lF1BuzFy0xFp0w+jcUNoQJjuJmidlS6J3ZGedLq6xqkS0YxwiGpN3qVqc3HUaJKh
         XZSJRdOxvwwJ3MEnTcApwGwWDG5LZV1VjhsedeEdNwYnlx6eEPcCBlw+Jgae0OV9WRQp
         4KzHuJb4cb8uYxysNCgGT/riXraUXaNbMc3aA80EJ8YDb9mkLT+e/DwgCJSTmLpdp4JW
         r4tQfGEYkwJVTLJdEWi171hTY0/zeIMf7tsTJvE8aKTBm440dpfU0P41MkLnfv1CHhP7
         VieHwME1EkY2HL7TNwPVuNzVQX3SoyhdEEXEwY0OQVi0UvoIa6ESQAkLpfQnWuHkDznA
         SBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CTH1W6riE42Abyp8O6SbecF3dybUpMO2woK3eu8b3v4=;
        b=cF/w6oOSiAT3R3D7Qol1MAiUQxcw4Y7wWtW6Zh7E1UiQVxNT3w5GFS6CapTFbETuTw
         +ue8PTpT3lBaW8axDwGfNRyNr9ewZDb78eyjqFRRKO1ku02VbzdJi7Xt/04xMm7RaZ1X
         0+Z+bLVb+6c0uWlYWqzWxrZIxJzL+qsRRvjjsS1hvE68s8i6B/LDJKU9d1IEpl7evfbe
         Gq4Ke2w1eX9cVuBkThu/2UAEnyTporv6LBfKa+enrTvXy7pDfqkvN+AWrMccoZeMLIZK
         EUIlFv3ddrSuG2Xrv9gG7OrPp8ef1QaMPmmP1Ji8dKtTAWLkwpsCRJ0iWWwANDwvsHgs
         BHiw==
X-Gm-Message-State: APjAAAW0p4XATzIPdX16prZ1IVH309oeriwDf2aVa0q0pDEqAwj+rc1r
        vwK2rPSnXSpFEXsAZuXc2nNcbWyfgC8=
X-Google-Smtp-Source: APXvYqyI5Vdiw2v+HZ6qZSTr0xJHbkwF5kDc9vm2nUevFa0wMI6gNHb7kaKNXCg3xOdlxAp1IiL5sA==
X-Received: by 2002:a63:5b23:: with SMTP id p35mr5302434pgb.366.1565139472383;
        Tue, 06 Aug 2019 17:57:52 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:6881::3c8? (2600-6c4e-2200-6881-0000-0000-0000-03c8.dhcp6.chtrptr.net. [2600:6c4e:2200:6881::3c8])
        by smtp.gmail.com with ESMTPSA id s43sm26761738pjb.10.2019.08.06.17.57.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 17:57:51 -0700 (PDT)
Subject: Re: [PATCH net] netfilter: Use consistent ct id hash calculation
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
 <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
From:   Dirk Morris <dmorris@metaloft.com>
Message-ID: <33301d87-0bc2-b332-d48c-6aa6ef8268e8@metaloft.com>
Date:   Tue, 6 Aug 2019 17:57:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807003416.v2q3qpwen6cwgzqu@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/6/19 5:34 PM, Florian Westphal wrote:

> 
> This is unexpected, as the id function is only supposed to be called
> once the conntrack has been confirmed, at which point all NAT side
> effects are supposed to be done.
> 
> In which case(s) does that assumption not hold?
> 

Yeah, I figured that might be the reasoning.

In my case either from a queue event or log event in userspace.
Which is always pre-confirmation for the first packet of any connection until late.

psuedo-code:

nft add table inet foo
nft add chain inet foo prerouting "{ type filter hook prerouting priority -123 ; }"
nft add chain inet foo postrouting "{ type filter hook postrouting priority -123 ; }"
nft add rule inet foo prerouting queue num 1234
nft add rule inet foo postrouting queue num 1234

or

nft add table inet foo
nft add chain inet foo prerouting "{ type filter hook prerouting priority -123 ; }"
nft add chain inet foo postrouting "{ type filter hook postrouting priority -123 ; }"
nft add rule inet foo prerouting log prefix "prerouting" group 0
nft add rule inet foo postrouting log prefix "postrouting" group 0

and then in some userspace daemon something like:

ct_len = nfq_get_ct_info(nfad, &ct_data);
nfct_payload_parse((void *)ct_data,ct_len,l3num,ct)
id = nfct_get_attr_u32(ct,ATTR_ID);

or

*data = nfnl_get_pointer_to_data(nfa->nfa,NFULA_CT,char)
nfct_payload_parse((void *)data,ct_len,l3num,ct )
id = nfct_get_attr_u32(ct,ATTR_ID);

Its just a convenience to have it not change if possible (assuming the proposal
maintains the same level of uniqueness - not 100% sure on that).

Listening to the conntrack events this does not happen, as you get the NEW event
only after the ct is confirmed, but unfortunately you get the packet from queue
and the log messages well before that.
