Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6B9C48BE4
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 18:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 161292064A
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 18:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfF0SOX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 14:14:23 -0400
Received: from mail.us.es ([193.147.175.20]:38128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfF0SOX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 14:14:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7F0F1B6944
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 20:14:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D826ADA4CA
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 20:14:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CDD58DA708; Thu, 27 Jun 2019 20:14:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D716EDA704;
        Thu, 27 Jun 2019 20:14:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 20:14:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B5C754265A2F;
        Thu, 27 Jun 2019 20:14:18 +0200 (CEST)
Date:   Thu, 27 Jun 2019 20:14:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     shekhar sharma <shekhar250198@gmail.com>
Cc:     Eric Garver <eric@garver.life>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v9] tests: py: add netns feature
Message-ID: <20190627181418.yayq46bbkd7cmgkb@salvia>
References: <20190621174053.4087-1-shekhar250198@gmail.com>
 <20190627125210.7lim5znivu3i2oxn@egarver.localdomain>
 <CAN9XX2qFCNe0=BwbqVymg8S3_uX_0fu67=2TJ3erbGv_MDGL=A@mail.gmail.com>
 <CAN9XX2ooDk5F7y7N5ugLUQDqLU2DbPbcEnoabB8K8c2jM5stNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9XX2ooDk5F7y7N5ugLUQDqLU2DbPbcEnoabB8K8c2jM5stNQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 09:46:43PM +0530, shekhar sharma wrote:
> For now, i am posting a patch containing the changes for python3 as
> well as for netns feature
> without changing the cmp() function so that the changes proposed by
> eric in his patch
> can be applied.
> If it is necessary i will post another version without the python3 changes :-).

Please submit a patch that:

#1 updates nft-tests.py for python3, that also works with python2,
including the changes that Eric suggested.

then, once I apply patch #1...

#2 You send me a patch to add the netns support for nft-tests.py

Better off if we do one thing at a time :-)

Thanks.
