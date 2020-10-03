Return-Path: <SRS0=DeQi=DK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09992C41604
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Oct 2020 11:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE40F206C9
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Oct 2020 11:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJCLRs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Oct 2020 07:17:48 -0400
Received: from correo.us.es ([193.147.175.20]:37478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgJCLRs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Oct 2020 07:17:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F32BC120831
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2020 13:17:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3BB7DA791
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2020 13:17:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D97F6DA789; Sat,  3 Oct 2020 13:17:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98F40DA704;
        Sat,  3 Oct 2020 13:17:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 03 Oct 2020 13:17:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.174.3.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 30EA642EF9E0;
        Sat,  3 Oct 2020 13:17:43 +0200 (CEST)
Date:   Sat, 3 Oct 2020 13:17:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 1/3] libxtables: Make sure extensions register
 in revision order
Message-ID: <20201003111741.GA3035@salvia>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200922225341.8976-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Sep 23, 2020 at 12:53:39AM +0200, Phil Sutter wrote:
> Insert extensions into pending lists in ordered fashion: Group by
> extension name (and, for matches, family) and order groups by descending
> revision number.
>
> This allows to simplify the later full registration considerably. Since
> that involves kernel compatibility checks, the extra cycles here pay off
> eventually.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  libxtables/xtables.c | 64 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 8907ba2069be7..63d0ea5def2d5 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -948,8 +948,14 @@ static void xtables_check_options(const char *name, const struct option *opt)
>  		}
>  }
>  
> +static int xtables_match_prefer(const struct xtables_match *a,
> +				const struct xtables_match *b);
> +
>  void xtables_register_match(struct xtables_match *me)
>  {
> +	struct xtables_match **pos;
> +	bool seen_myself = false;
> +
>  	if (me->next) {
>  		fprintf(stderr, "%s: match \"%s\" already registered\n",
>  			xt_params->program_name, me->name);
> @@ -1001,10 +1007,32 @@ void xtables_register_match(struct xtables_match *me)
>  	if (me->extra_opts != NULL)
>  		xtables_check_options(me->name, me->extra_opts);
>  
> +	/* order into linked list of matches pending full registration */
> +	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
> +		/* NOTE: No extension_cmp() here as we accept all families */
> +		if (strcmp(me->name, (*pos)->name) ||
> +		    me->family != (*pos)->family) {
> +			if (seen_myself)
> +				break;
> +			continue;
> +		}
> +		seen_myself = true;
> +		if (xtables_match_prefer(me, *pos) >= 0)

xtables_match_prefer() evaluates >= 0 if 'me' has higher revision
number than *pos. So list order is: higher revision first.

> +			break;
> +	}
> +	if (!*pos)
> +		pos = &xtables_pending_matches;
>  
> -	/* place on linked list of matches pending full registration */
> -	me->next = xtables_pending_matches;
> -	xtables_pending_matches = me;
> +	me->next = *pos;

This line above is placing 'me' right before the existing match in the list.

> +	*pos = me;

This line above only works if *pos is &xtables_pending_matches?

Looking at the in-tree extensions, they are always ordered from lower
to higher (in array definitions).
