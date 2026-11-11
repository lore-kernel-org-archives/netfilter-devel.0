Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406607;
	b=hDH99xvx2e3UaioE0HN914XQ9LHm52nR/WwL38csZmvAVEMPcY2mkfclfln/EmESHFt/
	 DbHRp29h2ZQv+R3EZ1NXlOj9PbpcR2insd1eBHDACXDxatDf8ajAaoXckLmUjD2hFWv9e
	 IkhPRwbBRvRDQYoxdhtTmY5CE9jC4LiXpbCyjgiluc5EueNQ3DTfLiaagBc58r736qEda
	 RObXzoXZrL2IOlpykwYVKugRqwW+yhvqe+tD65fM0n0E4tb8A87aAv30Rhy/xFIZWfNhc
	 9S07CoE/9fWLqn/gBNChoRrWjI18BOtafcpsaiyyJjAmEfvttguL/HLAmrzv8Pn0Ctw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406607;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=PNaQ6Q4vGpSRfUWx0yC1mdo3/cj4HJ9kzAYecFEBLvE=;
	b=w9FQKgu/VXfqgZQH+lfRy/Zs9BL5fGlhC+XHPugBJBy21Eik5vqvvBszztaRdlU3QVi+
	 +vUa2wKLbZWmT/rha6yklKI0xEaxTyinJqPnApVhYl2rjTKYS/dUsvXQxTtDQ/N9neH49
	 Kw4oFE9wAcA8U6swPXmnkxt/qN6fsXM1hPIva/go2dmvyFupsgahvK5CFRPu+LEIf9Uzf
	 TBYK5AzMj/kFb/WEdqWCfQJmtMzixiG6IGyLf4JTFXZjena/CKy5aoFfRhDZb5nB0DsPR
	 hqaT0ehSLPfgRWSZkov9hC62ksS6+0JFyphhzJJc3HVRppUKBlxdKoiOwgbhiQ7JbBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=vaqSbvOo;
	arc=none smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49506606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 14:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49506606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=vaqSbvOo
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-533797e72e8so19978061cf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 06:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794406605; x=1795011405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PNaQ6Q4vGpSRfUWx0yC1mdo3/cj4HJ9kzAYecFEBLvE=;
        b=vaqSbvOodam9Lh8sl6hGWYWFmFqegHb/nVrcQAs002a9RBJ1hp32LLzLGA+NPmLazp
         T0v3UjOHN3+PYiSnZxQkbO9WsJbpZnEuGuT0bGEqnE8G0eMtzFsrbmoW4kPoQlKKGDl6
         5kpahpb7WhJyfZMPmYEZ9g2LQfyxfPpf4n238=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406605; x=1795011405;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PNaQ6Q4vGpSRfUWx0yC1mdo3/cj4HJ9kzAYecFEBLvE=;
        b=u5Pyxc6//V6l77qqQXyntQypCny1P7FR172V1INY02raZv6z94y4mc00qITQxoA4x4
         tCCtMAn4BBncPOMflPEeo7e+YGSLwIU2s77B3q5UGCCZQwp0fiC6SqQODthM44PN48ph
         Ec0wlNGmdd8yJhYfzRf3O1Ttb6SF7celUsCoyfb0B/JkfM6zEYLN3mSvvTkONqkoLWsY
         DlmzQ+cwoPS06O1MOz2GL7aUV/wotSAikFQINMeo25W7SD7b3hsqWHi1TkwAlGrD/uWO
         QBD/u/vz5/CAaJreehvNxUMbYn4EUWRp6AIDFP98F/ptE5i9QCRnShNFX8xqkl6fMyLj
         D9Qw==
X-Forwarded-Encrypted: i=1; AL+hErEvrF2fKLCO+OrkClTW7oSvOy0v1mPxSfTHuSQXYECSCw0HWPpRZps/qUvEb9xnEa7tUKlkYKq+mTfpeV9X1qw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8+moYn+TLvpB2+Zv2E2DyTvxyvwEGoGYAw/LvlFAM0Zn+3Q3MC
	PAJtajBpOR8hkX+kQg0I7XyU6uNyqd673HhYZ40i/O5Ve0MbidFYViErdCwCwEOugA==
