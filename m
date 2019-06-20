Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51410C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 14:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F3B82083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 14:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfFTOhg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 10:37:36 -0400
Received: from mail.us.es ([193.147.175.20]:56110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfFTOhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 10:37:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CBD3C1B73
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 16:37:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E070DA708
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 16:37:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 23D13DA705; Thu, 20 Jun 2019 16:37:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 363EDDA708;
        Thu, 20 Jun 2019 16:37:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 16:37:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1519D4265A31;
        Thu, 20 Jun 2019 16:37:32 +0200 (CEST)
Date:   Thu, 20 Jun 2019 16:37:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v9]tests: py: fix pyhton3
Message-ID: <20190620143731.jfnty672zi7rcxgs@salvia>
References: <20190619175741.22411-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619175741.22411-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 11:27:41PM +0530, Shekhar Sharma wrote:
> This patch changes the file to run on both python2 and python3.
> 
> The tempfile module has been imported and used.
> Although the previous replacement of cmp() by eric works, 
> I have replaced cmp(a,b) by ((a>b)-(a<b)) which works correctly.

Any reason not to use Eric's approach? This ((a>b)-(a<b)) is
confusing.

> Thanks!

BTW, strictly place your patch description here.

Things like "Thanks!" to someone specifically and the cmp()
explanation should go below the --- marker, like versioning.

BTW, Cc Eric Garver in your patches, he's helping us with reviewing :-)
