Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E5BC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 23:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B5A206BE
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 23:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGCXSE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 19:18:04 -0400
Received: from correo.us.es ([193.147.175.20]:51836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgGCXSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 19:18:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6E7EED5C5
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 01:18:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6632DA73D
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 01:18:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA134DA789; Sat,  4 Jul 2020 01:18:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25294DA789;
        Sat,  4 Jul 2020 01:17:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 01:17:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 038B64265A2F;
        Sat,  4 Jul 2020 01:17:58 +0200 (CEST)
Date:   Sat, 4 Jul 2020 01:17:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, YangYuxi <yx.atom1@gmail.com>
Subject: Re: [PATCH net-next] ipvs: allow connection reuse for unconfirmed
 conntrack
Message-ID: <20200703231758.GA4238@salvia>
References: <20200701151719.4751-1-ja@ssi.bg>
 <20200702091829.GB6691@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200702091829.GB6691@vergenet.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 02, 2020 at 11:18:29AM +0200, Simon Horman wrote:
> On Wed, Jul 01, 2020 at 06:17:19PM +0300, Julian Anastasov wrote:
> > YangYuxi is reporting that connection reuse
> > is causing one-second delay when SYN hits
> > existing connection in TIME_WAIT state.
> > Such delay was added to give time to expire
> > both the IPVS connection and the corresponding
> > conntrack. This was considered a rare case
> > at that time but it is causing problem for
> > some environments such as Kubernetes.
> > 
> > As nf_conntrack_tcp_packet() can decide to
> > release the conntrack in TIME_WAIT state and
> > to replace it with a fresh NEW conntrack, we
> > can use this to allow rescheduling just by
> > tuning our check: if the conntrack is
> > confirmed we can not schedule it to different
> > real server and the one-second delay still
> > applies but if new conntrack was created,
> > we are free to select new real server without
> > any delays.
> > 
> > YangYuxi lists some of the problem reports:
> > 
> > - One second connection delay in masquerading mode:
> > https://marc.info/?t=151683118100004&r=1&w=2
> > 
> > - IPVS low throughput #70747
> > https://github.com/kubernetes/kubernetes/issues/70747
> > 
> > - Apache Bench can fill up ipvs service proxy in seconds #544
> > https://github.com/cloudnativelabs/kube-router/issues/544
> > 
> > - Additional 1s latency in `host -> service IP -> pod`
> > https://github.com/kubernetes/kubernetes/issues/90854
> > 
> > Fixes: f719e3754ee2 ("ipvs: drop first packet to redirect conntrack")
> > Co-developed-by: YangYuxi <yx.atom1@gmail.com>
> > Signed-off-by: YangYuxi <yx.atom1@gmail.com>
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> 
> Thanks, this looks good to me.
> 
> Reviewed-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, could you consider applying this to nf-next?

Applied, thanks.
