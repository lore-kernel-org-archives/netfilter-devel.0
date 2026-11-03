Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793699587;
	b=oFGbJ16F5G2jzQAf7zriX3oNQuk90NFHqVZVHu9NBNwp0Y7EVlcwsmHjPeV7N5BnpwiR
	 T9qb2E8A9pgXp6oimMPChAiXCk3dBzXNYIq4QxufuuD7dg+AAGi/+jQ+PYsviROQR8OBh
	 JW4LT/YmQCYCbU6ScWncWhpG0tgAoS7WcKjOAuhCljr7KSwF0EqjUYT6nok2MkkGbGjHC
	 wnMYsRcHB+fllErAUM11fhw8WLPgqZvAzNwvd11TIkecPPUDH+4LuK0nxoAx1GTE883xL
	 RLMTDMcX+AaChs0/gL2nXj1kF9qP4HeYXzMRGpsO0v8Jc+0uqX6CQ9xHg65s454857Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699587;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FpuQRSe26poIQS4tvUq80P6B8OW0P07tubX87zAYZVs=;
	b=qS8afb5or+RRrU5b4t94tA2JijgkVbIsWsxSBdrD/5tCXdlMX8KVPzLFGHEcm/9rYUPa
	 8AlF+dVawnBibmZxEN8sFc/jd5gtouZacYcTryTOkuOq3/GYjML+u1yt6cYj6xYrp55HW
	 Hul2hfQ5N5KO8eUknNBA9Rc60MrIFpSBr4jgrxVAONiZsITBz4jUtZxrI0JuZqUu0heCQ
	 6TeVQW4WQoofJ5r8Pr66Rq8nWQmxzAq7dJ60SHRR0MvINvRKOfEeRBNEYcpi7Lglc+QeX
	 w81KVkRkRzedSdydCkT48ux3sjjNqYf3YWDdA7RIuvTfxsNFEp6xE9vgZOtARyjms/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RJ6hk963;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B21C606D823;
	Tue,  3 Nov 2026 09:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RJ6hk963
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793699586;
	b=b6cZ49s+DyWI3oJYQDHSpomOx8xM6mXPcCT3AqxltRWKgrGd2Y901X0H0uahkly5J+FJ
	 AAD4nEjV5FftJztqkyDVmdCBy7Y4ER+kzitpACuWSzNB+po/B77esazTeGdjCGB5fCKQI
	 mG7Mohb+BsBAqJqVWhFGzLCYtuFfnAE4mLUJGbiNxg0dRQ3tYWTatAdaciPZTZ9VSnpfd
	 KsJ6rWmymerMyBupzjrXIdrI03jn3xuxrbCylcWYsa3r3mANtr2StVJ58HRrGaNqjgVv1
	 yL/io/3ooG5so4syLZnsgRpsTmxAxAJpP7oYfzY3nSxTNtC1aFrDb4kBIT9+MasvSsg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793699586;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FpuQRSe26poIQS4tvUq80P6B8OW0P07tubX87zAYZVs=;
	b=bU2JiEaCNGz8JcsjeqRFEQuwfD9S656fmKrbR5WdT7jyklw7eFmEZyhw1sz6/n9pUmSj
	 wUX+i356zudffFeeHJVrWgFzhfNu9sn7JwE+fxNGYpBOfprEwKQ2YJffVw9urxOSY2UUG
	 cGo+WoKKUQ1rGPOEfWlL/eQ6ytUK20UDh96LSVVwILmI9JYPX3yYyd5OEQs0xH33N51w+
	 NjzZ3HCAp5oMdegZUSYoj3FcKXjRHy5EeKE0v+LFrfGXXsHjcKykVf55vqWSGW9HnxSup
	 hh2BJExVPL6R9Re2jxYKfGSuh9SX8pg2m7MIs6im3cfaKN61vnZJw7ofOh8+t0dVMgg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 725101F000C1;
	Tue,  3 Nov 2026 09:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699586;
	bh=FpuQRSe26poIQS4tvUq80P6B8OW0P07tubX87zAYZVs=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=RJ6hk963A+ZOmNcVqWuWe3vzTJ+652sfHTAsjGVXYyfPm31jzbJMgozL1cJCE5DR+
	 adNhvCx7nvC9chCivTc8+yPiKqTiPDGP1cXoDPCSv2K47RYK0LKZWt1gDxZ5yURVyY
	 3Fyk0PH9AeR4mav3IZ1MWz+RBEFmlbTJs0vbQ66Mx9gIxWCz4M1fSieOYQ/H3jyjUW
	 dMMlojhmxmpy5e2cCRVS7REAnimQY15EeW4cjp59SeFFoPOLk0xh1ZYSsOUPJC3NVB
	 AV5VXqERkmZf0pH1X3IKXO9kgR161NgaB8R2HuQu7LdkRAHLlLIaE0L97Ha1Wqsc85
	 Ex3pmH0mM7+0w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 027F146866;
	Tue,  3 Nov 2026 09:53:06 +0000 (UTC)
