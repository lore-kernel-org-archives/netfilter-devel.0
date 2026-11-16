Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868637;
	b=sjPGs05dndEuEFjbPqXppzjBIhC4SdF9iEp7U0T6dvYCmGk318MHlFKWLmdQoM7M8SEG
	 yuguSK9u3/eNhbB7dl7Q7XShGR9Bq11ksUGLVkk4diFiGhtpn+WDHcW3To3kcEjKcp8TK
	 Flo23wunlbGF6n8p1UOC0YN7ZFFEOXRFmYWyPmtmyFhtlfN8hAqr5nhun0NeD9USd88/e
	 vYeYk1Es5XRoE6RjrzhLTYq8H7jVsLzmKleuPyets8BS49Iac7q5IHaV+4R69FfANbnHo
	 ylz5SsG1KjtBR0cvrOOjyubr+w0ZbYiHhD7/cdu6uYB6qFR8Z72ihEVB3rV1AadFaNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868637;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=MAeAMzdXTUkqBSO1yv5vxvoAR2ovXJnoOQrxhuCEL4k=;
	b=hwzL84W3JaFQK7YhL0grUYo7oGFvNeL6qNLzZg9WIc0DZ616G44xjz4Y4xYmLxLJb2za
	 txg8rn7uI0c+XQOMzYCnTtl7zoVcbwlThDVobwO9h42U4fzeMSfsd0wIHGrjW1sqn0gBk
	 Embm2L1SwFm0DBOLS/MWOaNahfUKuOKeUs1RY1ui68tMQsDSn0/FRpWEr2XfWhTh+b2/c
	 6YhP38OmTou8WqOyXI4h5k+ZqMixJrBVRs0Ms7rKIoo02aTKYINrNUEIa2GcGYngJ/wxC
	 DSJDHJuWUW/0Z5+6tpI4cLXO5UoD9QXNfT6TPwi6q3XFCbTKqD+G8cFa3ROQKyTr31w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BD606A31C;
	Mon, 16 Nov 2026 22:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED4BD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9DE7660D56; Mon, 16 Nov 2026 23:37:14 +0100 (CET)
Date: Mon, 16 Nov 2026 23:37:06 +0100
From: Florian Westphal <fw@strlen.de>
To: info@openservis.cz
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>, Eric Dumazet <edumazet@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [BUG] netfilter: synproxy: server ACK carries TSecr shifted
 twice, rejected by tcp_check_req() since v6.15
Message-ID: <avuFkgYTcgaVISkg@strlen.de>
References: <CAFvzkdAXBNAWcHFNo6akAo63Wd8B_jvhkt=AEmuLR9fgPBEfGg@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFvzkdAXBNAWcHFNo6akAo63Wd8B_jvhkt=AEmuLR9fgPBEfGg@mail.gmail.com>

info@openservis.cz <info@openservis.cz> wrote:
> Possible fix (untested): build the server ACK with TSecr =
> synproxy->its, so that synproxy_tstamp_adjust() brings it to the
> backend's TSval, or keep the generated ACK out of the adjustment.
> 
> We can run a patch through the same lab if that helps.

Please try this patch:

netfilter: synproxy: fix double tsoff application in server ACK TSecr

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -651,6 +651,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	const struct ip_ct_tcp *state;
 	struct tcphdr *th, _th;
 	unsigned int thoff;
+	u32 tsval, tsecr;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
@@ -732,13 +733,18 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 				  NF_SYNPROXY_OPT_WSCALE |
 				  NF_SYNPROXY_OPT_SACK_PERM);
 
-		swap(opts.tsval, opts.tsecr);
+		tsval = opts.tsval;
+		tsecr = opts.tsecr;
+
+		opts.tsval = tsecr;
+		opts.tsecr = tsval - synproxy->tsoff;
 		synproxy_send_server_ack(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
 		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
-		swap(opts.tsval, opts.tsecr);
+		opts.tsecr = tsecr;
+		opts.tsval = tsval;
 		synproxy_send_client_ack(net, skb, th, &opts);
 
 		consume_skb(skb);
@@ -1074,6 +1080,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 	struct synproxy_options opts = {};
 	const struct ip_ct_tcp *state;
 	struct tcphdr *th, _th;
+	u32 tsval, tsecr;
 	__be16 frag_off;
 	u8 nexthdr;
 	int thoff;
@@ -1162,13 +1169,18 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				  NF_SYNPROXY_OPT_WSCALE |
 				  NF_SYNPROXY_OPT_SACK_PERM);
 
-		swap(opts.tsval, opts.tsecr);
+		tsval = opts.tsval;
+		tsecr = opts.tsecr;
+
+		opts.tsval = tsecr;
+		opts.tsecr = tsval - synproxy->tsoff;
 		synproxy_send_server_ack_ipv6(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
 		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
-		swap(opts.tsval, opts.tsecr);
+		opts.tsecr = tsecr;
+		opts.tsval = tsval;
 		synproxy_send_client_ack_ipv6(net, skb, th, &opts);
 
 		consume_skb(skb);
