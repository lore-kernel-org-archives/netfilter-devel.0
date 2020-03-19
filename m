Return-Path: <SRS0=bD7Q=5E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58175C4332D
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 10:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD552070A
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 10:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgCSKAU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 06:00:20 -0400
Received: from correo.us.es ([193.147.175.20]:51710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSKAT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 06:00:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00A216D005
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 10:59:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5B32DA8E6
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 10:59:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DB528DA801; Thu, 19 Mar 2020 10:59:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 080A3DA736;
        Thu, 19 Mar 2020 10:59:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Mar 2020 10:59:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DA6D641E4800;
        Thu, 19 Mar 2020 10:59:43 +0100 (CET)
Date:   Thu, 19 Mar 2020 11:00:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?utf-8?B?0KHQtdGA0LPQtdC5INCc0LDRgNC40L3QutC10LLQuNGH?= 
        <s@marinkevich.ru>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: add range specified flag setting (missing
 NF_NAT_RANGE_PROTO_SPECIFIED)
Message-ID: <20200319100013.pkhcxybukcqhlhjf@salvia>
References: <df06055e-784a-9711-2ff5-6ef159e842ee@marinkevich.ru>
 <1b1cc909-1709-308d-e228-045b24b9c0a0@marinkevich.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b1cc909-1709-308d-e228-045b24b9c0a0@marinkevich.ru>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 19, 2020 at 01:33:10PM +0700, Сергей Маринкевич wrote:
> > Sergey, could you try this userspace patch instead? Thanks.
>
> I tried this patch with equal environment but another
> 
> net(192.168.122.0/24). Router uses vanilla kernel v5.4.19.
> Translation is the same.
> 
>     12:59:11.599887 08:00:27:ec:9c:b3 > 52:54:00:57:d2:7d, ethertype IPv4
> (0x0800), length 60: 192.168.122.38.666 > 192.168.122.1.667: UDP, length 4
> 
> I think i have to add this tag:
> 
> Tested-by: Sergey Marinkevich <s@marinkevich.ru>

Applied, thanks for testing.
