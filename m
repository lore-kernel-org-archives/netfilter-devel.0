Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7381B140E5F;
	Fri, 28 Feb 2025 02:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708555; cv=none; b=qFUHn6APUVBPjX8C7PeW6WmrmIBfA55Th3uLxp2hTywbCIlqRgsjFHbQLudDWZT7bzkbY+yZr37ciAJKo9rwHJUEzYGF+vdmsP/knKODx2CE393int7tJ+yJOqKtgHJYEtXl2zDJDv7LU87QKwt1UYJsF3a5zZv6LvEI0IopRUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708555; c=relaxed/simple;
	bh=7aXQGxqBnGBVomTgWjndFPyhUKxp6YcF8yQM4y03MzE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqJ9MOUDsDRhiZqizPuAgOzg1KFjoIIQStpvcQAR1uR592jsREKRhFXc570/Y/ybspCq82qJ9LsFDOT8OU0QLN0Ax/ruyQgbG59yl7/cBvlg8DjjHCFsMgBq/Qylll7Y5uiOKflIEzjTc2jb8xkoa0mQmT6mjqSVKNbER6quRXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0th/sWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0th/sWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFDDC4CEDD;
	Fri, 28 Feb 2025 02:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740708555;
	bh=7aXQGxqBnGBVomTgWjndFPyhUKxp6YcF8yQM4y03MzE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L0th/sWWHGU3L3ZB4L4y9cOzD8ByR6pb7+el6BvGsXLUQ8iqm6AEhKVmCMM0SSSbk
	 yxRLSqd/t3znZTsdxXcUSj3O1jq9dUnMd1m/OcuNnJ3Ke107rfyH8mwXjNpJoIcV7W
	 Iml0gPtdfeIFLn9DFnTYhtlj+UsFUcezC77UgAQ12XwIZOzmL7TG/KQfGrJVv+MS/T
	 CUWT8KIb6lSF7c+Uc2JF3DugJOodiS/lWvBJXFxpza2vn5ZXDMb9xszU4d58GZPuTN
	 FAepguvrmXrScWdc3m25CSbbATulrU+oy5Gd0w9ngI3XOqjq+uvIR4O8xV4AjXuzID
	 Dym3U7UP3jeGA==
Date: Thu, 27 Feb 2025 18:09:13 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko
 <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu
 <roopa@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>, Matthias
 Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Joe
 Damato <jdamato@fastly.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, Vladimir Oltean <olteanv@gmail.com>, "Frank
 Wunderlich" <frank-w@public-files.de>, Daniel Golle
 <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v7 net-next 03/14] netfilter: bridge: Add conntrack
 double vlan and pppoe
Message-ID: <20250227180913.6248bbd3@kernel.org>
In-Reply-To: <20250225201616.21114-4-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
	<20250225201616.21114-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Feb 2025 21:16:05 +0100 Eric Woudstra wrote:
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph;

W=1 C=1 GCC build gives us:

net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through ../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h, ../include/linux/netfilter_bridge.h):
include/uapi/linux/if_pppox.h:153:29: warning: array of flexible structures

I'm guessing it doesn't like that hdr has a zero-length array which
overlaps proto.

Looks like kernel code doesn't current need those arrays.
Could you submit something like the diff below first, and then rebase on top?
CC hardening folks on the submission.

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 2ea4f4890d23..3a800af4e987 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -881,7 +881,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
        skb->protocol = cpu_to_be16(ETH_P_PPP_SES);
 
        ph = skb_put(skb, total_len + sizeof(struct pppoe_hdr));
-       start = (char *)&ph->tag[0];
+       start = (char *)ph + sizeof(*ph);
 
        error = memcpy_from_msg(start, m, total_len);
        if (error < 0) {
diff --git a/include/uapi/linux/if_pppox.h b/include/uapi/linux/if_pppox.h
index 9abd80dcc46f..29b804aa7474 100644
--- a/include/uapi/linux/if_pppox.h
+++ b/include/uapi/linux/if_pppox.h
@@ -122,7 +122,9 @@ struct sockaddr_pppol2tpv3in6 {
 struct pppoe_tag {
        __be16 tag_type;
        __be16 tag_len;
+#ifndef __KERNEL__
        char tag_data[];
+#endif
 } __attribute__ ((packed));
 
 /* Tag identifiers */
@@ -150,7 +152,9 @@ struct pppoe_hdr {
        __u8 code;
        __be16 sid;
        __be16 length;
+#ifndef __KERNEL__
        struct pppoe_tag tag[];
+#endif
 } __packed;
 
 /* Length of entire PPPoE + PPP header */
-- 
pw-bot: cr
