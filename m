Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794080667;
	b=pdsm6SvC6k/gcOjrXQe+Yqimiq6kSrG4qHhKHyd1nyIpOQmbRyzxVQ8rRv1FhgzcwxJF
	 VoF77qaNLVkackO06sMpihLK5H3iW7BSFeGcIef3qATpf9zbe2E/ivGvCyaO5fAg0sC7j
	 EpSuWd9YW+sSbwSSLO5anC3huyFPmvpjpL3wWQ3SqupAMZlbEKt7hwgbVo0tPIH96I0Qv
	 sxvPwTYHAPUAbda4YjeK/xs1tyuhof5D3+lrFmO7VVl9g7J8/7xop/awhj9XPZBxzjPKj
	 PWzfAkXCoTKV9jLxsf+9sdoOOKVgEagebVyW9GPy6S6vwMCp6+YfcLvgSuqEwu4XSNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794080667;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/52ToiBN9dNVSBlBF6GOm1T2xgM8Y/pYcMIFz9gueFc=;
	b=k0m7S8kVB+cjLlrA7gpJDGDZH8hhVg5BeiwfH8YZZr2+P5voYdUs51M8ka0crsNOjECK
	 PA3g0PkhF7B/oqqZwYnrJIt7bVPSZWiO/RWINX560PUvAqGYL3Pc7LHCzlg/awbgpLzK5
	 3yI+GHOgtKBWSfPqJ0Ux1njhslodIKjNXZ+0GkhThBk7E4BFI3N2fDAHK8vnbsrq6p+WV
	 lfoo3umoYuXf3CV1ab6fIHTel9YYv0FovEbsIWC2xrwcwXmPMYZjPVGeqx1bC8Jitb93F
	 1gyxk7ON3uSE6miJ/x+BfvF4HWmd0cuWth3zLZFwhVrMNUsy9wHx2mfDG4hcucKhUuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=ZWpfhOgL;
	arc=none smtp.remote-ip=209.85.161.45
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10FE606A332
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Nov 2026 19:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D10FE606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=ZWpfhOgL
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-714d57774d8so997747eaf.1
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Nov 2026 11:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1794080661; x=1794685461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/52ToiBN9dNVSBlBF6GOm1T2xgM8Y/pYcMIFz9gueFc=;
        b=ZWpfhOgLiyeMYaDDDQoCQsJRcKE3eMyWHW9t57rDdQXxoshjMWoKuWHZ7f9wg4f7WT
         ASaI+pG2VRgjqjkqgywLvKcvhLK3c/SmEHqiTvAL4QguzGdlJdq/qN4pBxtMPA1HfC4N
         ChfLMROpLbkH0s1HjuhlJJuYxu2bYrWZUKyLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794080661; x=1794685461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/52ToiBN9dNVSBlBF6GOm1T2xgM8Y/pYcMIFz9gueFc=;
        b=MjJpUnm3OgHG5WeuI94xwgLaDfnO2VMY6Br8aFl39mikxK5aFWJ81xZx+mSoI49u6u
         fC7kxhJ48FbAx79GUNKpN7eXjbzRgisoor1r2NVAqqdWKkRYq93UObH26mrTBpPXKPHz
         849KUWen0Jyhs3tRW+HtE0/VS1Se2AOtEpdDcx2w2c4e4XyZoicwLEqLDXTLKtxXWbhF
         sIcyiTPioR4m3hG2RsBF0S1u6OpEmai5AS2S+jmzWplxDg3vt2ByqrxHDHzFjVLOcfIn
         aS2/EkYiX7HlTDc9AkkSyCRd14FG1BODIJCJiwPJoscUCEbOKWxTykxw8R2Bc/czy7K5
         RnVg==
X-Gm-Message-State: APuU4Z+JTd4RmpjKYbITVxGjSbO+Cjpe4yqtETKP0vSxa3mnSmDUPznE
	ZkmwJHiH68mGFoggiTOlxhVwkMaOqk6DVSWZov8GSly0+lpgv/9TwLHe1jByPkr71jsRt2W11dK
	SEEAc72o=
