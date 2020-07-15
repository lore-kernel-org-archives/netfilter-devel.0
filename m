Return-Path: <SRS0=26XO=A2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15037C433E4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jul 2020 18:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC44120656
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jul 2020 18:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGOSyr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:54:47 -0400
Received: from correo.us.es ([193.147.175.20]:41732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgGOSyr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jul 2020 14:54:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A2A1DA3D2
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2020 20:54:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BEC2DA78C
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2020 20:54:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 32948DA840; Wed, 15 Jul 2020 20:54:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8163DA78C;
        Wed, 15 Jul 2020 20:54:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Jul 2020 20:54:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C42054265A2F;
        Wed, 15 Jul 2020 20:54:42 +0200 (CEST)
Date:   Wed, 15 Jul 2020 20:54:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Andrew Sy Kim <kim.andrewsy@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] ipvs: queue delayed work to expire no
 destination connections if expire_nodest_conn=1
Message-ID: <20200715185442.GA19665@salvia>
References: <20200708161245.GB14873@salvia>
 <20200708161638.13584-1-kim.andrewsy@gmail.com>
 <alpine.LFD.2.23.451.2007082006311.3373@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.23.451.2007082006311.3373@ja.home.ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 08, 2020 at 08:19:55PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 8 Jul 2020, Andrew Sy Kim wrote:
> 
> > When expire_nodest_conn=1 and a destination is deleted, IPVS does not
> > expire the existing connections until the next matching incoming packet.
> > If there are many connection entries from a single client to a single
> > destination, many packets may get dropped before all the connections are
> > expired (more likely with lots of UDP traffic). An optimization can be
> > made where upon deletion of a destination, IPVS queues up delayed work
> > to immediately expire any connections with a deleted destination. This
> > ensures any reused source ports from a client (within the IPVS timeouts)
> > are scheduled to new real servers instead of silently dropped.
> > 
> > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> 
> 	OK, patch content is same, subject has "ipvs:" prefix,
> empty line after Signed-off-by is removed, so this patch can
> be applied without any modifications.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Applied, thanks.
