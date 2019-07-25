Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39809C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 056942081B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389959AbfGYKQk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:16:40 -0400
Received: from mail.us.es ([193.147.175.20]:47908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389934AbfGYKQk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:16:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FBD5FB6C0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:16:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E638115111
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:16:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 43FFD11510F; Thu, 25 Jul 2019 12:16:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 032CD115107;
        Thu, 25 Jul 2019 12:16:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 12:16:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9A48C4265A32;
        Thu, 25 Jul 2019 12:16:35 +0200 (CEST)
Date:   Thu, 25 Jul 2019 12:16:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/5] sipport nft_tunnel offload
Message-ID: <20190725101633.ya6kcet6vc4iggim@salvia>
References: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 25, 2019 at 05:46:04PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This series support tunnel meta match offload and
> tunnel_obj ation offload. This series depends on
> http://patchwork.ozlabs.org/project/netfilter-devel/list/?series=120961

Oh, you sent a v2 and I was spending time to review v1 which is now
useful anymore... This is starting to be very confusing :-(
