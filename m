Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0196C76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 10:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD4321783
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 10:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfGRKBg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 06:01:36 -0400
Received: from mail.us.es ([193.147.175.20]:39450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfGRKBg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 06:01:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F18D0F26E3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 12:01:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D72B8115109
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 12:01:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5C9711510D; Thu, 18 Jul 2019 12:01:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 134DBDA4D1;
        Thu, 18 Jul 2019 12:01:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 12:01:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E65684265A2F;
        Thu, 18 Jul 2019 12:01:30 +0200 (CEST)
Date:   Thu, 18 Jul 2019 12:01:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] include: json: add missing synproxy stmt print stub
Message-ID: <20190718100130.ulbrtnk425rhigs5@salvia>
References: <20190718094114.28800-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718094114.28800-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Thu, Jul 18, 2019 at 11:41:14AM +0200, Fernando Fernandez Mancera wrote:
> Fixes: 1188a69604c3 ("src: introduce SYNPROXY matching")
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/json.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/json.h b/include/json.h
> index ce57c9f..7f2df7c 100644
> --- a/include/json.h
> +++ b/include/json.h
> @@ -180,6 +180,7 @@ STMT_PRINT_STUB(queue)
>  STMT_PRINT_STUB(verdict)
>  STMT_PRINT_STUB(connlimit)
>  STMT_PRINT_STUB(tproxy)
> +STMT_PRINT_STUB(synproxy)

I'm sure you need this, but how does this missing line manifests as a
problem?
