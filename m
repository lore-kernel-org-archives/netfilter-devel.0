Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=84.16.66.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992754;
	b=bsGeQt6P+DXjppqhmYdoMK5vVHEJ4OoTCk5RJb5wx62WsFbd6LAl1fZ5bSasCMMMCUnz
	 2zs58leCqdLm70D6iFFWLuPs4ua+5t/H6XfZfTFpVrNwmPE+Sy0xyNbAKHtAl0VxRo2Lx
	 7cYp+Y9sMJXeKlx4NVus24hT/LVv430jSwVVd1YPgnt5UsCMXhNtFU239uLmUt4NjyYCI
	 cpYk/DpvMrPtRfORS8MYOyflJovLC1baXRfOJ4usApAfSmv8jeRfHElJiKYePfa4gh//9
	 2YoTICuBW9X/LFUAQv3Ki8N4a2fkYb1lR7sn90/MGLMHqp9LfA3l8mu2m5Pz+B+q4VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992754;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=uV43gelO9bZh+T4pRwPElhJvvLsjgYYZW7WEON9kjys=;
	b=WRUwQC0GFG9uc/bv11UG/FuJ3C7fMb6eJLWanJhTqnhu3hMhxUKIDuBNkbQ8HifJE4th
	 cStlmNIyIJ3byY6CIrrD/+gsac1whbdkDxYf/xCLuSELdri0/8KWMAk1md6thDcn40K8f
	 096zZiUVVn4sOyloVpXv293d5Iijsp3iaLdn7ZjXGze8r7nkRt1C52eSYHg6p7bjmS7kR
	 BDtpDnF35khs6xSChcPGXKpRHGJgItU6Alpah1HGQs7M52eoN3uYIPCG8W6sEN1aG6zKj
	 g4Mm2hm7tibhvqlnWde/GbV+Wuu9Vr0zLoWmn4NIZBUO+vfK6ZCXjr3oX65XTpPJ29A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=OIBF9i7S;
	arc=none smtp.remote-ip=84.16.66.174
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [84.16.66.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C12606A32F
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 19:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77C12606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=OIBF9i7S
Received: from smtp-4-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10::a6b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jLprT46DBzm6Q;
	Fri,  6 Nov 2026 20:19:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1793992745;
	bh=uV43gelO9bZh+T4pRwPElhJvvLsjgYYZW7WEON9kjys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIBF9i7SC5wZxlvclct13V4i8byJqBNXrxRfKFV/ZRFGuXDlixZrOfMUpvynakGxm
	 4jnTbB/ocY0g74xQqinM4BtFSSyPjLp2EjT9H+r6GClmC9MH72YAnmHZlNXKNn/6pv
	 rMpYP6GMuoif29oXiU7LZEbxCuad3lK8aMsjRRVWl04XCkQ2tp+90k03YxbobBKqpL
	 TwUdIRvGb6hpnaC8xuDGQty+uFg9gpSTUHW25UfEWoprS0zVfi3IXiJcTz0gUYLFJP
	 qt6A3aTIXuQyu72O5rjmNMtayUlVoBRfbKo8rGjnrlvcDePntpYdMKXK3pBMwaxoHb
	 nFajEYcfN5W0Q==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jLprS6qC1zSn3;
	Fri,  6 Nov 2026 20:19:04 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl 4/5] nlmsg: do not read past nlmsg_len in mnl_nlmsg_fprintf()
Date: Fri,  6 Nov 2026 20:18:39 +0100
Message-ID: <20261106191841.1645-5-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261106191841.1645-1-florian.stosse@harvester.fr>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
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
X-Infomaniak-Routing: alpha

mnl_nlmsg_fprintf_payload() prints the message in 4-byte words while
i < nlmsg_len. mnl_nlmsg_ok() does not require nlmsg_len to be a
multiple of 4, so for an unaligned length the last word reads up to 3
bytes past the end of the message, and past the buffer when it ends
there.

Only print complete words within nlmsg_len.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---
 src/nlmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index f8eed79..e38f806 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -302,7 +302,7 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
 	if (fdnum != -1)
 		colorize = isatty(fdnum);
 
-	for (i=sizeof(struct nlmsghdr); i<nlh->nlmsg_len; i+=4) {
+	for (i=sizeof(struct nlmsghdr); i + 4 <= nlh->nlmsg_len; i+=4) {
 		char *b = (char *) nlh;
 		struct nlattr *attr = (struct nlattr *) (b+i);
 
-- 
2.56.0.windows.4

