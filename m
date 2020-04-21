Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E3EC54FCC
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 00:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722A7206E9
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 00:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORDSmaz4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgDUAm1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 20:42:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726654AbgDUAm0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 20:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587429745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=w0NkVU3TNjEifXe3WvjLawOGXnEzBsNxlMBTVKCi8/I=;
        b=ORDSmaz4Hq5LJFMJfa+vtCRRMEDdICpIV6hYV+0KCSCuPel5P9O71UNX9HyG71GiYn0nwo
        mOlhHgKsRVShx0d6dgKshxvFmyy34d503XwD7J8oxZtvJnyrJEMKyvm+hhreO0JdBmqtaU
        MV2hXmDaf5h6xo/fMhRTRAhly0xM5nE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-fEP0AhMWMdCcPFh_RJfYlQ-1; Mon, 20 Apr 2020 20:42:23 -0400
X-MC-Unique: fEP0AhMWMdCcPFh_RJfYlQ-1
Received: by mail-wm1-f70.google.com with SMTP id f128so718751wmf.8
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 17:42:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=w0NkVU3TNjEifXe3WvjLawOGXnEzBsNxlMBTVKCi8/I=;
        b=IIR5A3/+39NysDHVwnxstDseRKb8kFFgSLEFmRV+g1Qtn9s8OEP+gj3/XOKz+JqG5c
         t1akGz5j1xB7H9IcJWm4SCnVCS/ITmr5eJ5b009U9gB2lEiECdbqNNzH/EvUNOLHBaoW
         HbLvqSv93xkZHu5v83jLtObRFJL4tP3dmnYVnTLllwudawztqDbJJOJCDDJ59MRpS7Sv
         RkQHo9XmZG18879HhLCcwmoKkvjjt/Hd80tMZkMz+BAF5aV+A4A+XzgNIbj1Ls192oSY
         JqDRvXJG2gRVROhya5u6hrMthA22es27IUnGP8TYv3g0cc5bE0Rzdi4kGaALL/AsypEm
         4flg==
X-Gm-Message-State: AGi0PuaMMN6b7ETepRQtk465ytv3XnNQYcOmREH6o+HiNB4Wr+nhExyM
        XaJNNqqSa37UiTcH6BKHfIxCCk6VbfZychygSOFs1DKh9QDIfp/JFhYr4L8rP+yI488CQa37+J3
        XNkayi4R7K06pwwlNO5Q18ckbHoRu
X-Received: by 2002:adf:e986:: with SMTP id h6mr21099176wrm.256.1587429742399;
        Mon, 20 Apr 2020 17:42:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJMHdAwMbl0bBkqMcuJKFNhGzWRL80tdswcBVt5e+NqmPF1FdTfYo2SLeibTLAYgxlSJRwIKg==
X-Received: by 2002:adf:e986:: with SMTP id h6mr21099165wrm.256.1587429742144;
        Mon, 20 Apr 2020 17:42:22 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id q18sm1356366wmj.11.2020.04.20.17.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 17:42:21 -0700 (PDT)
Date:   Tue, 21 Apr 2020 02:42:19 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] netfilter: nat: never update the UDP checksum when it's 0
Message-ID: <335a95d93767f2b58ad89975e4a0b342ee00db91.1587429321.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the UDP header of a local VXLAN endpoint is NAT-ed, and the VXLAN
device has disabled UDP checksums and enabled Tx checksum offloading,
then the skb passed to udp_manip_pkt() has hdr->check == 0 (outer
checksum disabled) and skb->ip_summed == CHECKSUM_PARTIAL (inner packet
checksum offloaded).

Because of the ->ip_summed value, udp_manip_pkt() tries to update the
outer checksum with the new address and port, leading to an invalid
checksum sent on the wire, as the original null checksum obviously
didn't take the old address and port into account.

So, we can't take ->ip_summed into account in udp_manip_pkt(), as it
might not refer to the checksum we're acting on. Instead, we can base
the decision to update the UDP checksum entirely on the value of
hdr->check, because it's null if and only if checksum is disabled:

  * A fully computed checksum can't be 0, since a 0 checksum is
    represented by the CSUM_MANGLED_0 value instead.

  * A partial checksum can't be 0, since the pseudo-header always adds
    at least one non-zero value (the UDP protocol type 0x11) and adding
    more values to the sum can't make it wrap to 0 as the carry is then
    added to the wrapped number.

  * A disabled checksum uses the special value 0.

The problem seems to be there from day one, although it was probably
not visible before UDP tunnels were implemented.

Fixes: 5b1158e909ec ("[NETFILTER]: Add NAT support for nf_conntrack")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/netfilter/nf_nat_proto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 64eedc17037a..a69e6fc16296 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -68,15 +68,13 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 			  enum nf_nat_manip_type maniptype)
 {
 	struct udphdr *hdr;
-	bool do_csum;
 
 	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
-	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
+	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, !!hdr->check);
 
-	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, do_csum);
 	return true;
 }
 
-- 
2.21.1

