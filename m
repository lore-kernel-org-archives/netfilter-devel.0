Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FEEC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 04:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA99120801
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 04:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgFIExZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 00:53:25 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39456 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgFIExY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 00:53:24 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail106.syd.optusnet.com.au (Postfix) with SMTP id C95355AAB0C
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 14:53:20 +1000 (AEST)
Received: (qmail 32307 invoked by uid 501); 9 Jun 2020 04:53:15 -0000
Date:   Tue, 9 Jun 2020 14:53:15 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Rick van Rein <rick@openfortress.nl>
Cc:     Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Subject: Re: Extensions for ICMP[6] with sport, dport
Message-ID: <20200609045315.GO23132@dimstar.local.net>
Mail-Followup-To: Rick van Rein <rick@openfortress.nl>,
        Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
References: <5EDE75D5.7020303@openfortress.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5EDE75D5.7020303@openfortress.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=RSmzAf-M6YYA:10 a=VwQbUJbxAAAA:8
        a=f7-7dTWf0CiTSok2Vj4A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 08, 2020 at 07:31:01PM +0200, Rick van Rein wrote:
> Hello Patrick McHardy / NFT,
>
> I'm using NetFilter for static firewalling.  Ideally with ICMP, for
> which I found that a minor extension might be helpful, adding selectors
> for icmp|icmp6|l4proto sport|dport.  This avoids painstaking detail to
> carry ICMP, and may be helpful to have mature firewalls more easily.
> Would you agree that this is a useful extension?
>
> Interpretation of IP content is valid for error types; for ICMP, those
> are 3,11,12,31, for ICMP6, those are 1,2,3,4; this should be checked
> elsewhere in the ruleset.  The code supports "l4proto" selection of ICMP
> with the same rules as TCP et al.  (But a better implementation of
> "l4proto" in meta.c would skip IP option headers and ICMP headers with
> error types to actually arrive at layer 4, IMHO).
>
> A sketch of code is below; I am unsure about the [THDR_?PORT] but I
> think the "sport" and "dport" should be interpreted in reverse for ICMP,
> as it travels upstream.  That would match "l4proto sport" match ICMP
> along with the TCP, UDP, SCTP and DCCP to which it relates.  It also
> seems fair that ICMP with a "dport" targets the port at the ICMP target,
> so the originator of the initial message.
>
>
> If you want me to continue on this, I need to find a way into
> git.kernel.org and how to offer code.  Just point me to howto's.  I also
> could write a Wiki about Stateful Filter WHENTO-and-HOWTO.
>
>
> Cheers,
>  -Rick
>
>
> struct icmphdr_udphdr {
> 	struct icmphdr ih;
> 	struct udphdr uh;
> };
>
> const struct proto_desc proto_icmp = {
> 	???
>         .templates      = {
> 		???
> 		/* ICMP travels upstream; we reverse sport/dport for icmp/l4proto */
>                 [THDR_SPORT]            = INET_SERVICE(???sport", struct
> icmphdr_udphdr, uh.dest  ),
>                 [THDR_DPORT]            = INET_SERVICE(???dport", struct
> icmphdr_udphdr, uh.source),
> 		// Unsure about these indexes???
>         },
> 	???
> };
>
> struct icmp6hdr_udphdr {
> 	struct icmp6hdr ih;
> 	struct udphdr uh;
> };
>
>
> const struct proto_desc proto_icmp6 = {
> 	???
>         .templates      = {
> 		???
> 		/* ICMP travels upstream; we reverse sport/dport for icmp6/l4proto */
>                 [THDR_SPORT]            = INET_SERVICE(???sport", struct
> icmphdr_udphdr, uh.dest),
>                 [THDR_DPORT]            = INET_SERVICE(???dport", struct
> icmphdr_udphdr, uh.source),
> 		// Unsure about these indexes???
>         },
> 	???
> };
Hi Rick,

Usually people submit patches to netfilter-devel using git format-patch and
git send-email.

You should submit patches against the nf-next tree, which you can clone from
git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Cheers ... Duncan.
