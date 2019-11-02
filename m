Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360DBCA9ECF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 00:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00339208CB
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 00:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPA2IV4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfKBAMn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:12:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35155 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727297AbfKBAMm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 20:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572653561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xS0gGjv6iMlxX4rkF9w/Sr3jIbDT7i0xNvkGl3SCIG4=;
        b=MPA2IV4Fh8av4MSijNgKjKz7Jmh2UVov3mIDQyL3d7kercgxszBOt7R7CKMOH8DYOIL3qu
        zqy/4WCuGaG2IUv58N7mGHiBVL3d+L0072e/BQo2vuTCdE+Nt7PY3TvaIy39pFEA0MrlfA
        3YV6/DNugc434u3dPCIKa0qKbSqDMs4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-i-UcfKaCN9uRxt0tKM95WQ-1; Fri, 01 Nov 2019 20:12:38 -0400
Received: by mail-wm1-f71.google.com with SMTP id b10so4860062wmh.6
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2019 17:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPhKHvT3az+LN4tzL4Ab13kYC7t6UbHWZLXwUYXDHsw=;
        b=mBOOFHmOcA2W0reRAL7qAcZ2BcxxKQ9j1Z8oVcdxhWCrzuMTNsvoneBDUow+CF5dFg
         FnwwYu9MAIMIysBkTgPkAjPAkR880W55L0pXiWzV+33cQ8Gf1/sfaR6xXGn1Mx0w9toR
         bbceM5yjl/xp1IdPi/yMr4lBZp8TNg+iINFrgk08XYf55ndOqgwSYazfeAJu1tlRfMI7
         8J4ETUjqOOHTXh+0xsVEgnwRS03/C8t881frG8Zm9KABWKkVbZ9xbFCsJOSSk8FQTfqG
         j//fYLbDQMYicwv1U+sxmIpLpDlO8M4i8Cr/Gi4cCzz0nWXivQB+OdysWqOJyF2SyEMT
         bdmA==
X-Gm-Message-State: APjAAAXwoV6ucBQkk7cb6Fu2qKvZ2DStlLkrXMW4exjpdUbb9flqe71E
        F8xssCRFlCUOqn35m0vdA0EyVIuBA6/2YUJ7AJ/OPgcSsxoQb/tynCz0iu8lVPpme+4rOn9E9IK
        HEF64rX3pl027DAjWPtr2OSyGSbmP
X-Received: by 2002:a1c:650b:: with SMTP id z11mr12398842wmb.149.1572653556960;
        Fri, 01 Nov 2019 17:12:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzGzwlL1BmpHGqMa5YujOM+Ri+mxFUH/onLw/RykU/GB1adIBjHhPV9XtS1itc2Amri94aT9g==
X-Received: by 2002:a1c:650b:: with SMTP id z11mr12398815wmb.149.1572653556671;
        Fri, 01 Nov 2019 17:12:36 -0700 (PDT)
Received: from raver.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id c14sm8323774wru.24.2019.11.01.17.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:12:36 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] icmp: remove duplicate code
Date:   Sat,  2 Nov 2019 01:12:04 +0100
Message-Id: <20191102001204.83883-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191102001204.83883-1-mcroce@redhat.com>
References: <20191102001204.83883-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: i-UcfKaCN9uRxt0tKM95WQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The same code which recognizes ICMP error packets is duplicated several
times. Use the icmp_is_err() and icmpv6_is_err() helpers instead, which
do the same thing.

ip_multipath_l3_keys() and tcf_nat_act() didn't check for all the error typ=
es,
assume that they should instead.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/ipv4/netfilter/nf_socket_ipv4.c     | 10 +---------
 net/ipv4/route.c                        |  5 +----
 net/ipv6/route.c                        |  5 +----
 net/netfilter/nf_conntrack_proto_icmp.c |  6 +-----
 net/netfilter/xt_HMARK.c                |  6 +-----
 net/sched/act_nat.c                     |  4 +---
 6 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_so=
