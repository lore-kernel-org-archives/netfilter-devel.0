Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F96C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 18:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6ADF2071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 18:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389700AbgEYSkG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 14:40:06 -0400
Received: from correo.us.es ([193.147.175.20]:54398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389619AbgEYSkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 14:40:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC4CACE616
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 20:40:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEFD1DA712
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 20:40:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A453FDA714; Mon, 25 May 2020 20:40:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3A37DA703;
        Mon, 25 May 2020 20:40:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 20:40:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A494142EFB81;
        Mon, 25 May 2020 20:40:02 +0200 (CEST)
Date:   Mon, 25 May 2020 20:40:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] netfilter: enable reject with bridge vlan
Message-ID: <20200525184002.GA10934@salvia>
References: <cover.1588758255.git.michael-dev@fami-braun.de>
 <1b723dbc8a1a5124794bc3deb7dedf8d46dafcbc.1588758255.git.michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b723dbc8a1a5124794bc3deb7dedf8d46dafcbc.1588758255.git.michael-dev@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 06, 2020 at 11:46:25AM +0200, Michael Braun wrote:
> Currently, using the bridge reject target with tagged packets
> results in untagged packets being sent back.
> 
> Fix this by mirroring the vlan id as well.

Applied, thanks.
