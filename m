Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA574C34022
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 19:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC7D20725
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 19:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgBQTZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 14:25:51 -0500
Received: from correo.us.es ([193.147.175.20]:44170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbgBQTZv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 14:25:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2AF9C12C1E4
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 20:25:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 190F8DA736
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 20:25:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0EAFBDA7B2; Mon, 17 Feb 2020 20:25:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2017DDA3A0;
        Mon, 17 Feb 2020 20:25:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Feb 2020 20:25:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F2CD442EF4E0;
        Mon, 17 Feb 2020 20:25:47 +0100 (CET)
Date:   Mon, 17 Feb 2020 20:25:46 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/4] netfilter: conntrack: allow insertion of clashing
 entries
Message-ID: <20200217192546.pa26vfni4kmhlpng@salvia>
References: <20200203163707.27254-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203163707.27254-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 03, 2020 at 05:37:03PM +0100, Florian Westphal wrote:
> This series allows conntrack to insert a duplicate conntrack entry
> if the reply direction doesn't result in a clash with a different
> original connection.

Applied, thanks for your patience.

I introduced the late clash resolution approach to deal with nfqueue,
now this is extended to cover more cases, let's give it a try.

>Alternatives considered were:
>1.  Confirm ct entries at allocation time, not in postrouting.
> a. will cause uneccesarry work when the skb that creates the
>    conntrack is dropped by ruleset.
> b. in case nat is applied, ct entry would need to be moved in
>    the table, which requires another spinlock pair to be taken.
> c. breaks the 'unconfirmed entry is private to cpu' assumption:
>    we would need to guard all nfct->ext allocation requests with
>    ct->lock spinlock.
>
>2. Make the unconfirmed list a hash table instead of a pcpu list.
>   Shares drawback c) of the first alternative.

The spinlock would need to be grabbed rarely, right? My mean, most
extension allocations happen before insertion to the unconfirmed list.
Only _ext_add() invocations coming after init_conntrack() might
require this.

Thanks.
