Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0354CA9ECF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 00:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F363208CB
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 00:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OG3qsF2N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfKBAM3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:12:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727806AbfKBAM2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 20:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572653547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=24Z5Dmk2W6pqkfE5O4Ag7+iuU/YlK1vTn8paqS2R4cA=;
        b=OG3qsF2NLWqu7qY1pnZoQR2cMKf79yy6IXF/oVInIj5vmtGk8yrH4ptmDQi9AXfsH/Fnfr
        TspDXLVFdQ59eOzydfW2IGDQnpfrmVN1RBheZlfh1RYKppsSH8VVj/8V90wOGB5iz+mHz9
        cHXR04u8UU0MBcNRgZ/Qxzjoc/O9maI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-A386n-YoNOuG8d2P2CqRzg-1; Fri, 01 Nov 2019 20:12:25 -0400
Received: by mail-wr1-f70.google.com with SMTP id z9so6496950wrq.11
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2019 17:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=imZgvp23lfZ+nv681BvgXkR6J3pvu0v66299B/OZGnI=;
        b=VrURfMEA9KapKJ5Fk5tMDb/wPSj78eu6REv1xTHdkOVwvA+Ir0D8eCl95iyZmE3aq8
         VtfivyZkzsYTmdyELtQbMqImiBulroDctaDe7rJ3hBP+dkdg/NTHdpG9iAJfZ7qtx4l+
         t2jRV/drChi663xM5kQFqdoSYYCYejLOY/c4mYToK1NtQ06NxOA/xcVhahcZju1aTT7I
         FHMVNlKXJ90k33kPC2uLgV96AOy5vAcGb6e5JTMpXk+Xf+34Or8rIQcEo1gGx9NyAde1
         Ul3XIFsz8k7xoL2qY1jYmRxDCR2eE86DzYFaAyhgWKTnlMwFi8MLHVZWPCEYPBb+iZ+D
         jKbQ==
X-Gm-Message-State: APjAAAXfkDMKr5QYsPwoNKbHj9jSVNHVtWOXe9e8Bz5qdihRlOGHhJ0A
        U6VPShsPa497PuWUq3lfArWsVS6SOQdHFSYTKHCBGVWsRTVtb64WwIDf1LPLuU9xYnWAxO05A4q
        3Kd4EC2aCcTFaOJOvVn7AvL36s3UN
X-Received: by 2002:a05:6000:350:: with SMTP id e16mr13725126wre.276.1572653544507;
        Fri, 01 Nov 2019 17:12:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzrrgm+aZgrekUoxbZhWGa28h831L3PmKrlzPbLge7raoNp6P+19vb+UswK4a+j1f1IkqU1Bg==
X-Received: by 2002:a05:6000:350:: with SMTP id e16mr13725109wre.276.1572653544302;
        Fri, 01 Nov 2019 17:12:24 -0700 (PDT)
Received: from raver.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id z189sm13915168wmc.25.2019.11.01.17.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:12:23 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] icmp: add helpers to recognize ICMP error packets
Date:   Sat,  2 Nov 2019 01:12:03 +0100
Message-Id: <20191102001204.83883-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191102001204.83883-1-mcroce@redhat.com>
References: <20191102001204.83883-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: A386n-YoNOuG8d2P2CqRzg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add two helper functions, one for IPv4 and one for IPv6, to recognize
the ICMP packets which are error responses.
This packets are special because they have as payload the original
header of the packet which generated it (RFC 792 says at least 8 bytes,
but Linux actually includes much more than that).

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/linux/icmp.h   | 15 +++++++++++++++
 include/linux/icmpv6.h | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 2d8aaf7d4b9e..81ca84ce3119 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -20,4 +20,19 @@ static inline struct icmphdr *icmp_hdr(const struct sk_b=
uff *skb)
 {
 =09return (struct icmphdr *)skb_transport_header(skb);
 }
+
+static inline bool icmp_is_err(int type)
+{
+=09switch (type) {
+=09case ICMP_DEST_UNREACH:
+=09case ICMP_SOURCE_QUENCH:
+=09case ICMP_REDIRECT:
+=09case ICMP_TIME_EXCEEDED:
+=09case ICMP_PARAMETERPROB:
+=09=09return true;
+=09}
+
+=09return false;
+}
+
 #endif=09/* _LINUX_ICMP_H */
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index a8f888976137..ef1cbb5f454f 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -46,4 +46,18 @@ extern void=09=09=09=09icmpv6_flow_init(struct sock *sk,
 =09=09=09=09=09=09=09 const struct in6_addr *saddr,
 =09=09=09=09=09=09=09 const struct in6_addr *daddr,
 =09=09=09=09=09=09=09 int oif);
+
+static inline bool icmpv6_is_err(int type)
+{
+=09switch (type) {
+=09case ICMPV6_DEST_UNREACH:
+=09case ICMPV6_PKT_TOOBIG:
+=09case ICMPV6_TIME_EXCEED:
+=09case ICMPV6_PARAMPROB:
+=09=09return true;
+=09}
+
+=09return false;
+}
+
 #endif
--=20
2.23.0

