Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDFCC28D16
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9BDC20859
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ZTrYmGKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbfFJMYV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 08:24:21 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:45151 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389823AbfFJMYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 08:24:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8B656CC00F3;
        Mon, 10 Jun 2019 14:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1560169457; x=1561983858; bh=VVrZAlSB0B
        svuZwSTCrGk3lgxoE6urp3djsHwJB4wd4=; b=ZTrYmGKDlPo0FR3NSBIbIBOSeo
        bk8grK1p3lYk9uvlT8dWHJTASAxu+mi0TLbs1dkzVgA7JR4gADK72vcMqTTsCvbB
        6+xJGlGbJ/26F7iKMNX6BBQeeSJlyvt77zFmPDgFUss2AHSgDwPGCFT38nDgtzfQ
        TjZgry17Gh68uggmk=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 3B646CC00EE;
        Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 1F6D222577; Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] ipset: Fix memory accounting for hash types on resize
Date:   Mon, 10 Jun 2019 14:24:15 +0200
Message-Id: <20190610122416.22708-7-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
References: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

If a fresh array block is allocated during resize, the current in-memory
set size should be increased by the size of the block, not replaced by it=
.

Before the fix, adding entries to a hash set type, leading to a table
resize, caused an inconsistent memory size to be reported. This becomes
more obvious when swapping sets with similar sizes:

  # cat hash_ip_size.sh
  #!/bin/sh
  FAIL_RETRIES=3D10

  tries=3D0
  while [ ${tries} -lt ${FAIL_RETRIES} ]; do
  	ipset create t1 hash:ip
  	for i in `seq 1 4345`; do
  		ipset add t1 1.2.$((i / 255)).$((i % 255))
  	done
  	t1_init=3D"$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset create t2 hash:ip
  	for i in `seq 1 4360`; do
  		ipset add t2 1.2.$((i / 255)).$((i % 255))
  	done
  	t2_init=3D"$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset swap t1 t2
  	t1_swap=3D"$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"
  	t2_swap=3D"$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset destroy t1
  	ipset destroy t2
  	tries=3D$((tries + 1))

  	if [ ${t1_init} -lt 10000 ] || [ ${t2_init} -lt 10000 ]; then
  		echo "FAIL after ${tries} tries:"
  		echo "T1 size ${t1_init}, after swap ${t1_swap}"
  		echo "T2 size ${t2_init}, after swap ${t2_swap}"
  		exit 1
  	fi
  done
  echo "PASS"
  # echo -n 'func hash_ip4_resize +p' > /sys/kernel/debug/dynamic_debug/c=
ontrol
  # ./hash_ip_size.sh
  [ 2035.018673] attempt to resize set t1 from 10 to 11, t 00000000fe6551=
fa
  [ 2035.078583] set t1 resized from 10 (00000000fe6551fa) to 11 (0000000=
0172a0163)
  [ 2035.080353] Table destroy by resize 00000000fe6551fa
  FAIL after 4 tries:
  T1 size 9064, after swap 71128
  T2 size 71128, after swap 9064

Reported-by: NOYB <JunkYardMail1@Frontier.com>
Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory=
 for userspace")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 01d51f775f12..623e0d675725 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -625,7 +625,7 @@ mtype_resize(struct ip_set *set, bool retried)
 					goto cleanup;
 				}
 				m->size =3D AHASH_INIT_SIZE;
-				extsize =3D ext_size(AHASH_INIT_SIZE, dsize);
+				extsize +=3D ext_size(AHASH_INIT_SIZE, dsize);
 				RCU_INIT_POINTER(hbucket(t, key), m);
 			} else if (m->pos >=3D m->size) {
 				struct hbucket *ht;
--=20
2.20.1

