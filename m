Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A134C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516BD213F2
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfDHWjF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:39:05 -0400
Received: from mail.us.es ([193.147.175.20]:56088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfDHWjE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 18:39:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4E433066A3
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:39:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B535CDA705
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:39:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AAE05DA702; Tue,  9 Apr 2019 00:39:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABE08DA70C;
        Tue,  9 Apr 2019 00:39:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 00:39:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 822D84265A31;
        Tue,  9 Apr 2019 00:39:00 +0200 (CEST)
Date:   Tue, 9 Apr 2019 00:39:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] netfilter: connmark: introduce savedscp
Message-ID: <20190408223900.jizstw6bhjwt2w63@salvia>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
 <20190324142314.92539-2-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324142314.92539-2-ldir@darbyshire-bryant.me.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Kevin,

On Sun, Mar 24, 2019 at 02:23:45PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> savedscp is a method of storing the DSCP of an ip packet into conntrack
> mark.  In combination with a suitable tc filter action (conndscp but may
> end up being integrated into connmark) DSCP values are able to be stored
> on egress and restored on ingress across links that otherwise alter or
> bleach DSCP.
> 
> This is useful for qdiscs such as CAKE which are able to shape according
> to policies based on DSCP.
> 
> Ingress classification is traditionally a challenging task since
> iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
> lookups, hence are unable to see internal IPv4 addresses as used on the
> typical home masquerading gateway.
> 
> The ingress problem is solved by the tc filter, but the tc people didn't
> like the idea of tc setting conntrack mark values, though they are ok
> with reading conntrack values and hence restoring DSCP from conntrack
> marks.
> 
> x_tables CONNMARK with the new savedscp action solves the problem of
> storing the DSCP to the conntrack mark.
> 
> It accepts 2 parameters.  The mark is a 32bit value with usually one
> bit set.  This bit is set when savedscp saves the DSCP to the mark.
> This is useful to implement a 'one shot'
> iptables based classification where the 'complicated' iptables rules are
> only run once to classify the connection on initial (egress) packet and
> subsequent packets are all marked/restored with the same DSCP.  A mark
> of zero disables the setting of a status bit/s.
> 
> The mask is a 32bit value of at least 6 contiguous bits and represents
> the area where the DSCP will be stored.
> 
> e.g.
> 
> iptables -A QOS_MARK_eth0 -t mangle -j CONNMARK --savedscp-mark 0x01000000/0xfc000000
> 
> Would store the DSCP in the top 6 bits of the 32bit mark field, and use
> the LSB of the top byte as the 'DSCP has been stored' marker.

I'd prefer we explore how to express this in nftables, I think the
main problem here is that we do not support for datatype compatibility
/ casting yet, hence dscp cannot be assign to the mark. But we only
need to update userspace code to achieve this.

Thanks.
