Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C2CECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 16:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D8920872
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 16:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440447AbfJQQME (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:12:04 -0400
Received: from correo.us.es ([193.147.175.20]:52846 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405983AbfJQQMD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 12:12:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E7764A7073
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 18:11:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00620DA72F
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 18:11:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD86D21FF7; Thu, 17 Oct 2019 18:11:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4984DA4CA;
        Thu, 17 Oct 2019 18:11:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 18:11:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 94E7C42EF4E0;
        Thu, 17 Oct 2019 18:11:55 +0200 (CEST)
Date:   Thu, 17 Oct 2019 18:11:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, saeedm@mellanox.com,
        vishal@chelsio.com, vladbu@mellanox.com, ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte
 level
Message-ID: <20191017161157.rr4lrolsjbnmk3ke@salvia>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-4-pablo@netfilter.org>
 <20191016163651.230b60e1@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016163651.230b60e1@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Jakub,

On Wed, Oct 16, 2019 at 04:36:51PM -0700, Jakub Kicinski wrote:
> Let's see if I can recount the facts:
>  (1) this is a "improvement" to simplify driver work but driver
>      developers (Ed and I) don't like it;

Ed requested to support for partial mangling of header fields. This
patchset already supports for this, eg. mangle one single byte of a
TCP port.

>  (2) it's supposed to simplify things yet it makes the code longer;

The driver codebase is simplified at the cost of adding more frontend
code which is common to everyone.

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |  162 +++---------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h |   40 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |   80 ++----
 drivers/net/ethernet/netronome/nfp/flower/action.c   |  191 ++++++--------

>  (3) it causes loss of functionality (looks like a single u32 changing
>      both sport and dport is rejected by the IR since it wouldn't
>      match fields);

Not correct.

tc filter add dev eth0 protocol ip \
        parent ffff: \
        pref 11 \
        flower ip_proto tcp \
        dst_port 80 \
        src_ip 1.1.2.3/24 \
        action pedit ex munge tcp src 2004 \
        action pedit ex munge tcp dst 80

This results in two independent tc pedit actions:

* One tc pedit action with one single key, with value 0xd4070000 /
  0x0000ffff.
* Another tc pedit action with one single key, with value 0x00005000
  / 0xffff0000.

This works perfectly with this patchset.

>  (4) at v5 it still is buggy (see below).

That, I can fix, thank you for reporting.

> The motivation for this patch remains unclear.

The motivation is to provide a representation for drivers that is
easier to interpret. Have a look at the nfp driver and tell me if it
not easier to follow. This is already saving complexity from the
drivers.

Thank you.
