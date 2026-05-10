Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.76.78.106])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954DF36BCF2;
	Sun, 10 May 2026 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.76.78.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778419228; cv=none; b=dn+edi8IjXnIfNH0b8Ru5k1moA8ztf1OsCe9BRpeO7WYYCkwmtHMxe+vqCsbr/S4TdYtW9MUQc6yWBlCv0+C6r4xfqF4oThzWL6t5pr6DiJzJwhmOECXiMYZ6re/Ti4po+3WOGgCRap4tCjfzzQfZuHwkBuTyoanojWCW8LjIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778419228; c=relaxed/simple;
	bh=UbapY3KI+gkAyiEntBakgtjuuZLJZEoq9HYyVBC+qsM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XLlWym50Xb1s700V65r9pwnOqIRYVwzEZ5rGEOLEbZKiz5G89kjw4nnFkdh7GpUOmoFXhVI6msWtQ2lljfCaLdfqUX0Ki8Qi25HnBi+7UAe6HZ7e3VDaGA+axTZAOnZbyDXTWIzO1PbiBdjm3eJlFxgJbSBqWsA4RYbjsfbYzbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=E0VkWARF; arc=none smtp.client-ip=13.76.78.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="E0VkWARF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:MIME-Version:Content-Type:
	Content-Transfer-Encoding; bh=96LyNj7DbuRretXsH7DmfQ4iXb9wOFSTyL
	zb/4mogRs=; b=E0VkWARFpZJb1AWRnkcj9yUqKMGIAWgLdusVnbs24lEuV0j/QJ
	X3ThMJ0jC5g8JdGzJ5RYrizTMAcHNi0FB2qB8OtLtM9ABkk9uQeDloX8O7N+1AKp
	irhPWEcRotqpoiuHttaAsYZn5hNgo848GoV99RTIe0ExG5Zl/vL1NhO+0=
Received: from localhost.localdomain (unknown [101.5.12.38])
	by web3 (Coremail) with SMTP id ygQGZQBHko__hQBqR1B2AQ--.55309S2;
	Sun, 10 May 2026 21:20:00 +0800 (CST)
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	stable@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Subject: [PATCH nft] netfilter: nft_inner: Fix IPv6 inner_thoff desync
Date: Sun, 10 May 2026 21:19:51 +0800
Message-ID: <20260510131953.32790-1-zhaoyz24@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygQGZQBHko__hQBqR1B2AQ--.55309S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF18ZFWxXF13ZFWDWw47twb_yoW8tw1Upa
	9xKayrAFy7Gry7Aws2yayxAr4rAF4DCr47XFWrJry5ZFnI9F15X34fK3y8uFyqyrZrKw4F
	qFZ0yFWYvwn8XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9m1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l
	84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcx
	kEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8
	Ww4UJr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6I
	AqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFylc2xS
	Y4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWkJr1UJwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
	0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0Jj7SdkUUUUU=
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAgIDAWn-tJiYgAAAsg

In nft_inner_parse_l2l3(), when processing inner IPv6 packets, ipv6_find_hdr()
correctly computes the transport header offset traversing all extension headers,
but the result is immediately overwritten with nhoff + sizeof(_ip6h) (40 bytes),
which only accounts for the IPv6 base header. This creates a desync between 
inner_thoff (wrong — points to extension header start) and l4proto (correct
 — e.g., IPPROTO_TCP), enabling transport header forgery and potential firewall
bypass. This issue was found and reproduced with the assistance of GLM 5.1 from
Z.ai, and exists up to Linux 7.1, affecting stable versions from Linux 6.2.

File: net/netfilter/nft_inner.c
Function: nft_inner_parse_l2l3()

```c
thoff = nhoff;
l4proto = ipv6_find_hdr(pkt->skb, &thoff, -1, &fragoff, &fh_flags);
if (l4proto < 0 || thoff > U16_MAX)
    return -1;
if (fragoff == 0) {
    thoff = nhoff + sizeof(_ip6h);  // BUG: overwrites correct thoff
    ctx->inner_thoff = thoff;        // stores WRONG offset
    ctx->l4proto = l4proto;          
}
```

For comparison, the normal (non-inner) IPv6 path correctly preserves 
ipv6_find_hdr()'s result. Removing the incorrect overwrite ensures 
that ipv6_find_hdr()’s calculated transport header offset is preserved,
thereby fixing the desynchronization.

Fixes: 3a07327d10a09 ("netfilter: nft_inner: support for inner tunnel header matching")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Reported-by: GLM 5.1 from Z.ai
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
---
 net/netfilter/nft_inner.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index c4569d4b9..1b3e7a976 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -163,7 +163,6 @@ static int nft_inner_parse_l2l3(const struct nft_inner *priv,
 			return -1;
 
 		if (fragoff == 0) {
-			thoff = nhoff + sizeof(_ip6h);
 			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 			ctx->inner_thoff = thoff;
 			ctx->l4proto = l4proto;
-- 
2.43.0

