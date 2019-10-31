Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A6FCA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 13:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8768E20873
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 13:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfJaNOO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 09:14:14 -0400
Received: from correo.us.es ([193.147.175.20]:50736 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfJaNOO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 09:14:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9EC5FC5FB
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 14:14:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCBA5BAACC
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 14:14:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C27BDCA0F3; Thu, 31 Oct 2019 14:14:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4C35DA801;
        Thu, 31 Oct 2019 14:14:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 31 Oct 2019 14:14:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C00C942EE38F;
        Thu, 31 Oct 2019 14:14:07 +0100 (CET)
Date:   Thu, 31 Oct 2019 14:14:09 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Jallot <ejallot@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: flowtable: add support for named flowtable
 listing
Message-ID: <20191031131409.bqhmyagiiypoe5qh@salvia>
References: <20191030170619.45231-1-ejallot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030170619.45231-1-ejallot@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 30, 2019 at 06:06:19PM +0100, Eric Jallot wrote:
> This patch allows you to dump a named flowtable.
> 
>  # nft list flowtable inet t f
>  table inet t {
>          flowtable f {
>                  hook ingress priority filter + 10
>                  devices = { eth0, eth1 }
>          }
>  }
> 
> Also:
> libnftables-json.adoc: fix missing quotes.

Applied, thanks.
