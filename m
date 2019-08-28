Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCC1C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309422342A
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfH1Iae (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:30:34 -0400
Received: from correo.us.es ([193.147.175.20]:43014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfH1Iad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:30:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A539EE34CB
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2019 10:30:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ADC3DA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2019 10:30:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3009AA7EC8; Wed, 28 Aug 2019 10:30:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2702CCA0F3;
        Wed, 28 Aug 2019 10:30:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 28 Aug 2019 10:30:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 00D4A4265A5A;
        Wed, 28 Aug 2019 10:30:27 +0200 (CEST)
Date:   Wed, 28 Aug 2019 10:30:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v5] meta: add ibrpvid and ibrvproto support
Message-ID: <20190828083029.5r7t77x6yrrzp7ah@salvia>
References: <1566567928-18121-1-git-send-email-wenxu@ucloud.cn>
 <20190826102615.cqfidve47clkhzdr@salvia>
 <989de2f9-c66b-aae1-ce39-50baffd98a2b@ucloud.cn>
 <20190826143733.fmbwf3gfm2r5ctf7@salvia>
 <ec59e03a-5c09-e803-2b85-11b6052b9406@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec59e03a-5c09-e803-2b85-11b6052b9406@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 27, 2019 at 11:10:29AM +0800, wenxu wrote:
> 
> On 8/26/2019 10:37 PM, Pablo Neira Ayuso wrote:
> > On Mon, Aug 26, 2019 at 09:51:57PM +0800, wenxu wrote:
> >> 在 2019/8/26 18:26, Pablo Neira Ayuso 写道:
[...]
> >> The br_vlan_get_proto returns vlan_proto in host byte order.
> > Then, that's why ethertype datatype does not work, because it expects
> > this network byteorder.
>
> So should I add new vlanproto datatype for this case? Or  Convert
> the vlanproto to network byteorder in  kernel like what
> NFT_META_PROTOCOL did?

Yes please, send me a patch to fix for nf.git to get
NFT_META_BRI_IIFVPROTO in sync with NFT_META_PROTOCOL, ie. use network
byte order.