From: =?utf-8?q?Jo=C3=A3o_Silva_via_B4_Relay?= <devnull+jgc3silva.gmail.com@kernel.org>
Date: Tue, 03 Nov 2026 09:52:56 +0000
Subject: [PATCH nf] netfilter: flowtable: do not clear the offload bit
 twice
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqDMBAAvyJ77kJWUYpfKT0k7q5dkEQSaQuSv
 xu8zRxmTiiSTQrM3QlZvlYsxSb06GD5+LgKGjeH3vUTkRtQt/Q7fNgEkzb2jMEOVBqDMvHwFIb
 W7lnU/vf3BVHhXesFPBZVSmsAAAA=
X-Change-ID: 20261103-flowtable-offload-bit-f15bfd1d38ed
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Sven Auhagen <sven.auhagen@voleatech.de>, 
 Oz Shlomo <ozsh@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Jo=C3=A3o_Silva?= <jgc3silva@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2100;
 i=jgc3silva@gmail.com; h=from:subject:message-id;
 bh=Dqh+hiNjtTLDhc1tQ1I4cJIXp18+vbRya6xJ6r5BvN4=;
 b=owEBbQKS/ZANAwAKAfy6ZkDxTpFsAcsmYgBq6a8B/LyRbqX7acF1fsF5gvc8q49GwOjhfgNpz
 fi9/9p/9NmJAjMEAAEKAB0WIQROyCimFhnPgEUkNBX8umZA8U6RbAUCaumvAQAKCRD8umZA8U6R
 bDQjEADIUBI6EVVK5bTcxUq4pZ4jJqoTbvOqdomL/NYoYddHaBmpG+kdqfsyoGnhYDrpGVfgble
 ifEIjjOzp3LfrpgOJR4ItmuUuku6LAVExR1kAHIkJMM4+4brdDI7Qdoij9RdUOUoJaeaU4qIhDe
 U4bx4aUtt3J+vI0yLqpTJUkR5lIbKLYZQMS0V9r08kUFkrb2W3Y1vLpTjcXc8M4XGv2Rzc/s9J2
 0ZX30hPIKk3NJK0JZc+5G9LUNfJjoDJYftkkx9s1PjUN/HO1gfDvOgDf/8Rmc3WJfY+YUaxJTbB
 erJ2IbEiWtHRbl5vjFA4hVa/KHcvQcijOM0GsaPOJhI6TTso0X6FOpwjCUFhmVZNkCKYqCgUoRw
 QUjgkb+OhdeTQeS2vPxGJxCSXSTszJ6UBFwG6cjSlbSpCHczYldr4ByclcV6H/5/0K/EBDAJtXV
 RKDkb7PGmgC33igdk4BeQxSNdLghRL41MlhsadJ/Lo8uOKHS77lqIWQOwcZlkTKvqOcOwxg8k4U
 5U6x2JziJVH/4MMpDOtZaxiFj7IX7TNg3/X7gSUmvAk4KBA3H5AXd1RzfVaZ9sSfrpc+cSZznzW
 yQYvqTB3Q0pHUn+/JyBq80uBFqaCqUEuJppyL4THxLx8N6krbQnpDtpHotWw3Gk2H5STK+t+5JB
 vpIjiuTmuiawWwg==
X-Developer-Key: i=jgc3silva@gmail.com; a=openpgp;
 fpr=4EC828A61619CF8045243415FCBA6640F14E916C
X-Endpoint-Received: by B4 Relay for jgc3silva@gmail.com/default with
 auth_id=1392
X-Original-From: =?utf-8?q?Jo=C3=A3o_Silva?= <jgc3silva@gmail.com>
Reply-To: jgc3silva@gmail.com
Content-Transfer-Encoding: 8bit

From: João Silva <jgc3silva@gmail.com>

An expired hardware flow remains in the flowtable until its asynchronous
hardware deletion completes. Teardown clears IPS_OFFLOAD_BIT, so a packet
can create a replacement flow referencing the same conntrack entry while
the old flow is still waiting for deletion.

The next GC pass calls flow_offload_teardown() on the expired old flow
again, clearing the replacement's offload bit. More packets can then
create additional flows for the same conntrack entry. A pending hardware
work item can also delay deletion and expose the same repeated teardown.

Commit d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of
offload bit") closed this window for software flows by unlinking them in
the same GC pass and made the conntrack state fixup one-shot, but
hardware flows stay linked until NF_FLOW_HW_DEAD is set.

Make clearing IPS_OFFLOAD_BIT part of the existing one-time teardown
transition, alongside the conntrack state fixup. Subsequent teardown calls
must not alter the offload state now owned by a replacement flow.

Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
Signed-off-by: João Silva <jgc3silva@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d72dc8ae47a..709b55b74cc7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -398,9 +398,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	if (test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return;
+
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
-		flow_offload_fixup_ct(flow);
+	flow_offload_fixup_ct(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 

---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261103-flowtable-offload-bit-f15bfd1d38ed

Best regards,
-- 
João Silva <jgc3silva@gmail.com>


