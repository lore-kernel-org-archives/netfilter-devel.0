Return-Path: <SRS0=+PCd=EI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D288FC388F2
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Nov 2020 13:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91337222EC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Nov 2020 13:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgKBNtP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Nov 2020 08:49:15 -0500
Received: from correo.us.es ([193.147.175.20]:55942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgKBNtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Nov 2020 08:49:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E65AB60C6
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 14:49:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 625AEDA73F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 14:49:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57F3DDA73D; Mon,  2 Nov 2020 14:49:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EBE0DA722;
        Mon,  2 Nov 2020 14:49:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Nov 2020 14:49:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0465C41FF208;
        Mon,  2 Nov 2020 14:49:10 +0100 (CET)
Date:   Mon, 2 Nov 2020 14:49:10 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] conntrack: implement save output format
Message-ID: <20201102134910.GA11998@salvia>
References: <20201029115156.69784-1-mikhail.sennikovskii@cloud.ionos.com>
 <20201029115156.69784-2-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201029115156.69784-2-mikhail.sennikovskii@cloud.ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 29, 2020 at 12:51:55PM +0100, Mikhail Sennikovsky wrote:
> This commit allows dumping conntrack entries in the format
> used by the conntrack parameters, aka "save" output format.
> This is useful for saving ct entry data to allow applying
> it later on.
> 
> To enable the "save" output the "-o save" parameter needs
> to be passed to the contnrack tool invocation.

Applied, thanks.

A few minor glitches, the most relevant to mention is that -u UNSET is
displayed when the status bits string is empty.

I have also added a check to allow for -o save only, maybe some other
output flags can be supported in combination in the future, meanwhile,
let's report an error to the user.

Thanks.
