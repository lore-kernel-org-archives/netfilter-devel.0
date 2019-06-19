Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C2AC31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 11:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64DD421479
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 11:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfFSLG3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 07:06:29 -0400
Received: from mail.us.es ([193.147.175.20]:52896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbfFSLG2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 07:06:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 258E1190F62
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 13:06:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13F99DA707
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 13:06:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1303DDA703; Wed, 19 Jun 2019 13:06:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C9F1DA71F;
        Wed, 19 Jun 2019 13:06:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 13:06:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E94B94265A2F;
        Wed, 19 Jun 2019 13:06:24 +0200 (CEST)
Date:   Wed, 19 Jun 2019 13:06:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 nf-next] netfilter: enable set expiration time for set
 elements
Message-ID: <20190619110624.ew7i3jiy25bfct7o@salvia>
References: <20190618091102.s5qnmdrdh5lkii7s@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618091102.s5qnmdrdh5lkii7s@nevthink>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 11:11:02AM +0200, Laura Garcia Liebana wrote:
> Currently, the expiration of every element in a set or map
> is a read-only parameter generated at kernel side.
> 
> This change will permit to set a certain expiration date
> per element that will be required, for example, during
> stateful replication among several nodes.
> 
> This patch handles the NFTA_SET_ELEM_EXPIRATION in order
> to configure the expiration parameter per element, or
> will use the timeout in the case that the expiration
> is not set.

Applied, thanks Laura.
