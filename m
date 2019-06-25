Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F32AC48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 08:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 128D0216C8
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 08:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbfFYIcA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 04:32:00 -0400
Received: from mail.us.es ([193.147.175.20]:59816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfFYIcA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 04:32:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6F04C1A7E
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 10:31:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A83B5114D8C
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 10:31:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A6F72DA708; Tue, 25 Jun 2019 10:31:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 658AD1021A4;
        Tue, 25 Jun 2019 10:31:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 10:31:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F20AF4265A2F;
        Tue, 25 Jun 2019 10:31:54 +0200 (CEST)
Date:   Tue, 25 Jun 2019 10:31:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 04/12] net: sched: add tcf_block_setup()
Message-ID: <20190625083154.jfzhh22zsl3fu2ik@salvia>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-5-pablo@netfilter.org>
 <20190621171603.GF2414@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621171603.GF2414@nanopsycho.orion>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 07:16:03PM +0200, Jiri Pirko wrote:
> Thu, Jun 20, 2019 at 09:49:09PM CEST, pablo@netfilter.org wrote:
> 
> [...]
> 
> > 
> >+static LIST_HEAD(tcf_block_cb_list);
> 
> I still don't like the global list. Have to go throught the code more
> carefully, but why you can't pass the priv/ctx from tc/netfilter. From
> tc it would be tcf_block as it is now, from netfilter something else.

This tcf_block_cb_list should go away at some point, once drivers know
how to deal with multiple subsystems using the setup block
infrastructure. As I said in my previous email, only one can set up
the block at this stage, the ones coming later will hit busy.
