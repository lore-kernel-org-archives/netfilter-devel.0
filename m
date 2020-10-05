Return-Path: <SRS0=VfFo=DM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD56C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 23:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52837206F7
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 23:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgJEXl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 19:41:26 -0400
Received: from correo.us.es ([193.147.175.20]:56814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJEXlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 19:41:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2FE72E2C45
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 01:41:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21E0CDA789
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 01:41:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 17A36DA72F; Tue,  6 Oct 2020 01:41:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 051E6DA78C;
        Tue,  6 Oct 2020 01:41:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Oct 2020 01:41:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DD8F142EF42A;
        Tue,  6 Oct 2020 01:41:21 +0200 (CEST)
Date:   Tue, 6 Oct 2020 01:41:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 3/3] libxtables: Register multiple extensions in
 ascending order
Message-ID: <20201005234121.GA14242@salvia>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200922225341.8976-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 23, 2020 at 12:53:41AM +0200, Phil Sutter wrote:
> The newly introduced ordered insert algorithm in
> xtables_register_{match,target}() works best if extensions of same name
> are passed in ascending revisions. Since this is the case in about all
> extensions' arrays, iterate over them from beginning to end.

This patch should come first in the series, my understanding is that
1/3 assumes that extensions are registered from lower to higher
revision number.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  libxtables/xtables.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index de74d361a53af..90b1195c45a58 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1139,9 +1139,10 @@ static bool xtables_fully_register_pending_match(struct xtables_match *me,
>  
>  void xtables_register_matches(struct xtables_match *match, unsigned int n)
>  {
> -	do {
> -		xtables_register_match(&match[--n]);
> -	} while (n > 0);
> +	int i;
> +
> +	for (i = 0; i < n; i++)
> +		xtables_register_match(&match[i]);
>  }
>  
>  void xtables_register_target(struct xtables_target *me)
> @@ -1264,9 +1265,10 @@ static bool xtables_fully_register_pending_target(struct xtables_target *me,
>  
>  void xtables_register_targets(struct xtables_target *target, unsigned int n)
>  {
> -	do {
> -		xtables_register_target(&target[--n]);
> -	} while (n > 0);
> +	int i;
> +
> +	for (i = 0; i < n; i++)
> +		xtables_register_target(&target[i]);
>  }
>  
>  /* receives a list of xtables_rule_match, release them */
> -- 
> 2.28.0
> 
