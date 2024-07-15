Received: from mail.he1.boomer41.net (mail.he1.boomer41.net [178.63.148.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D9E433B3
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.148.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721052837; cv=none; b=fQni9Md0fQrtQCTuG3xTswalTmAM0g8ekUXK0MJPyJwVHTVINsYi5eBBIaEcrfT1rLHEFYYBBA5ypyIr9o+hosvfZrweSx8IM7ISm7QEyGeJm7Opu0un0S70fp76FBiNMy38kLD57k7NcvGMBNWctRgkzRxsw/ENskXAUtsU0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721052837; c=relaxed/simple;
	bh=QivCAR+MEiq6lrRvYkYLf5QpIM6FnSXV2PKgRPZkob8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nlEbsxxFKFl3umg+MBIhZXg8GKN7Kw7cxsCM+z7ooVsJ8BMF1U92Jffq7iBQGnXuZlqbBYz89zLInQ7bXNpe6ZqSu/SSk1gDsD8HW5REowsT36EEc7CZ4+pGsA5WpzsfpDxrbaZ14cs0L+ZAyOz9YXUDVsxvWbWHMm01rfiZlLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net; spf=pass smtp.mailfrom=stephan-brunner.net; dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b=Robfd1xd; arc=none smtp.client-ip=178.63.148.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b="Robfd1xd"
From: Stephan Brunner <s.brunner@stephan-brunner.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stephan-brunner.net;
	s=mail; t=1721052825;
	bh=QivCAR+MEiq6lrRvYkYLf5QpIM6FnSXV2PKgRPZkob8=;
	h=From:To:Cc:Subject:Date;
	b=Robfd1xdtDwJjRKu9LI3M9DlDGkSYhJo8rNgEUsT5NscZ8EJms8JUvg0IEMMQatiN
	 CBYouD6/pSf7dt9t1F2qbE7246KC7tGIh95eGCRadeyBQd8AvMuX7041lE0hUKM65F
	 NxzNwm4IQ6IhDHxVhaccl0wP+u/DGLbz8sBZWogpIy5SJrZxR5mdMndBjQg4/t/+ko
	 vvvPONIcbgZclMBWy1ZQzdyg4Cxo3NYpisebVil1DkGNJmhGwve5OMEu5fGre4aQsT
	 +sOSp3G3DHAEnrQamVc+znqqAYYQKY3PNBUnOi3+gQI+bjVgsAueHTbrDdeKlAJfIn
	 9tpO444/r67xv0gdLof6VCAJgzrLJNjPkQMJKlrYX3KuixD0tcYFdWI5QQmYGgxe5M
	 uX3N8vGfrCY6DjzsSDhhTwgMrbzni2GnrcUnDQlQWpmOLMBGt9oIYtKCH34z9W1ouv
	 lgJ3q3ybmrTvwy5XjDdaX5npJvEEjM8YsL0qeruVbi5VBtXl4kOMjPSlKsWSleyt6q
	 KUjR/LATfCLUYvALT/Siq+aFmHbIMzskJxzEallDVxtB1S51qq6u5kRIDshSOSO1Pe
	 BLRHpSYpypdbkUyQxh+8PPmiGUBCvbTYAKqehC8s7+TYchSYAIzyhmOxKrdE/QXWeT
	 hRlyPb2/YLjlmFT7Jwby5aRI=
To: netfilter-devel@vger.kernel.org
Cc: Stephan Brunner <s.brunner@stephan-brunner.net>,
	=?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <reinhard.nissl@fee.de>
Subject: [PATCH] conntrack: tcp: fix parsing of tuple-port-src and tuple-port-dst
Date: Mon, 15 Jul 2024 16:13:42 +0200
Message-ID: <e8786a769b04bbc6e72ff96f1527bc869f4f75af.1721052742.git.s.brunner@stephan-brunner.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As seen in the parsing code above, L4PROTO should be set to IPPROTO_TCP, not the port number itself.

Co-Developed-by: Reinhard Nißl <reinhard.nissl@fee.de>
Signed-off-by: Stephan Brunner <s.brunner@stephan-brunner.net>
---
 extensions/libct_proto_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 27f5833..4681693 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -165,13 +165,13 @@ static int parse_options(char c,
 	case '8':
 		port = htons(atoi(optarg));
 		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_EXPTUPLE_SPORT;
 		break;
 	case '9':
 		port = htons(atoi(optarg));
 		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port); 
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_EXPTUPLE_DPORT;
 		break;
 	}
-- 
2.45.2

