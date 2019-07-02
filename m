Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B9BC5B57D
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8CB218AD
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfGCAin (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:38:43 -0400
Received: from mail.us.es ([193.147.175.20]:42526 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfGCAin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 20:38:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4229E80777
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:20:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 331E3DA7B6
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:20:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 288DA10219C; Wed,  3 Jul 2019 01:20:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9AEA202D2;
        Wed,  3 Jul 2019 01:20:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:20:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C8FAE4265A2F;
        Wed,  3 Jul 2019 01:20:12 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:20:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tests/py: Add tests for 'time', 'day' and 'hour'
Message-ID: <20190702232012.qvmxzei2o5aitj2q@salvia>
References: <20190701201646.7040-1-a@juaristi.eus>
 <20190701201646.7040-3-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701201646.7040-3-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 10:16:45PM +0200, Ander Juaristi wrote:
> Signed-off-by: Ander Juaristi <a@juaristi.eus>
> ---
>  tests/py/ip/meta.t         |  9 +++++++
>  tests/py/ip/meta.t.payload | 54 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
> index 4db8835..b4c3ce9 100644
> --- a/tests/py/ip/meta.t
> +++ b/tests/py/ip/meta.t
> @@ -3,6 +3,15 @@
>  *ip;test-ip4;input
>  
>  icmp type echo-request;ok
> +meta time "1970-05-23 21:07:14" drop;ok
> +meta time "2019-06-21 17:00:00" drop;ok
> +meta time "2019-07-01 00:00:00" drop;ok
> +meta time "2019-07-01 00:01:00" drop;ok
> +meta time "2019-07-01 00:00:01" drop;ok
> +meta day "Saturday" drop;ok;meta day "Saturday" drop

meta day "Saturday" drop;ok

should be fine, right?

> +meta hour "17:00" drop;ok;meta hour "17:00" drop

same here:

meta hour "17:00" drop;ok
