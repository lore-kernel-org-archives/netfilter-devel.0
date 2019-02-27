Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13B1C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 09:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC3A2213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 09:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfB0Jrd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 04:47:33 -0500
Received: from mail.us.es ([193.147.175.20]:40972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfB0Jrd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 04:47:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA2BD2EFEA4
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 10:47:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2BA6DA87A
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 10:47:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C126CDA86E; Wed, 27 Feb 2019 10:47:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 805D2DA87A;
        Wed, 27 Feb 2019 10:47:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Feb 2019 10:47:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5C52D4265A2F;
        Wed, 27 Feb 2019 10:47:28 +0100 (CET)
Date:   Wed, 27 Feb 2019 10:47:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Tham <tham@fidion.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_conntrack_amanda: add support for STATE
 streams
Message-ID: <20190227094726.5lr354arfoos3c3f@salvia>
References: <dd24bc58-2ad4-8e8b-7a50-deaf0a54d4ab@fidion.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd24bc58-2ad4-8e8b-7a50-deaf0a54d4ab@fidion.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 18, 2019 at 09:55:46AM +0100, Florian Tham wrote:
> The Amanda CONNECT command has been updated to establish an optional
> fourth connection [0]. Previously, a CONNECT command would look like:
> 
>     CONNECT DATA port0 MESG port1 INDEX port2
> 
> nf_conntrack_amanda analyses the CONNECT command string in order to
> learn the port numbers of the related DATA, MESG and INDEX streams. As
> of amanda v3.4, the CONNECT command can advertise an additional port:
> 
>     CONNECT DATA port0 MESG port1 INDEX port2 STATE port3
> 
> The new STATE stream is not handled, thus the connection on the STATE
> port cannot be established.
> 
> The patch adds support for STATE streams to the amanda conntrack helper.
> 
> [0] https://github.com/zmanda/amanda/commit/3b8384fc9f2941e2427f44c3aee29f561ed67894#diff-711e502fc81a65182c0954765b42919eR456

Applied, thanks.
