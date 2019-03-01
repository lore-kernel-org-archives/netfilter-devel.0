Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA7DC10F03
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4EF2084D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbfCANdm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:33:42 -0500
Received: from mail.us.es ([193.147.175.20]:52804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbfCANdm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 08:33:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A78EB191915
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:33:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93B2CDA846
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:33:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88E83DA796; Fri,  1 Mar 2019 14:33:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA18ADA846;
        Fri,  1 Mar 2019 14:33:38 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 14:33:38 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8015C4265A4C;
        Fri,  1 Mar 2019 14:33:38 +0100 (CET)
Date:   Fri, 1 Mar 2019 14:33:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] netfilter: bridge: Don't sabotage nf_hook calls for
 an l3mdev slave
Message-ID: <20190301133337.wsbrqzdk3nxukvve@salvia>
References: <20190226002114.2245-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226002114.2245-1-dsahern@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 25, 2019 at 04:21:14PM -0800, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Followup to a173f066c7cf ("netfilter: bridge: Don't sabotage nf_hook
> calls from an l3mdev"). Some packets (e.g., ndisc) do not have the skb
> device flipped to the l3mdev (e.g., VRF) device. Update ip_sabotage_in
> to not drop packets for slave devices too. Currently, neighbor
> solicitation packets for 'dev -> bridge (addr) -> vrf' setups are getting
> dropped. This patch enables IPv6 communications for bridges with an
> address that are enslaved to a VRF.

Applied.
