Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4167C56202
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520E2207DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="FsK7RUlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgJ2Pqy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:46:54 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:36887 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgJ2Pqx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 11:46:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id DAC086740143;
        Thu, 29 Oct 2020 16:39:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1603985992; x=1605800393; bh=xRuPV/l7NL
        NXoljQEV8Tie9ps+k7hc4kRVsEyosrFFg=; b=FsK7RUlQxilBgf2Z8xGPH6PRkv
        VoIskAhxrQDFk4L1vsZOOHSJYOeGDvteHsERm2++k2RfTBjwTAbqUY++zht7LClw
        Bc7/LeUFlhgRfLMnFZRi4Mw2NkO2JC4LwDRFEoXR0UZemOtXQJJeQ98Ct87qTch+
        xcGUVqsL6iHp7WUK4=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 29 Oct 2020 16:39:52 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id DD2156740148;
        Thu, 29 Oct 2020 16:39:49 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D0B58340D5B; Thu, 29 Oct 2020 16:39:49 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/4] netfilter: ipset: Update byte and packet counters regardless of whether they match
Date:   Thu, 29 Oct 2020 16:39:46 +0100
Message-Id: <20201029153949.6567-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201029153949.6567-1-kadlec@netfilter.org>
References: <20201029153949.6567-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

In ip_set_match_extensions(), for sets with counters, we take care of
updating counters themselves by calling ip_set_update_counter(), and of
checking if the given comparison and values match, by calling
ip_set_match_counter() if needed.

However, if a given comparison on counters doesn't match the configured
values, that doesn't mean the set entry itself isn't matching.

This fix restores the behaviour we had before commit 4750005a85f7
("netfilter: ipset: Fix "don't update counters" mode when counters used
at the matching"), without reintroducing the issue fixed there: back
then, mtype_data_match() first updated counters in any case, and then
took care of matching on counters.

Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
ip_set_update_counter() will anyway skip counter updates if desired.

The issue observed is illustrated by this reproducer:

  ipset create c hash:ip counters
  ipset add c 192.0.2.1
  iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP

if we now send packets from 192.0.2.1, bytes and packets counters
for the entry as shown by 'ipset list' are always zero, and, no
matter how many bytes we send, the rule will never match, because
counters themselves are not updated.

Reported-by: Mithil Mhatre <mmhatre@redhat.com>
Fixes: 4750005a85f7 ("netfilter: ipset: Fix "don't update counters" mode =
when counters used at the matching")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 6f35832f0de3..7cff6e5e7445 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -637,13 +637,14 @@ ip_set_match_extensions(struct ip_set *set, const s=
truct ip_set_ext *ext,
 	if (SET_WITH_COUNTER(set)) {
 		struct ip_set_counter *counter =3D ext_counter(data, set);
=20
+		ip_set_update_counter(counter, ext, flags);
+
 		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
 		    !(ip_set_match_counter(ip_set_get_packets(counter),
 				mext->packets, mext->packets_op) &&
 		      ip_set_match_counter(ip_set_get_bytes(counter),
 				mext->bytes, mext->bytes_op)))
 			return false;
-		ip_set_update_counter(counter, ext, flags);
 	}
 	if (SET_WITH_SKBINFO(set))
 		ip_set_get_skbinfo(ext_skbinfo(data, set),
--=20
2.20.1

