Return-Path: <SRS0=nJ2K=X6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F87C47404
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Oct 2019 23:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3165B222CA
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Oct 2019 23:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfJEXCm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Oct 2019 19:02:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33321 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbfJEXCm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Oct 2019 19:02:42 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 8E7F643E1B6
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 10:02:27 +1100 (AEDT)
Received: (qmail 21499 invoked by uid 501); 5 Oct 2019 23:02:26 -0000
Date:   Sun, 6 Oct 2019 10:02:26 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] BUG: src: Update UDP header length
 field after mangling
Message-ID: <20191005230226.GA6119@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20190927125645.7869-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927125645.7869-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=Pe8eT_EU7uL4CfIqDsEA:9 a=-ctxUYbndnHBRQ3X:21 a=PDfH-RZq3Bgc4uxa:21
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Sep 27, 2019 at 10:56:45PM +1000, Duncan Roe wrote:
> One would expect nfq_udp_mangle_ipv4() to take care of the length field in
> the UDP header but it did not.
> With this patch, it does.
> This patch is very unlikely to adversely affect any existing userspace
> software (that did its own length adjustment),
> because UDP checksumming was broken
> ---
>  src/extra/udp.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/src/extra/udp.c b/src/extra/udp.c
> index 8c44a66..6836230 100644
> --- a/src/extra/udp.c
> +++ b/src/extra/udp.c
> @@ -140,6 +140,8 @@ nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
>  	iph = (struct iphdr *)pkt->network_header;
>  	udph = (struct udphdr *)(pkt->network_header + iph->ihl*4);
>
> +	udph->len = htons(ntohs(udph->len) + rep_len - match_len);
> +
>  	if (!nfq_ip_mangle(pkt, iph->ihl*4 + sizeof(struct udphdr),
>  				match_offset, match_len, rep_buffer, rep_len))
>  		return 0;
> --
> 2.14.5
>
Please consider applying this fix. I have other patches banking up behind it.

There is no need for a corresponding TCP fix because the TCP header does not
contain a length field.

And, there is no IP4 / IP6 concern: udp.c is used by both.

(Also, git pull has stopped working for me: 80s delay then connection reset by
peer).

Cheers ... Duncan.
