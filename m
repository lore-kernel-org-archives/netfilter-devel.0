Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BB6C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 10:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A64022A99
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 10:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgLDKht (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:37:49 -0500
Received: from correo.us.es ([193.147.175.20]:35408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgLDKhs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 05:37:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46FB31228C7
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2020 11:37:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 376531150B3
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2020 11:37:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D1471150AF; Fri,  4 Dec 2020 11:37:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F020F1150A2;
        Fri,  4 Dec 2020 11:36:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 04 Dec 2020 11:36:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D156A4265A5A;
        Fri,  4 Dec 2020 11:36:58 +0100 (CET)
Date:   Fri, 4 Dec 2020 11:37:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>
Subject: Re: [nft PATCH] json: Fix seqnum_to_json() functionality
Message-ID: <20201204103702.GA27070@salvia>
References: <20201202222701.459-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201202222701.459-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 02, 2020 at 11:27:01PM +0100, Phil Sutter wrote:
> Introduction of json_cmd_assoc_hash missed that by the time the hash
> table insert happens, the struct cmd object's 'seqnum' field which is
> used as key is not initialized yet. This doesn't happen until
> nft_netlink() prepares the batch object which records the lowest seqnum.
> Therefore push all json_cmd_assoc objects into a temporary list until
> the first lookup happens. At this time, all referenced cmd objects have
> their seqnum set and the list entries can be moved into the hash table
> for fast lookups.
> 
> To expose such problems in the future, make json_events_cb() emit an
> error message if the passed message has a handle but no assoc entry is
> found for its seqnum.

Patch LGTM.
