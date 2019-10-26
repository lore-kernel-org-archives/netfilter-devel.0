Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E7FCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CA0420867
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfJZLQN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:16:13 -0400
Received: from correo.us.es ([193.147.175.20]:41200 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfJZLQN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:16:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C86A95E4782
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:16:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAE94DA72F
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:16:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B0A85DA8E8; Sat, 26 Oct 2019 13:16:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1E42DA72F
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:16:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:16:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC1D142EE393
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:16:06 +0200 (CEST)
Date:   Sat, 26 Oct 2019 13:16:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] src: add multidevice support for netdev chain
Message-ID: <20191026111608.3ovz7qairinycs3a@salvia>
References: <20191026111300.4407-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026111300.4407-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 26, 2019 at 01:13:00PM +0200, Pablo Neira Ayuso wrote:
> This patch allows you to specify multiple netdevices to be bound to the
> netdev basechain, eg.
> 
>  # nft add chain netdev x y { \
> 	type filter hook ingress devices = { eth0, eth1 } priority 0\; }
> 
> json codebase has been updated to support for one single device with the
> existing representation, no support for multidevice is included in this
> patch.

Please, scratch this patch.
