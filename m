Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B4CC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 12:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10DED2071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 12:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfL3MM6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 07:12:58 -0500
Received: from correo.us.es ([193.147.175.20]:59156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfL3MM6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 07:12:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6ADD311EB39
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 13:12:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C9E5DA715
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 13:12:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5213FDA70F; Mon, 30 Dec 2019 13:12:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56E70DA710;
        Mon, 30 Dec 2019 13:12:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 13:12:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [185.124.28.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0DB2542EE38E;
        Mon, 30 Dec 2019 13:12:53 +0100 (CET)
Date:   Mon, 30 Dec 2019 13:12:53 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Romain Bellan <romain.bellan@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: add kernel side filtering
 for dump
Message-ID: <20191230121253.laf2ttcfpjgbfowt@salvia>
References: <20191219103638.20454-1-romain.bellan@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219103638.20454-1-romain.bellan@wifirst.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Romain,

On Thu, Dec 19, 2019 at 11:36:38AM +0100, Romain Bellan wrote:
> Conntrack dump does not support kernel side filtering (only get exists,
> but it returns only one entry. And user has to give a full valid tuple)
> 
> It means that userspace has to implement filtering after receiving many
> irrelevant entries, consuming ressources (conntrack table is sometimes
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
> Filtering is done has an "AND" operator. For example, when flags
> PROTO_SRC_PORT, PROTO_NUM and IP_SRC are sets, only entries matching all
> values are dumped.

Thanks for submitting this.

I did not yet have a look at this in detail, will do asap.

However, I would like to know if you would plan to submit userspace
patches for libnetfilter_conntrack for this. Main problem here is
backward compatibility (old conntrack tool and new kernel).