X-Gm-Gg: AYBFou2RBT7pYTHQifND2DWjH5Ca79XUWY3BlYIGxpz43pSr0k40VNHfb9OZz7NGcuo
	uqV7xW3kuF7zCkuBkxfufQYMh1Q1vOnG3r7xNKuAihgecRn9zMm2zRo1TZeKMnQSOAnhIqqpHaC
	wASQLKlf/DVWz4kTX/WyCHj8cruXQWL3xHghkTk7nxXUKxjlKXDNa0Sl1+Aljhmg4dPNubecATs
	wh7T7BRIU3jkOEtt+Z9/ZaNcSceva3LHq0cHGiQFnjtRqVcgiul1KvnXrEvDrBRCchEmRSGsmmh
	9bAWNcbkNB7tFXWgKILovXJXLiBKXvz/12enllnhg04AeC2eIa3MAHzwFrbiYaEl6V47kDGhUmQ
	XCuCyYXbbTq2b33UsDXPfdt8LRNAV9FRht5pbkVGYxUfkDqvhn87iRbI+qykXkhfwmYvA7oI9kD
	ifFR+JHlFJQwlSfZIYlIr3TBhJhw6Qv/O3HQgvhQkLnIrSmSlq6Ur70UKJ95hZ67FGh3R/BB43c
	mCCP9HN44QRM19e2GNQPgP14qRGKTpqYS+KuHfs3IjwHXk+huO9EHFhO5kCpAbgpLfZJiBoeMWM
	lEbep6xy8mz+psoP6mNcdX0r6uyUzMlte4AxdYFAJCEPesAQS1QYh3C8Daft5iHS/L/bt4+CIky
	8rJ6+cPyDFfCoGA==
X-Received: by 2002:a05:622a:1b1d:b0:550:fe12:22da with SMTP id d75a77b69052e-556bd708e0bmr35644631cf.6.1794406604915;
        Wed, 11 Nov 2026 06:16:44 -0800 (PST)
Received: from localhost.localdomain ([64.203.83.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550be2e592sm51505041cf.24.2026.11.11.06.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:16:42 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	bpf@vger.kernel.org,
	Victor Nogueira <victor@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	sashiko-bot@kernel.org
Subject: [PATCH net-next 0/2] net: drop the stale dst when steering to another device
Date: Wed, 11 Nov 2026 09:16:36 -0500
Message-Id: <CORE-9NOG.v1.r0.20261111073528@mojatatu.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patchset is created to address constant whining by both sashikos
about this being an issue when fixing a UAF on a teql issue (entering
v4 now), see the v3 here fixing the teql consumer:
https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/

Two producers steer a packet to a network device of their choosing and
then hand it to the neighbour layer for link-layer resolution:

  1/2 netfilter: the neighbour variant of nft `fwd`, on the netdev egress
      hook
  2/2 bpf: `bpf_redirect_neigh()` when the program supplies the nexthop

Both rewrite `skb->dev` to the target device and leave the skb's dst
pointing at the route the packet arrived through. When the target
device's neighbour for the nexthop is incomplete the packet is parked on
that neighbour's arp_queue, and draining the queue re-looks the neighbour
up from the stale dst. The frame is therefore built with the original
device's link-layer header and then transmitted on the target device: the
packet leaves with another device's addresses, and the sender never
learns that its nexthop was unreachable.

This is explicit: the steer-to-another-device path never worked in this
respect, so there is nothing here to regress. Both producers shipped with
`skb->dev` swapped to the target device and the route's dst still
attached, and the arp_queue drain has re-derived the neighbour from that
dst for as long as either producer has existed; the invariant "the skb's
dst describes where the skb is going", which the routing path keeps when
it steers, was never established for these two entry points. With no
commit to anchor with a `Fixes:` tag and no crash, UAF or lockup
involved, the series targets net-next and does not nominate `Cc: stable`:
a backport would change long-standing redirect behaviour for no
crash-class benefit.

More context: this came out of the review of the fix for a parked skb
being resolved against the wrong device in sch_teql, posted separately and
not part of this series. The neighbour code's queue drain is doing the
right thing there, it re-derives the neighbour from the skb, so the repair
belongs with the producers rather than with the drain path. Both
producers are fixed in the same series so neither is left behind; each
patch stands on its own and carries its own reproduction recipe.

The reproduction for both arms is a pair of veth devices, one of them
with an unresolved neighbour, plus a capture on the target's peer: the
captured frame's source and destination addresses name the device whose
neighbour was used to build it.

Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com
Link: https://lore.kernel.org/netdev/20261026160747.283702-1-horms@kernel.org/
Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/

Jamal Hadi Salim (2):
  netfilter: nft_fwd_netdev: drop the stale dst when steering to a
    device
  bpf: drop the stale dst when redirecting to an explicit nexthop

 net/core/filter.c              | 4 ++++
 net/netfilter/nft_fwd_netdev.c | 1 +
 2 files changed, 5 insertions(+)

-- 
2.43.0

