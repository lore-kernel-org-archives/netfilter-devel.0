Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6FDC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C78F20828
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfH0LA3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 07:00:29 -0400
Received: from correo.us.es ([193.147.175.20]:52002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0LA2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 07:00:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAE08154E85
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 13:00:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B973CA0F3
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 13:00:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91513D1929; Tue, 27 Aug 2019 13:00:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EB25DA840;
        Tue, 27 Aug 2019 13:00:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Aug 2019 13:00:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6C5EC42EE39A;
        Tue, 27 Aug 2019 13:00:23 +0200 (CEST)
Date:   Tue, 27 Aug 2019 13:00:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Todd Seidelmann <tseidelmann@linode.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_physdev: Fix spurious error message in
 physdev_mt_check
Message-ID: <20190827110024.ujz22envdidmtlyo@salvia>
References: <88b305fb-ebb9-5e81-f8ef-55a18609c5fc@linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88b305fb-ebb9-5e81-f8ef-55a18609c5fc@linode.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 11:47:53AM -0400, Todd Seidelmann wrote:
> Simplify the check in physdev_mt_check() to emit an error message
> only when passed an invalid chain (ie, NF_INET_LOCAL_OUT).
> This avoids cluttering up the log with errors against valid rules.
> 
> For large/heavily modified rulesets, current behavior can quickly
> overwhelm the ring buffer, because this function gets called on
> every change, regardless of the rule that was changed.

Applied, comment below.

>  net/netfilter/xt_physdev.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
> index ead7c6022208..b92b22ce8abd 100644
> --- a/net/netfilter/xt_physdev.c
> +++ b/net/netfilter/xt_physdev.c
> @@ -101,11 +101,9 @@ static int physdev_mt_check(const struct xt_mtchk_param
> *par)

Please, fix your MUA, patch is mangled, I have fixed it here this
time, this was not applying via git-am.
