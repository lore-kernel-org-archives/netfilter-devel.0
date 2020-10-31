Return-Path: <SRS0=mmf4=EG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4515BC388F7
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 10:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D484520719
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 10:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgJaKNx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Oct 2020 06:13:53 -0400
Received: from correo.us.es ([193.147.175.20]:34094 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgJaKNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Oct 2020 06:13:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32988E4B89
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 11:13:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 206F5DA73F
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 11:13:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15F83DA789; Sat, 31 Oct 2020 11:13:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D534DDA73F;
        Sat, 31 Oct 2020 11:13:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 11:13:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BA7EB42EF42D;
        Sat, 31 Oct 2020 11:13:48 +0100 (CET)
Date:   Sat, 31 Oct 2020 11:13:48 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] netfilter: ipset: Update byte and packet counters
 regardless of whether they match
Message-ID: <20201031101348.GA1459@salvia>
References: <20201029153949.6567-1-kadlec@netfilter.org>
 <20201029153949.6567-2-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201029153949.6567-2-kadlec@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Thu, Oct 29, 2020 at 04:39:46PM +0100, Jozsef Kadlecsik wrote:
> From: Stefano Brivio <sbrivio@redhat.com>
> 
> In ip_set_match_extensions(), for sets with counters, we take care of
> updating counters themselves by calling ip_set_update_counter(), and of
> checking if the given comparison and values match, by calling
> ip_set_match_counter() if needed.
> 
> However, if a given comparison on counters doesn't match the configured
> values, that doesn't mean the set entry itself isn't matching.
> 
> This fix restores the behaviour we had before commit 4750005a85f7
> ("netfilter: ipset: Fix "don't update counters" mode when counters used
> at the matching"), without reintroducing the issue fixed there: back
> then, mtype_data_match() first updated counters in any case, and then
> took care of matching on counters.
> 
> Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
> ip_set_update_counter() will anyway skip counter updates if desired.
> 
> The issue observed is illustrated by this reproducer:
> 
>   ipset create c hash:ip counters
>   ipset add c 192.0.2.1
>   iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> 
> if we now send packets from 192.0.2.1, bytes and packets counters
> for the entry as shown by 'ipset list' are always zero, and, no
> matter how many bytes we send, the rule will never match, because
> counters themselves are not updated.

If possible, let me split this batch.

I'll apply this fix (1/4) to nf.git instead, so this shows up in
5.10 swiftly.

My understanding is that 2/4, 3/4 and 4/4 have no dependency on this
one, so I'll apply these three remaining patches in the batch to
nf-next.git

Let me know,
Thanks.
