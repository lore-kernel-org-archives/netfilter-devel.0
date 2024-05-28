Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0A71753
	for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2024 12:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898271; cv=none; b=LDH/UWGSqx8kEyr0vDkyhERfkJdY4Y0CgEcJnLJQHbuPtBqJ/r6IVCLJkyXkVDvwO6XIOsOx8SmmDJnnRD+7k/W61xH24W7uIAQxe1/vB7/xQNoQK1a1MymSBCQRuRktC/CmFocwwrVvffIZ9+rU6KjBkraaHk7CjO58G3uSRVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898271; c=relaxed/simple;
	bh=D95lppJl+HaeNlllMmgAFnTK8b96AMpUKkShrL7ZhZs=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=QIxMyWWx0TN+DGMeP0fw/MuVVVOe38XyWjhxw1/AVb5alsmdf2LBbhWczgduLdwEraftsAIjXiMrr/BCYH/7JUvEF2fCcg1rjtZvamYt9q5ZEYZwJQS67xepoq/Q/jW6VstmLDuqXK/3MnRRxY2IDfpBYFW0/ZNdeD6GdLcs7nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=p153BPq0; arc=none smtp.client-ip=203.205.221.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="p153BPq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1716898260; bh=j6TjT+Z087DPv4pDiSRhkkWT/YM38Y4xq7DQgHsojow=;
	h=From:To:Cc:Subject:Date;
	b=p153BPq0Wtx9cS9M/RDcgGlwSwaDQqyDlT8EGcBeRa1TVwCoCvT7YSHHOum7zUV9b
	 q/4jnWo0kAdtt4sRzU1sniWAN/A6xBhh7LK39Y2Mo47ntOOJpnARX32A9lOUaf/Sb3
	 ViIITU+yXzhguPhEG3kauXkOPSfCoGLLa0XwAbXA=
Received: from mail.red54.com ([2a09:bac1:7680:99d8::23:1f1])
	by newxmesmtplogicsvrszb9-1.qq.com (NewEsmtp) with SMTP
	id 1E013832; Tue, 28 May 2024 20:07:32 +0800
X-QQ-mid: xmsmtpt1716898052tabb1o1ze
Message-ID: <tencent_AF404BDA8C9E076BA13FEAE795768D9FEF07@qq.com>
X-QQ-XMAILINFO: NmMNZMh6kpah68bwZQ1vtvpVpMlv28wrvASWz5TZ0/GFDU54+JTwH8YdlNZbT4
	 87hakgrpMVbBdPK7JZtoaHZy0jrLCN97Nyvgl75Qx1dBiskYy/iGGlMA87qEe8TbY6RHqP7px5Z6
	 OwfrpLMTmqWzlkOgBIl/9hC0LfH+zrgBG8fcBZi3H2AqiGbMCjnsEMQiLawLNVgOnIkKZr6Cl434
	 HGcwrwxCw2aFJxU85WbF3tLzClwscHO+amPjXBNs4U6xjd50PuOyGm+WF2E34oCCRrK0IW6n80X2
	 2cu178B0nsA1sK6eWjxPWvzvJBKcQJ0wqCCwp2gP5IQlOKqGmd/mKanl0bSBH+TGT77+zyxd/C8x
	 a8FbSTZ3mF0uLwgMYP+tpxSCuviQa6hb/RCse74HKffc8Wbit5jsGS8mXd78dXDs72LQ38A42HUx
	 7UMuFrrAsTox9fmn3+0PX6vyxhQLXpRsjZVGp9uUwNpQWH33Y5Pxbo8uRMbzhJP+eH6iavlen6Nz
	 LCCvVh4aTyRoi/3x1jhlAu+YaEXMIajukj06cs6IKdIANWY3l0eykNuz/06KqZY13+9XW1QALb7h
	 KTT1UanLcyNCLZ+snUy1giFaaMNj7VV9p7yk7xmUh/utpNEROxZCV6eQkICZTDzcFkUjoswA+CAo
	 u6A8fneYaxtB7hBgirWvaPp5n3u49Uyo+P303wmsiXyyLmXVr+bf6R6mYjAtANQhf1gvDbIIn9bU
	 Pg5ixgyCX3KdbpFmkjXQL9hhbPY/LR7P41DPv0GJg+t4jqZBIV9M6BZX2ad4F3mm4psYM4jxXFif
	 iGzLYabpFXT7CECbmrLMdzdXVdDMZf1zL9HLMC6WbGr0+wMIY8qeD7pvs1WC/hJ3ew4bZ+LF9ZI6
	 BT2+46SmfYmSTJF+G97k/kdvNkBXu44lzVlycyGZAhbTvUwEDTn3et+nSDjWeG1y7Zn3z/gQqxYi
	 m1PgAWnDhxnAC6dNSv+odrMWD2rqFPo3mUE83bveJgKto7zLWELQMisJuStS/RR9YSVsbkJesvuo
	 +VnKao7KV4sWTRqyejaD6WB1flLSicbQZ/GbnC6pj1f0UUWA9AvKAWifajgAw=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org
Cc: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [nft PATCH] doc: drop duplicate ARP HEADER EXPRESSION
Date: Tue, 28 May 2024 12:07:28 +0000
X-OQ-MSGID: <20240528120728.164275-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
 doc/payload-expression.txt | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index c7c267daee0c..7bc24a8a6502 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -670,44 +670,6 @@ integer (24 bit)
 netdev filter ingress udp dport 4789 vxlan tcp dport 80 counter
 ----------------------------------------------------------
 
-ARP HEADER EXPRESSION
-~~~~~~~~~~~~~~~~~~~~~
-[verse]
-*arp* {*htype* | *ptype* | *hlen* | *plen* | *operation* | *saddr* { *ip* | *ether* } | *daddr* { *ip* | *ether* }
-
-.ARP header expression
-[options="header"]
-|==================
-|Keyword| Description| Type
-|htype|
-ARP hardware type|
-integer (16 bit)
-|ptype|
-EtherType|
-ether_type
-|hlen|
-Hardware address len|
-integer (8 bit)
-|plen|
-Protocol address len |
-integer (8 bit)
-|operation|
-Operation |
-arp_op
-|saddr ether|
-Ethernet sender address|
-ether_addr
-|daddr ether|
-Ethernet target address|
-ether_addr
-|saddr ip|
-IPv4 sender address|
-ipv4_addr
-|daddr ip|
-IPv4 target address|
-ipv4_addr
-|======================
-
 RAW PAYLOAD EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-- 
2.44.0

