Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793447081;
	b=UmJdrp21Bo9chLwRjPhzOP27TOGgSv+ERC4rb0Yq3GOepFCMEqf1S9UK5hSbwyiXDmLT
	 nwqnvxgG6jbqmM/kyPXTLUP42a2lJS/Ni5eI3hPBRfco2oru4SvIVfksGq99H+F4LsvsN
	 U0pNSEmdeONcefIJVLjWnW6q4Y9BdYbKIV11jH2Xk9NjUPRM5paR/mvCeX39DMlMzPEpW
	 hVC0y21cofjHKZl1RG3CFbt5DrAely3dUKGwhXQRGA2maHv8WcCiibCmcnU6tA4Q4cvKu
	 vcq13IMMdmgYjy7+VW5vo1A/dQFEKd16KZfeD0/8ngke0dI7LcZbcuotiJjKtbz5/Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793447081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rtkwj2aNUl3brz8yXx8iIT0RsCKwrOnzD6bl0O+bC2c=;
	b=UXl0qUSqWHjlX7O75lDXloPEdtBRID3QE8oQDcXtOzX7MkmqT85+IX02FmAGUwXWQrs0
	 QQimskHkhA3A/bKyBZgVRWIlw9rZX2Dq4Scwob/Op2yBrREGU89gytg71ffXhOvb2o72H
	 4jCTplcKcJrco8t+8T2yDHQAiwM005ZsgshfXdAaQTWCPvQ2LP9jc/gcYmnpBzFGqMz5x
	 FeTAen/phmcV2YKu4XZT7bbYC+MkuJUIM+7qJGBXheKHndaqFL7mL5xO3vrM6+/UTYBho
	 aEYSpubxPGcMkP0B/0X7WWpR39YpHukTOxNDWTxOXbOUAGLDPsBbOwxNm9dI4dxvMNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wNRVhdOE;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5A7606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 11:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E5A7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wNRVhdOE
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso2007532eec.1
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 04:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793447080; x=1794051880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rtkwj2aNUl3brz8yXx8iIT0RsCKwrOnzD6bl0O+bC2c=;
        b=wNRVhdOESz7HbXHeX+lUT7zBM/Sdy2ZaS8KMpUB1CH5uN718jHgBvyAqzp/a71NQj2
         hwRH0UFlempMiiUrS0PvyC+1vDm+mkIOA3ooyAgUuwb1ZJqhvUO3TFLcq8vvqIf8pPoj
         jLRTApohA4ojOpidpJopsOXKXDFTBg2s/Fqjb7mmtvW1sghIXSRwIoOn9yW2fZJBKnrE
         YxsFvXr0FbOXy/OYsec2zRmcm3lc3VEe+zE8GIcVlZSg9C1TQqwNC76BAPKUNdv8dWqX
         gTwb8V4oKiX7PpFaQaLJ0SwVxXzmxXciVC6wsGUVj3LKLLg08kBUf/eJl2isRYfX+wQW
         PxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793447080; x=1794051880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rtkwj2aNUl3brz8yXx8iIT0RsCKwrOnzD6bl0O+bC2c=;
        b=w63koXIA7erZgTYhpNVimw2eUB2O8GVcVyDeYEl6uVFp17GINlxhBbaaRixugeWmwX
         b3hIq6yccl7ueRAkmRbTe1t/16mhTLlkcTbj7r4KDAM6knbrnIuYMA3/4yLYUGkLi6ip
         V7k92pQkOIZ6wvw3aPK9qt3sxzkhtouS5sZkYOjA+8ttnMZgpEWnlo+vVG13uN4Z9woH
         bR+1js6zq+vKj/4rB/j2MJUL/ZeD1TRbR5n7VxFKbw7dwuAuBdo4GKUJzF+4RhK2AbYf
         gB1NFWg3ZltW79vLr2oUg6dH5xNHQObH7tZD1gkTZ5i+mNxGiwgYjWUfgXLT0dUnLrsq
         jQMw==
