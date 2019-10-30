Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066C8CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 09:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7627205ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 09:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfJ3JPZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 05:15:25 -0400
Received: from correo.us.es ([193.147.175.20]:54042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfJ3JPZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 05:15:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2222B1BFA96
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 10:15:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 136E0B7FFB
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 10:15:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 091ACB8007; Wed, 30 Oct 2019 10:15:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29CD0B7FFE
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 10:15:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Oct 2019 10:15:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0735742EE396
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 10:15:18 +0100 (CET)
Date:   Wed, 30 Oct 2019 10:15:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question
Message-ID: <20191030091521.gosjooprb27xgoc6@salvia>
References: <20191030090707.GB6302@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030090707.GB6302@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 30, 2019 at 08:07:07PM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> When setting verdicts, does sending amended packet contents imply to accept the
> packet? In my app I have assumed not and that seems to work fine, but I'd like
> to be sure for the doco.

If you set the verdict to NF_ACCEPT and the packet that you send back
to the kernel is mangled, then the kernel takes your mangled packet
contents.

Thanks.