cket_ipv4.c
index 36a28d46149c..c94445b44d8c 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -31,16 +31,8 @@ extract_icmp4_fields(const struct sk_buff *skb, u8 *prot=
ocol,
 =09if (icmph =3D=3D NULL)
 =09=09return 1;
=20
-=09switch (icmph->type) {
-=09case ICMP_DEST_UNREACH:
-=09case ICMP_SOURCE_QUENCH:
-=09case ICMP_REDIRECT:
-=09case ICMP_TIME_EXCEEDED:
-=09case ICMP_PARAMETERPROB:
-=09=09break;
-=09default:
+=09if (!icmp_is_err(icmph->type))
 =09=09return 1;
-=09}
=20
 =09inside_iph =3D skb_header_pointer(skb, outside_hdrlen +
 =09=09=09=09=09sizeof(struct icmphdr),
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 621f83434b24..dcc4fa10138d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1894,10 +1894,7 @@ static void ip_multipath_l3_keys(const struct sk_buf=
f *skb,
 =09if (!icmph)
 =09=09goto out;
=20
-=09if (icmph->type !=3D ICMP_DEST_UNREACH &&
-=09    icmph->type !=3D ICMP_REDIRECT &&
-=09    icmph->type !=3D ICMP_TIME_EXCEEDED &&
-=09    icmph->type !=3D ICMP_PARAMETERPROB)
+=09if (!icmp_is_err(icmph->type))
 =09=09goto out;
=20
 =09inner_iph =3D skb_header_pointer(skb,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a63ff85fe141..3f3085ab2832 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2291,10 +2291,7 @@ static void ip6_multipath_l3_keys(const struct sk_bu=
ff *skb,
 =09if (!icmph)
 =09=09goto out;
=20
-=09if (icmph->icmp6_type !=3D ICMPV6_DEST_UNREACH &&
-=09    icmph->icmp6_type !=3D ICMPV6_PKT_TOOBIG &&
-=09    icmph->icmp6_type !=3D ICMPV6_TIME_EXCEED &&
-=09    icmph->icmp6_type !=3D ICMPV6_PARAMPROB)
+=09if (!icmpv6_is_err(icmph->icmp6_type))
 =09=09goto out;
=20
 =09inner_iph =3D skb_header_pointer(skb,
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_con=
ntrack_proto_icmp.c
index 097deba7441a..c2e3dff773bc 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -235,11 +235,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 =09}
=20
 =09/* Need to track icmp error message? */
-=09if (icmph->type !=3D ICMP_DEST_UNREACH &&
-=09    icmph->type !=3D ICMP_SOURCE_QUENCH &&
-=09    icmph->type !=3D ICMP_TIME_EXCEEDED &&
-=09    icmph->type !=3D ICMP_PARAMETERPROB &&
-=09    icmph->type !=3D ICMP_REDIRECT)
+=09if (!icmp_is_err(icmph->type))
 =09=09return NF_ACCEPT;
=20
 =09memset(&outer_daddr, 0, sizeof(outer_daddr));
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index be7798a50546..713fb38541df 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -239,11 +239,7 @@ static int get_inner_hdr(const struct sk_buff *skb, in=
t iphsz, int *nhoff)
 =09=09return 0;
=20
 =09/* Error message? */
-=09if (icmph->type !=3D ICMP_DEST_UNREACH &&
-=09    icmph->type !=3D ICMP_SOURCE_QUENCH &&
-=09    icmph->type !=3D ICMP_TIME_EXCEEDED &&
-=09    icmph->type !=3D ICMP_PARAMETERPROB &&
-=09    icmph->type !=3D ICMP_REDIRECT)
+=09if (!icmp_is_err(icmph->type))
 =09=09return 0;
=20
 =09*nhoff +=3D iphsz + sizeof(_ih);
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 88a1b79a1848..855a6fa16a62 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -206,9 +206,7 @@ static int tcf_nat_act(struct sk_buff *skb, const struc=
t tc_action *a,
=20
 =09=09icmph =3D (void *)(skb_network_header(skb) + ihl);
=20
-=09=09if ((icmph->type !=3D ICMP_DEST_UNREACH) &&
-=09=09    (icmph->type !=3D ICMP_TIME_EXCEEDED) &&
-=09=09    (icmph->type !=3D ICMP_PARAMETERPROB))
+=09=09if (!icmp_is_err(icmph->type))
 =09=09=09break;
=20
 =09=09if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph) +
--=20
2.23.0

