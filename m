Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BC0C64E7B
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 13:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADFA20770
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 13:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgLANhY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:37:24 -0500
Received: from correo.us.es ([193.147.175.20]:46228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgLANhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 08:37:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D8C7A4175
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 14:36:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F963DA791
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 14:36:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 851F4DA722; Tue,  1 Dec 2020 14:36:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C0C3DA722;
        Tue,  1 Dec 2020 14:36:38 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 01 Dec 2020 14:36:38 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3BF8D42EF42A;
        Tue,  1 Dec 2020 14:36:38 +0100 (CET)
Date:   Tue, 1 Dec 2020 14:36:39 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: use actual socket sk for REJECT action
Message-ID: <20201201133639.GA1323@salvia>
References: <20201121111151.15960-1-jengelh@inai.de>
 <20201201084955.GC26468@salvia>
 <3s5q4s74-7q3n-69po-1q26-5qr718np489@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3s5q4s74-7q3n-69po-1q26-5qr718np489@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 01, 2020 at 01:49:21PM +0100, Jan Engelhardt wrote:
> On Tuesday 2020-12-01 09:49, Pablo Neira Ayuso wrote:
>
> >Hi Jan,
> >
> >On Sat, Nov 21, 2020 at 12:11:51PM +0100, Jan Engelhardt wrote:
> >> True to the message of commit v5.10-rc1-105-g46d6c5ae953c, _do_
> >> actually make use of state->sk when possible, such as in the REJECT
> >> modules.
> >
> >Could you rebase and resend a v2? I think this patch is clashing with
> >recent updates to add REJECT support for ingress.
>
> I observed no conflict when attempting the rebase command, either onto
>  cb7fb043e69a (/pub/scm/linux/kernel/git/netdev/net-next.git #master) or
>  f7583f02a538 (/pub/scm/linux/kernel/git/pablo/nf-next #master)

I see, it does not apply via:

        git am netfilter-use-actual-socket-sk-for-REJECT-action.patch

because patch shows:

diff --git include/net/netfilter/ipv4/nf_reject.h include/net/netfilter/ipv4/nf_reject.h
index 40e0e0623f46..d8207a82d761 100644
--- include/net/netfilter/ipv4/nf_reject.h
+++ include/net/netfilter/ipv4/nf_reject.h

instead of:

diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
index 40e0e0623f46..d8207a82d761 100644
--- a/include/net/netfilter/ipv4/nf_reject.h
+++ b/include/net/netfilter/ipv4/nf_reject.h

I just manually updated the patch so now it works.

Is there a similar way to make patch -p0 for git-am BTW?

Thanks.
