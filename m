Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411069;
	b=V42B5s2+Ddtah2FVEwJsOag3e0E27qmc05acyLyI40pZBmj2DTAqvPDN12orU2Z+GeXA
	 3CTEBiDLV1tOPMzUqX4klJCYNo78FFfR6abAKIijEjPhni620mibP0vyakHru3kaaay9I
	 28DgeNLxupPnJbSbrVECD37SITcudZSC1n/XFcuVOLKNEa9Ln9rSv3dq/ytKl0scLhvsd
	 i1OASgYlfSVbqpgsJVRbZuT4MvZGiq83C4ilWj70JlHGol8BIojgBeaDkVMwS/VP114S9
	 SPhOVBe0vVdDrR11xL3WGzS8bjHS5wD1+cZiR0EMBLm7VLNz6m/9REvbLKDgdt2caUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411069;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=aKVTJ6VHTj8+75gfz8g3P/hFdQjzl62kguU8hEm2lF0=;
	b=oyxzIVlPFzSoWWr9udaisf10W8GnN8WY0mqmirf6XH+HLbTM8cnRGxrSTALZzoqsYRJ+
	 L+1DxxNIfeHs9XDFV60aMTPbFSIKzzTXb7Z5x52QHvojqB1wN7z80SefLLz5dWbj1zigS
	 q4T0UJjj1Ore2uBd7N3fwwGf/Lp0/Tg0GcO48fmzSC9oGPBzld3k4G7k86ugs2aA7QOgN
	 Eb4fKs+lS2Yn+RH3gBazYa54vprI/5CHsqrgvLuQW5hCm5/YuO6C2sXt5VjkeweQHIqmr
	 M888dP3FkZrmq7N2prDZpmBHwXosoJJfoUkqKjCh29IyNyn5oqT4LnJVNijQreGDpOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=mf7qXHqg;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA36606A33E
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 15:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDA36606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=mf7qXHqg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aKVTJ6VHTj8+75gfz8g3P/hFdQjzl62kguU8hEm2lF0=; b=mf7qXHqguloao7ggStAlEcZZZg
	gh77HytCFHXjoYq8gkZ+I+CM4KE2SCaId1vaykmpi6EuNRdu0UJt37G6bOOUREt3FymUpVM2izIF+
	BHUYRiuYZ2keS1YBZDaOIzkwZwAcPwtjhiuNTSWRpGAjLOXrWzR+L+8kJTDlMt76mNeKJp+WCDNLi
	yuPh9ym/f1ZBq51Pn+Bm27biEf2qju+OvGnQDnWik1cSAfSK85rFBbjIZAJqx67zBOM0nJF/g9+AK
	lk7YcZZLk6OfbWcplMzlgn+2Ipst9WwgW7/ey+jY14AVvQd2Nt72Qp6ge1iDUT+rgooODOR2Z8BYb
	izrgmqrw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRAHr-000000005rf-2ApC;
	Wed, 11 Nov 2026 16:30:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Yaron Shragai <yshragai.firmware@gmail.com>
Subject: [libmnl PATCH] include: libmnl.h: Add explicit casts to macros for C++
Date: Wed, 11 Nov 2026 16:30:54 +0100
Message-ID: <20261111153054.44763-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
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

C++ does not like implicit casts of void pointers, make them explicit
there. After adjusting similar cases in example source files, these are
the only needed header adjustments needed to compile them with g++.

Reported-by: Yaron Shragai <yshragai.firmware@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1156
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libmnl/libmnl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 9c032807097f7..2c18e50e6026d 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -146,12 +146,12 @@ extern bool mnl_attr_ok(const struct nlattr *attr, int len);
 extern struct nlattr *mnl_attr_next(const struct nlattr *attr);
 
 #define mnl_attr_for_each(attr, nlh, offset) \
-	for ((attr) = mnl_nlmsg_get_payload_offset((nlh), (offset)); \
+	for ((attr) = (struct nlattr *)mnl_nlmsg_get_payload_offset((nlh), (offset)); \
 	     mnl_attr_ok((attr), (char *)mnl_nlmsg_get_payload_tail(nlh) - (char *)(attr)); \
 	     (attr) = mnl_attr_next(attr))
 
 #define mnl_attr_for_each_nested(attr, nest) \
-	for ((attr) = mnl_attr_get_payload(nest); \
+	for ((attr) = (struct nlattr *)mnl_attr_get_payload(nest); \
 	     mnl_attr_ok((attr), (char *)mnl_attr_get_payload(nest) + mnl_attr_get_payload_len(nest) - (char *)(attr)); \
 	     (attr) = mnl_attr_next(attr))
 
-- 
2.54.0

