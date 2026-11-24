Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=132.226.202.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513034;
	b=yPwYy74XzierOBIjFCrejdtXBGBg2Br5uc4fdOZnR079Hdrk+P3wQfWT9xbXYzQZA0Jz
	 S6ZCy9kdkk/tklomZ+gum+fhkWRp19UZZZ0Aq62LGfUNUx9S0Rat6WilHC+zy5Q0X7FqN
	 5psTLaohsXvFteKKG5MfHJuxHQRKKz9sQqNGVgUJc+Vbr3R/iNJNahDYObbzelhKdGcW3
	 k0HO5k718glfm97K91bXeurAo+QElN7SFrbY42pA/vBTX8EubaOmXes6ueSG+S6PhG8Ga
	 7Y+wgyWpd4desiLYDBD85wcdfBULPeclFRIzYWVZNKaI00S1EdG0f/uVDncLuX/+ZZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513034;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=fDwdx8Znh5AV8HNzVBUREM7yT4gioJAtfoqd/3Um3cI=;
	b=kxjHSm8fvAsNcFOW1YQorxAAQWLZ9Ou/l2TryAUygKGgNiL+kcujJ4J+RegSjjXCR+um
	 6td7rt+7658DquVtUyGF2MQ+Ek/C5ms5A1I3bdFhuMP2HxkTD0HU7uZQ6yeCvNzlOcqOJ
	 OyQnjmlWivHkN8NN+qlKrbKCUQJgCyPt9P8bAhokA89Rg7ccdyesaG1h91/9sj16KT5XJ
	 0ow6Xn8JB9fcehFFmxPxv9ijsTyUCrab4iOfA4brmxkc20geVIEqbmfj2Lm640d9KwRHL
	 hwh09AdwpSLuwo0VGB9+sorsiD1CWv9gF+IthlG+dDReWzrq936/AdESdAisT5PxPXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mails.tsinghua.edu.cn;
	spf=pass smtp.mailfrom=mails.tsinghua.edu.cn;
	dkim=pass header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=Mc7E2nY2;
	arc=none smtp.remote-ip=132.226.202.154
Received: from fraori-sdnproxy-3.icoremail.net (fraori-sdnproxy-3.icoremail.net [132.226.202.154])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42866606A321
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 09:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42866606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.a=rsa-sha256 header.s=dkim header.b=Mc7E2nY2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=fDwdx8Znh5AV8HNzVBUREM7yT4gioJAtfo
	qd/3Um3cI=; b=Mc7E2nY2W4fpCUsjxpvJ4FN3G0IbglaVAyRTY5S4Y/8vp0tLmf
	m6b5jJGLuRrRlhdB3TfL8K/NM7R+Vw2ntSOSk7VXVJ4vgfFnQ3F2aBWYcHTLliLN
	aFsQD3m+N2bSZlCP95khXIi0QnTxNh3aAl5yoe5RXqfva+0+zBBZKP/4E=
Received: from s2e.. (unknown [202.112.47.69])
	by web2 (Coremail) with SMTP id yQQGZQD3I2i8WgVre_JjAQ--.27359S2;
	Tue, 24 Nov 2026 17:37:01 +0800 (CST)
From: zhangmh25@mails.tsinghua.edu.cn
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	jianjun@tsinghua.edu.cn,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Subject: Re: [PATCH nf-next v2] netfilter: nf_reject: validate TCP header length before sending resets
Date: Tue, 24 Nov 2026 17:36:54 +0800
Message-Id: <20261124093655.3052561-1-zhangmh25@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <avJuN1cClzssVmi0@chamomile>
References: <avJuN1cClzssVmi0@chamomile>
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
X-CM-TRANSID:yQQGZQD3I2i8WgVre_JjAQ--.27359S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF15Xr15Jry7Cr4xGFWkCrg_yoW5Wry7pa
	yftr1j9rWDGry0kwn2qF48Z345Zrn3Aay3Xay8JF9ayrnYgw1SyF4FqryYgrWUGrs3W34S
	qrWjvrn8AayDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9a14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lw4CEc2x0rVAKj4xxMxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_Gr
	UvcSsGvfC2KfnxnUUI43ZEXa7VUjBMKtUUUUU==
X-CM-SenderInfo: x2kd0wlpkskqxpdlz2oowvx0pjkxthxhgxhubq/1tbiAgABB2sFSC8kdgACsd

From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>

Hi Pablo,

Agreed on not wanting a second tcp_error(). Just to scope what the patch
actually carries: none of the flag / state / window classification, only
the two-condition bounds pair

    oth->doff < sizeof(struct tcphdr) / 4 || tcplen < oth->doff * 4

for the one header field the target itself computes with. The ACK number
of the generated reset is derived as

    seq + syn + fin + segment_len - (doff << 2)

so a data offset that claims more header than the segment carries makes
the subtraction wrap, and the emitted RST carries a garbage ack_seq
(0xffffffd8 for a 20-byte segment with doff = 15). The underflow lives
in nf_reject's own arithmetic: I am not asking conntrack to classify
these segments for me, only that reject not compute its output from a
value it never checked.

The reason the check belongs in nf_reject rather than behind tcp_error()
is that the target already validates its input structurally, independent
of conntrack: the fragment check, the ihl / extension header walk, the
"segment >= sizeof(struct tcphdr)" minimum and the no-RST-for-RST rule
all live in nf_reject, because reject cannot assume a conntrack verdict.
This is the missing bounds pair for the one field left unchecked -- same
class as those, two conditions per family. And on the paths in question
there is nothing to fall back on: a stateless ruleset never instantiates
conntrack (nftables only loads it when a rule references ct or NAT), and
the netdev / inet ingress / bridge reject paths run before it. There,
reject is the code that parses the segment.

Every other consumer of th->doff gates it before use. tcp_v4_rcv() and
tcp_v6_rcv() both reject doff < sizeof(struct tcphdr)/4 before pulling
the full header (net/ipv4/tcp_ipv4.c:2099, net/ipv6/tcp_ipv6.c:1762),
and tcp_error()'s check is the pair quoted above. tcp_v4_send_reset()
even computes the same "skb->len - (th->doff << 2)" ACK arithmetic as
nf_reject (net/ipv4/tcp_ipv4.c:762-763) -- but it only ever sees
segments that passed the tcp_v4_rcv() gate. nf_reject is the one place
left computing with an unchecked doff.

For the record, the declared-length basis (skb_ip_totlen() /
payload_len) is not hardening I am trying to sneak in: it is what makes
the two conditions mean what they say on the netdev ingress and bridge
paths, where the skb is untrimmed and an skb->len based check accepts a
doff that runs past the IP-declared segment (the [High] finding in the
AI review of v1). If you prefer the smaller footprint I can drop that
part and keep only the doff sanity check, at the cost of the
padded-segment ACK skew. And if you would rather not grow nf_reject
along these lines at all, that is fine too -- say the word and I will
withdraw the patch.

Thanks,
Minghao Zhang

