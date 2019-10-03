Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0397C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 10:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC99218DE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 10:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfJCKYY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:24:24 -0400
Received: from correo.us.es ([193.147.175.20]:48172 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfJCKYY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 06:24:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A12B1ED5CE
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2019 12:24:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 925C6B8017
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2019 12:24:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8821AB8011; Thu,  3 Oct 2019 12:24:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91AD6B7FF9
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2019 12:24:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 03 Oct 2019 12:24:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6998341E4802
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2019 12:24:17 +0200 (CEST)
Date:   Thu, 3 Oct 2019 12:24:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Fix a missing doxygen section trailer in nlmsg.c
Message-ID: <20191003102419.qlotnheuu5cocw7z@salvia>
References: <20191002064848.30620-1-duncan_roe@optusnet.com.au>
 <20191002235634.GA8689@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002235634.GA8689@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 03, 2019 at 09:56:34AM +1000, Duncan Roe wrote:
> On Wed, Oct 02, 2019 at 04:48:48PM +1000, Duncan Roe wrote:
> > This corrects an oddity in the web doco (and presumably in the man pages as
> > well) whereby "Netlink message batch helpers" was showing up as a sub-topic of
> > "Netlink message helpers".

Applied, thanks.
