Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11680C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC3C3213F2
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfDHWf4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:35:56 -0400
Received: from mail.us.es ([193.147.175.20]:55650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbfDHWf4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 18:35:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4E4503066A3
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:35:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39B05DA70E
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:35:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 393BEDA70D; Tue,  9 Apr 2019 00:35:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E1FCDA70B;
        Tue,  9 Apr 2019 00:35:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 00:35:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 059244265A31;
        Tue,  9 Apr 2019 00:35:51 +0200 (CEST)
Date:   Tue, 9 Apr 2019 00:35:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [nftables] tests/py: Add Test for `meta time`
Message-ID: <20190408223551.sqzjaucb6jyegyci@salvia>
References: <20190318094745.GA4394@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318094745.GA4394@nebula>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 18, 2019 at 03:17:45PM +0530, Karuna Grewal wrote:
> Signed-off-by: Karuna Grewal <karunagrewal98@gmail.com>
> ---
>  tests/py/any/meta.t         |  3 +++
>  tests/py/any/meta.t.json    | 12 ++++++++++++
>  tests/py/any/meta.t.payload |  5 +++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
> index d69b8b4e..3d23dc75 100644
> --- a/tests/py/any/meta.t
> +++ b/tests/py/any/meta.t
> @@ -205,3 +205,6 @@ meta iif . meta oif vmap { "lo" . "lo" : drop };ok;iif . oif vmap { "lo" . "lo"
>  
>  meta random eq 1;ok;meta random 1
>  meta random gt 1000000;ok;meta random > 1000000
> +
> +meta time 100;ok;meta timestamp 1m40s

I think the important thing here is to support for dates.

I remember Florian mentioned we need a new datatype for this, to
express dates.

Still we need support for time range, ie. hh:mm[:ss]-hh:mm[:ss],
monthdays and weekdays.

We should _not_ support --kerneltz, that broken. We should just
provide an alternative that works with UTC. Hopefully daylight saving
will be removed everywhere soon (EU is planning for this), so we won't
need --kerneltz.

Talking by looking at what I see in man iptables-extensions when I
look for the `time' match.

Will you work on this?
