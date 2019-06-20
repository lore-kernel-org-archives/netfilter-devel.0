Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034DFC4646B
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 10:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E7720675
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 10:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbfFTKUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 06:20:46 -0400
Received: from mail.us.es ([193.147.175.20]:38980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfFTKUq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 06:20:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31B2EEA488
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 12:20:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2424BDA715
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 12:20:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 129F8DA791; Thu, 20 Jun 2019 12:20:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDA58DA705;
        Thu, 20 Jun 2019 12:20:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 12:20:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A7A64265A2F;
        Thu, 20 Jun 2019 12:20:41 +0200 (CEST)
Date:   Thu, 20 Jun 2019 12:20:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian Brauner <christian@brauner.io>
Cc:     syzbot+43a3fa52c0d9c5c94f41@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.hajda@samsung.com,
        airlied@linux.ie, airlied@redhat.com, alexander.deucher@amd.com,
        bridge@lists.linux-foundation.org, christian.koenig@amd.com,
        coreteam@netfilter.org, daniel@ffwll.ch, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, enric.balletbo@collabora.com,
        fw@strlen.de, harry.wentland@amd.com, heiko@sntech.de,
        intel-gfx@lists.freedesktop.org, jani.nikula@linux.intel.com,
        jerry.zhang@amd.com, jonas@kwiboo.se,
        joonas.lahtinen@linux.intel.com, kadlec@netfilter.org,
        laurent.pinchart@ideasonboard.com,
        maarten.lankhorst@linux.intel.com, marc.zyngier@arm.com,
        maxime.ripard@bootlin.com, narmstrong@baylibre.com,
        nikolay@cumulusnetworks.com, patrik.r.jakobsson@gmail.com,
        rodrigo.vivi@intel.com, roopa@cumulusnetworks.com,
        sam@ravnborg.org, sean@poorly.run, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net-next] br_netfilter: prevent UAF in brnf_exit_net()
Message-ID: <20190620102040.g5yqqp3lnka7rn3q@salvia>
References: <20190619170547.6290-1-christian@brauner.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619170547.6290-1-christian@brauner.io>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 07:05:47PM +0200, Christian Brauner wrote:
> Prevent a UAF in brnf_exit_net().

Applied, thanks.
