Return-Path: <SRS0=EOB0=AN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43770C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jul 2020 09:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28CD720702
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jul 2020 09:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGBJSd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 05:18:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36016 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgGBJSd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 05:18:33 -0400
Received: from madeliefje.horms.nl (unknown [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 7980F25B81D;
        Thu,  2 Jul 2020 19:18:31 +1000 (AEST)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 9D6FA37F2; Thu,  2 Jul 2020 11:18:29 +0200 (CEST)
Date:   Thu, 2 Jul 2020 11:18:29 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        YangYuxi <yx.atom1@gmail.com>
Subject: Re: [PATCH net-next] ipvs: allow connection reuse for unconfirmed
 conntrack
Message-ID: <20200702091829.GB6691@vergenet.net>
References: <20200701151719.4751-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701151719.4751-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 01, 2020 at 06:17:19PM +0300, Julian Anastasov wrote:
> YangYuxi is reporting that connection reuse
> is causing one-second delay when SYN hits
> existing connection in TIME_WAIT state.
> Such delay was added to give time to expire
> both the IPVS connection and the corresponding
> conntrack. This was considered a rare case
> at that time but it is causing problem for
> some environments such as Kubernetes.
> 
> As nf_conntrack_tcp_packet() can decide to
> release the conntrack in TIME_WAIT state and
> to replace it with a fresh NEW conntrack, we
> can use this to allow rescheduling just by
> tuning our check: if the conntrack is
> confirmed we can not schedule it to different
> real server and the one-second delay still
> applies but if new conntrack was created,
> we are free to select new real server without
> any delays.
> 
> YangYuxi lists some of the problem reports:
> 
> - One second connection delay in masquerading mode:
> https://marc.info/?t=151683118100004&r=1&w=2
> 
> - IPVS low throughput #70747
> https://github.com/kubernetes/kubernetes/issues/70747
> 
> - Apache Bench can fill up ipvs service proxy in seconds #544
> https://github.com/cloudnativelabs/kube-router/issues/544
> 
> - Additional 1s latency in `host -> service IP -> pod`
> https://github.com/kubernetes/kubernetes/issues/90854
> 
> Fixes: f719e3754ee2 ("ipvs: drop first packet to redirect conntrack")
> Co-developed-by: YangYuxi <yx.atom1@gmail.com>
> Signed-off-by: YangYuxi <yx.atom1@gmail.com>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Thanks, this looks good to me.

Reviewed-by: Simon Horman <horms@verge.net.au>

Pablo, could you consider applying this to nf-next?