X-Forwarded-Encrypted: i=1; AKwUvBxEhTk5OdE7Fmn8dnhTJtJbFKnIEJpTgSim+VMqPTq9zzkDjXZnCiklMPE2zf4L1QsW9yroHiYhd8mGm+cxH8U=@vger.kernel.org
X-Gm-Message-State: AFq9FYLGjuI70f9IRR+EPstUfOtPWkrosJhnRluZmQA59bOKVNI96Fei
	5YcMRQzX5jBOshDwaL2ErnB5J1kNH3v6ZB1DNr2A7bqTdBRfZwQ0EMTB
X-Gm-Gg: AYBFou2z4bWQ6OHUyaFBWd8xxc6zNzSEBNLMYldeM6XQkMKbLG1lHzmS/f+R7rT2QBC
	CiIQ11GpjZRwvneY+vRe1KrE0SXFzCNsSXULFM03UK+stXQXbWb3ozkN3vqyAn5hjH+aMwUhzTm
	O4VbTyOfTUuWsLdn31tsYawuJu804urw9qVwaPOLKa1y2jAr1kUJjUwYBJPEVCPBIZbbQI9Jy5c
	O2SkqeToNwi2EByX1Mo+n44YCecYV8HGNAsfcczMFiolyzAUut0mIQ9vAC+u2EIkPmjtAcymYnX
	Wv+R42cWWoFMh9BlgWqELVjvolHjsEVy6VTWJecCgTin13GMqOtdPTPz3bQJ9FhFh6OPq2S6t6C
	30zRTUQxGBIWFA6ubC6YCqBRplGjyKzFVK0Zlf24HdwB+L48pkpZmRKscqi18+YQC7JTKcBVREo
	n3q9zEx7yypu6ASJpoiZwh7WuJdfypfmx0RtfQpPyIXZHrB2K7GJ38gQN4qtP3S7b28rqdvdagC
	BaGp5eLiqTl6kxLYrT0l84PsKnzRtaj/JIgj7aM/C3wHyMcSGunTxA9a6Te+Yalq9LVNhuvdIGU
	3hk9Xjg3nXR59PtMo1O68/lHWF9XZ/nEk9Pb4Tx4HXcsXA==
X-Received: by 2002:a05:693c:2409:b0:369:b75e:d24f with SMTP id 5a478bee46e88-36a423ed004mr7318546eec.24.1793447079579;
        Sat, 31 Oct 2026 04:44:39 -0700 (PDT)
Received: from asahi.tail4da9e3.ts.net ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a98f65sm15960512eec.28.2026.10.31.04.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 04:44:39 -0700 (PDT)
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] netfilter: cthelper: report absent filtered deletes
Date: Sat, 31 Oct 2026 20:44:36 +0900
Message-ID: <20261031114436.31788-1-pocj8ur4in@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nfnl_cthelper_del() returns success when the helper list is empty, even
if the request names a helper that does not exist. The same request
returns -ENOENT when an unrelated helper is present. This makes the
ACK depend on unrelated list contents.

The empty-list success case is needed only for an unfiltered flush.
Return success when a helper was deleted or when neither a name nor a
tuple filter was supplied. Otherwise return the existing -ENOENT.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
---
An arm64 QEMU/KVM kernel received NETLINK_NETFILTER cthelper DEL,
NEW and GET requests. Deleting an absent named helper from an empty
list returned success before the change and -ENOENT afterward.
Deleting an existing helper and an unfiltered empty-list flush kept
their success responses. Tuple-only deletion and packet traffic were
not exercised.

 net/netfilter/nfnetlink_cthelper.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 5b6a09f46903f..774edb07fb1a3 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -700,7 +700,7 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nf_conntrack_tuple tuple;
 	bool tuple_set = false, found = false;
 	struct nfnl_cthelper *nlcth, *n;
-	int j = 0, ret;
+	int ret;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -719,7 +719,6 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 	ret = -ENOENT;
 	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
 		cur = nlcth->helper;
-		j++;
 
 		if (helper_name &&
 		    strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
@@ -738,7 +737,9 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	/* Make sure we return success if we flush and there is no helpers */
-	return (found || j == 0) ? 0 : ret;
+	if (found || (!helper_name && !tuple_set))
+		return 0;
+	return ret;
 }
 
 static const struct nla_policy nfnl_cthelper_policy[NFCTH_MAX+1] = {
-- 
2.55.0

