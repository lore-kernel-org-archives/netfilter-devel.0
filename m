Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F07CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 15:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C98FD20650
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 15:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfJaPCi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 11:02:38 -0400
Received: from correo.us.es ([193.147.175.20]:43896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfJaPCi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 11:02:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 248A620A52D
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 16:02:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16967B8007
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 16:02:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0C4FDB8005; Thu, 31 Oct 2019 16:02:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23B9FB7FF2;
        Thu, 31 Oct 2019 16:02:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 31 Oct 2019 16:02:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F3FF142EE38F;
        Thu, 31 Oct 2019 16:02:31 +0100 (CET)
Date:   Thu, 31 Oct 2019 16:02:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 0/7] Improve xtables-restore performance
Message-ID: <20191031150234.osfnsa2emuvhocrc@salvia>
References: <20191024163712.22405-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 06:37:05PM +0200, Phil Sutter wrote:
> This series speeds up xtables-restore calls with --noflush (typically
> used to batch a few commands for faster execution) by preliminary input
> inspection.
> 
> Before, setting --noflush flag would inevitably lead to full cache
> population. With this series in place, if input can be fully buffered
> and no commands requiring full cache is contained, no initial cache
> population happens and each rule parsed will cause fetching of cache
> bits as required.
> 
> The input buffer size is arbitrarily chosen to be 64KB.
> 
> Patches one and two prepare code for patch three which moves the loop
> content parsing each line of input into a separate function. The
> reduction of code indenting is used by patch four which deals with
> needless line breaks.

For patches from 1 to 4 in this batch:

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> Patch five deals with another requirement of input buffering, namely
> stripping newline characters from each line. This is not a problem by
> itself, but add_param_to_argv() replaces them by nul-chars and so
> strings stop being consistently terminated (some by a single, some by
> two nul-chars).
> 
> Patch six then finally adds the buffering and caching decision code.
> 
> Patch seven is pretty unrelated but tests a specific behaviour of
> *tables-restore I wasn't sure of at first.

Do you have any number?