X-Gm-Gg: AYBFou0lmUFWpzGmxJnXKCwYME1JG4Eyh5mXJgWd/gPyiQ6NABYFKya+hVB97OZbOhj
	xOkfmSnVLFKnJLJDiWw7DbeaccxgJpkJZqUFBrUhd7kmwiXpNvOQvAEgH7mXXOlwxZi1o19rqI2
	V8VHxTfbc7XAICHpHX3Sbz0gA3qZCwj9dFU377og7v4WHLoLePWhgxU4d+v6ibQS+8zpa8qVQ/+
	s3z9Sz2KbRbXQ7THd8+ikQK2TpT5iKp4L8L03sPuhggYSHv15t4ZgdS+gMnJ562SAae716h5sD2
	QRXh/KHmB4IHO54vY54t5NjBDZ3HzwsxJ5kRpys9KbC/wm75Zx7PhUfpASmT6/O/219AktYwD+H
	zhdSYZB34VMoPx3o8CLjhsoQmmnVMvi58qusUNcLdDL6HfR41p67b4wIhjxgJ7l1oISDWhTnnzs
	yHuoUSRiR3mSPbi9lkQd/2ozmWw1CPqao5S7YTpaiIFPsnfYufP0ECy6E5qqoa2hon6zb5ouB9/
	jJPbHRjTIB9cvOO0xGxbl/qtR7X8ZdyaNqMh2TAzUIH6NCzj7nhvPxCfmZEk5Plx2CqoTr6OUUs
	2ZrzoE6DzfzkTRWvtR+8/BwNUMsq1sgoriTL3iXa63wRG0WL+AT1csRGFEY2mqdmUFfF5ARw2+w
	1A725DNIayg3MoRRnW25nZU1ZHlVm/Q==
X-Received: by 2002:a05:6820:4a02:b0:70e:1dd8:6695 with SMTP id 006d021491bc7-716e78e810fmr3171706eaf.37.1794080660666;
        Sat, 07 Nov 2026 11:44:20 -0800 (PST)
Received: from com-75606.corp.openai.org ([199.47.143.1])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-716e9fa7ec0sm4210706eaf.3.2026.11.07.11.44.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Nov 2026 11:44:20 -0800 (PST)
From: Kyle Zeng <kylebot@openai.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] netfilter: br_netfilter: reject unsafe neighbour devices for DNAT
Date: Sat,  7 Nov 2026 11:44:17 -0800
Message-ID: <20261107194417.99328-1-kylebot@openai.com>
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

The IPv4 and IPv6 bridge prerouting callbacks classify DNAT traffic using
the logical input device saved in skb->dev. The physical input port can
have a different bridge master when prerouting resumes, for example after
an NFQUEUE verdict. Netfilter reassembly can also combine the first
fragment's bridge information with a different fragment's input device.

br_nf_pre_routing_finish_bridge() replaces skb->dev with the port's
current bridge master, but looks up the neighbour using the existing
route. This can put an skb with skb->dev pointing to bridge B on an
unresolved neighbour of bridge A. Deleting B and resolving the neighbour
on A then causes a use-after-free in __dev_queue_xmit().

Before calling the neighbour output method, check that the neighbour
keeps skb->dev alive. A neighbour holds its device, and a VLAN device
also holds its underlying device, so allow a VLAN whose real device is
the bridge. Release the neighbour and drop the skb on a mismatch.

With bridge-nf-filter-vlan-tagged=1 and bridge-nf-pass-vlan-input-dev=1,
the logical input device can be a VLAN such as br0.100. The earlier
route-device comparison then succeeds with br0.100, but this continuation
changes skb->dev to br0. Comparing dst->dev directly with skb->dev would
drop valid VLAN DNAT traffic.

Doing this in the shared continuation covers both protocol families,
including a queue in the remaining bridge prerouting hooks. Leave the
cached-header path unchanged since it does not enqueue the skb.

The issue was found by an LLM.

Fixes: 2948d2ebbb98 ("[NETFILTER]: bridge: fix double POST_ROUTING invocation")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
v1: https://lore.kernel.org/netfilter-devel/20261030042155.73844-1-kylebot@openai.com/
v2:
- Explain the bridge-nf-pass-vlan-input-dev case in the commit message
  and the neighbour-lifetime comment. No functional change from v1.
- Add the Fixes tag for the change to direct neighbour output.

I have a reproducer for this issue and can share via DM

 net/bridge/br_netfilter_hooks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index e15355ff215a..1f5c7f284e0f 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -307,6 +307,19 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 
 			ret = br_handle_frame_finish(net, sk, skb);
 		} else {
+			struct net_device *dev = neigh->dev;
+
+			/* The neighbour queue must keep skb->dev alive.
+			 * With bridge-nf-pass-vlan-input-dev=1, dst->dev may
+			 * be a VLAN device, which holds its underlying bridge.
+			 */
+			if (is_vlan_dev(dev))
+				dev = vlan_dev_real_dev(dev);
+			if (dev != skb->dev) {
+				neigh_release(neigh);
+				goto free_skb;
+			}
+
 			/* the neighbour function below overwrites the complete
 			 * MAC header, so we save the Ethernet source address and
 			 * protocol number.

base-commit: d48723711bae9b8cdc56719c448ba42fef28cbee
-- 
2.55.0.openai.911.g06873a30d2f3

