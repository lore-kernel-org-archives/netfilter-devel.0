Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C137BC31E50
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D8582080C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfFQN5M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:57:12 -0400
Received: from mail.us.es ([193.147.175.20]:54366 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQN5M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 09:57:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D26D5B5702
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 15:57:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C23EDDA709
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 15:57:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B76A6DA706; Mon, 17 Jun 2019 15:57:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE29BDA706;
        Mon, 17 Jun 2019 15:57:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 15:57:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8A99E4265A31;
        Mon, 17 Jun 2019 15:57:07 +0200 (CEST)
Date:   Mon, 17 Jun 2019 15:57:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/7] ipset patches for nf-next
Message-ID: <20190617135707.ha6nepe4eo3l7p2m@salvia>
References: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 10, 2019 at 02:24:09PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to pull the next patches for the nf-next tree:
> 
> - Remove useless memset() calls, nla_parse_nested/nla_parse
>   erase the tb array properly, from Florent Fourcot.
> - Merge the uadd and udel functions, the code is nicer
>   this way, also from Florent Fourcot.
> - Add a missing check for the return value of a
>   nla_parse[_deprecated] call, from Aditya Pakki.
> - Add the last missing check for the return value
>   of nla_parse[_deprecated] call.
> - Fix error path and release the references properly
>   in set_target_v3_checkentry().
> - Fix memory accounting which is reported to userspace
>   for hash types on resize, from Stefano Brivio.
> - Update my email address to kadlec@netfilter.org.
>   The patch covers all places in the source tree where
>   my kadlec@blackhole.kfki.hu address could be found.
>   If the patch needs to be splitted up, just let me know!

Pulled, thanks Jozsef!
