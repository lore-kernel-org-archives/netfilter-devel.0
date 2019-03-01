Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD33C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 12:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED91B2084D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 12:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfCAMwR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:52:17 -0500
Received: from mail.us.es ([193.147.175.20]:33324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbfCAMwR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 07:52:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A77AD47C40
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 13:52:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96BC2DA7FC
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 13:52:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8BFA5DA7F4; Fri,  1 Mar 2019 13:52:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93263DA85E;
        Fri,  1 Mar 2019 13:52:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 13:52:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 70A4F4265A4E;
        Fri,  1 Mar 2019 13:52:10 +0100 (CET)
Date:   Fri, 1 Mar 2019 13:52:09 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/5] extensions: connlabel: Allow connlabel.conf
 override
Message-ID: <20190301125209.6iuqkspstwsn4724@salvia>
References: <20190219193953.29066-1-phil@nwl.cc>
 <20190219193953.29066-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219193953.29066-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Tue, Feb 19, 2019 at 08:39:51PM +0100, Phil Sutter wrote:
> Check for environment variable XT_CONNLABEL_CFG and if set use its value
> as path to connlabel.conf.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  extensions/libxt_connlabel.c   | 6 ++++--
>  extensions/libxt_connlabel.man | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
> index d06bb27a7c2e9..9a2f9ce34647e 100644
> --- a/extensions/libxt_connlabel.c
> +++ b/extensions/libxt_connlabel.c
> @@ -3,6 +3,7 @@
>  #include <string.h>
>  #include <stdio.h>
>  #include <stdint.h>
> +#include <stdlib.h>
>  #include <xtables.h>
>  #include <linux/netfilter/xt_connlabel.h>
>  #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
> @@ -39,11 +40,12 @@ static void connlabel_open(void)
>  	if (map)
>  		return;
>  
> -	map = nfct_labelmap_new(NULL);
> +	fname = getenv("XT_CONNLABEL_CFG") ?: nfct_labels_get_path();

Only one question about this one: Would you need anything similar for
nft? If so, probably it's better to place this code in
libnetfilter_conntrack.
