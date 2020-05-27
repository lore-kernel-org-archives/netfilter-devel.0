Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF31C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 22:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F195820707
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 22:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgE0WYR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 18:24:17 -0400
Received: from correo.us.es ([193.147.175.20]:49384 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgE0WYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 18:24:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7DEC15AED8
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 00:24:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB35EDA70E
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 00:24:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B0C07DA705; Thu, 28 May 2020 00:24:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0245DA70F;
        Thu, 28 May 2020 00:24:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 28 May 2020 00:24:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 904FF42EF4E0;
        Thu, 28 May 2020 00:24:13 +0200 (CEST)
Date:   Thu, 28 May 2020 00:24:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Romain Bellan <romain.bellan@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [PATCH nf-next v6] netfilter: ctnetlink: add kernel side
 filtering for dump
Message-ID: <20200527222413.GA1332@salvia>
References: <20200504193429.24125-1-romain.bellan@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504193429.24125-1-romain.bellan@wifirst.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 04, 2020 at 09:34:29PM +0200, Romain Bellan wrote:
> Conntrack dump does not support kernel side filtering (only get exists,
> but it returns only one entry. And user has to give a full valid tuple)
> 
> It means that userspace has to implement filtering after receiving many
> irrelevant entries, consuming resources (conntrack table is sometimes
> very huge, much more than a routing table for example).
> 
> This patch adds filtering in kernel side. To achieve this goal, we:
> 
>  * Add a new CTA_FILTER netlink attributes, actually a flag list to
>    parametize filtering
>  * Convert some *nlattr_to_tuple() functions, to allow a partial parsing
>    of CTA_TUPLE_ORIG and CTA_TUPLE_REPLY (so nf_conntrack_tuple it not
>    fully set)
> 
> Filtering is now possible on:
>  * IP SRC/DST values
>  * Ports for TCP and UDP flows
>  * IMCP(v6) codes types and IDs
> 
> Filtering is done as an "AND" operator. For example, when flags
> PROTO_SRC_PORT, PROTO_NUM and IP_SRC are sets, only entries matching all
> values are dumped.
> 
> Changes since v1:
>   Set NLM_F_DUMP_FILTERED in nlm flags if entries are filtered
> 
> Changes since v2:
>   Move several constants to nf_internals.h
>   Move a fix on netlink values check in a separate patch
>   Add a check on not-supported flags
>   Return EOPNOTSUPP if CDA_FILTER is set in ctnetlink_flush_conntrack
>   (not yet implemented)
>   Code style issues
> 
> Changes since v3:
>   Fix compilation warning reported by kbuild test robot
> 
> Changes since v4:
>   Fix a regression introduced in v3 (returned EINVAL for valid netlink
>   messages without CTA_MARK)
> 
> Changes since v5:
>   Change definition of CTA_FILTER_F_ALL
>   Fix a regression when CTA_TUPLE_ZONE is not set

Applied, thanks for your patience.
