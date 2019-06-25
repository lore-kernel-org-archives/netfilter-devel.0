Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CB4C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 16:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA2B2080C
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 16:16:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kaechele.ca header.i=@kaechele.ca header.b="TQWinRU5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFYQQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 12:16:33 -0400
Received: from mail.fetzig.org ([54.39.219.108]:48138 "EHLO mail.fetzig.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfFYQQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 12:16:33 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: felix@fetzig.org)
        by mail.fetzig.org (Postfix) with ESMTPSA id D466B80864;
        Tue, 25 Jun 2019 12:16:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kaechele.ca;
        s=kaechele.ca-201608; t=1561479390;
        bh=7QYrrw7/DTCMoH8nxpsCueBjCLJqYkxemNKpDBg1LyM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TQWinRU5mnw/d7B2lUM+12k2f+VZuuf+727mZCSqJoXkU773OtzVz6LyNoWdv2A/e
         XbM5ve/EbLvqdV0n2ZvYjzn/eyG/SPknKCo10zLt4ZbyItc5k6wJ6+LcpKf3pU5k+i
         4U2xVZHIhDrMPoyDsaNw6Qt6FG309taGU5Kk7OXjG26mMo3AoRgvEBfqVVwlVP+vdu
         mDMsMPrlljxnpvDfDEaPss6R0fTSTBZ8HRW3CUrsKEKEWB9NpAXbB81sHJXJLDCoRy
         g8rAN8VsRR/O+9jFV6zV8VaNh3if9mfdeyS6fqIEBmGudFjvaxJLHBPBlzp17LuocM
         +PfnyvNLYQt6g==
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
 <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca>
 <20190625080853.d6f523cimgg2u44v@salvia>
 <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca>
 <CAKfDRXjun=cVovtn70jxwTc9pa0hhDHUSdZjLHJC1Xw2AMG+rA@mail.gmail.com>
 <04ab8f2d-2b50-8d99-2fa1-837b7acaf417@kaechele.ca>
 <CAKfDRXiwRs5kkZi3AQd4nwqvWtukbrviihH+5s4iHkDfnuW93g@mail.gmail.com>
From:   Felix Kaechele <felix@kaechele.ca>
Message-ID: <25855f46-312b-b263-3cf7-7547e5ece264@kaechele.ca>
Date:   Tue, 25 Jun 2019 12:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfDRXiwRs5kkZi3AQd4nwqvWtukbrviihH+5s4iHkDfnuW93g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------984ECC2918AD5FED8C556427"
Content-Language: de-DE
X-Virus-Scanned: clamav-milter 0.101.2 at pandora.fk.cx
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------984ECC2918AD5FED8C556427
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2019-06-25 11:08 a.m., Kristian Evensen wrote:

> Pablos patch implements
> the first thing that I wanted to try (only read and use version/family
> when flushing), and I see that Nicolas has made some suggestions. If
> you could first try Pablo's patch with Nicolas' changes, that would be
> great as the change should revert behavior of delete back to how it
> was before my change.

Yes, these changes fix the issue for me.

I have attached the patch I used, which is probably the change that 
Pablo initially intended.

Thanks!

Felix

--------------984ECC2918AD5FED8C556427
Content-Type: text/x-patch;
 name="fix-conntrack-delete.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-conntrack-delete.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d2715b4d2e72..061bdab37b1a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1254,7 +1254,6 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 	struct nf_conntrack_zone zone;
 	int err;
 
@@ -1264,11 +1263,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
-					    u3, &zone);
+					    nfmsg->nfgen_family, &zone);
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
-					    u3, &zone);
+					    nfmsg->nfgen_family, &zone);
 	else {
+		u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
+
 		return ctnetlink_flush_conntrack(net, cda,
 						 NETLINK_CB(skb).portid,
 						 nlmsg_report(nlh), u3);

--------------984ECC2918AD5FED8C556427--
