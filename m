Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5CC43603
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 17:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948F8206D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 17:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfLPRiB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 12:38:01 -0500
Received: from correo.us.es ([193.147.175.20]:33224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfLPRiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 12:38:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DC2DC1242
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 18:37:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E962DA705
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 18:37:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 344EADA70C; Mon, 16 Dec 2019 18:37:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A5DCDA705;
        Mon, 16 Dec 2019 18:37:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 18:37:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EF4AC42EF4E0;
        Mon, 16 Dec 2019 18:37:55 +0100 (CET)
Date:   Mon, 16 Dec 2019 18:37:56 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] typeof incremental enhancements
Message-ID: <20191216173756.hwtpf5kzkl3c3ou2@salvia>
References: <20191216124222.356618-1-pablo@netfilter.org>
 <20191216124749.GR795@breakpoint.cc>
 <20191216130034.256a44juaeey7umf@salvia>
 <20191216140336.GS795@breakpoint.cc>
 <20191216150158.clh27hvid7pi7ldg@salvia>
 <20191216154841.GT795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216154841.GT795@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 16, 2019 at 04:48:41PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > If its not a problem to display a non-restoreable ruleset
> > > (e.g. unspecific 'type integer' shown as set keys) in that case
> > > then the interger,width part can be omitted indeed.
> > > 
> > > Let me know.  For concatenations, we will be unable to show
> > > a proper ruleset without the udata info anyway (concatentations
> > > do not work at the moment for non-specific types anyway though).
> > 
> > Indeed, what scenario are you considering that set udata might be
> > missing?
> 
> Any non-nft client/direct netlink user.

Ah I see, as direct uapi users.

> > We could still print it in such a case, even if we cannot parse it if
> > you are willing to deal with. Just to provide some information to the
> > user.
> 
> If udata is missing, we only have the type available.
>
> If its a type with unspecific length (string, integer) we can use
> the key length to get the bit size.
> 
> But for concatenation case, it might be ambigiuos.
> 
> So, I would remove the "type integer, length" format again so in
> such case we would print
> 
> type string
> or
> type integer.
>
> Users won't see this non-restoreable ruleset listed as long as the udata
> is there.

That's good enough by now, I think, thanks.

Once we get more of those users, if they want some sort of interaction
with nft, then we probably revisit this. Those clients might not even
use nft for listing the ruleset at all.
