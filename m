Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899C333260E
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342276; cv=none; b=qYyY9dhATGs3ijMRiJJ07a6IEPJJ5LW7wNIyZwsuztiECP/G1WKUx9npnxj1vhkaIkOsOJXbzO5Wo06xg8DAI0efl1Sz267jqyvAZ6jMFXgZjE/mwgkiHGHCrBxrJUJ92A+6SveJi7T+sHjzAFVlq3QSblhNZA5qXoPQ9D7d6tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342276; c=relaxed/simple;
	bh=KgXHKFfCgAzzmp5Mmkk4m3xwk3TDZyZxZ5RnbbTehNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1KiDWYRzxbOE+ShFoVvMEuvkuabIyqB8+/lRxWn7boEiUusCWmrgmDpVVJuVfJVlulg4Cb4QHINRYyuL4SfV8WP9Icbuf00jmHOQ46RH5EwsJ6KiMA0Zrjjwyw1cYKBvVcpgqvr9hrvU+NbA3/+Y4pJola6VLRiLKD/xhtekuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eg6pttDi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aPeL5cYL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eg6pttDi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aPeL5cYL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eg6pttDi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aPeL5cYL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eg6pttDi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aPeL5cYL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 568C16A93B;
	Mon,  1 Jun 2026 19:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxfWYfyMIxulIuER8jgUwKvQAikXPdHcgLpr57+efSU=;
	b=eg6pttDiflHzL1CKXAqfIzxVG+pS/8Wk9DTd6QdPqsOVHLW9WtfBhAOfs7EGFnw35Y7I5i
	UcHhZAsNim5qs/HgBXU0uf2o9aOZ3PPiXRFTPhZ8LvqCDwBRZHsYkN1uvsiX8WTpyzJGEc
	XO9xaJMFpfHOku5DzRvsC8EpSijjRG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxfWYfyMIxulIuER8jgUwKvQAikXPdHcgLpr57+efSU=;
	b=aPeL5cYLH7R/NLGn820Q+9CQR34bcVR+VwfaQcLRvDqOVZTs9Pk4TyDQgi6mh1U20RJ2Zh
	cbDQ0wmnBBrup7Aw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxfWYfyMIxulIuER8jgUwKvQAikXPdHcgLpr57+efSU=;
	b=eg6pttDiflHzL1CKXAqfIzxVG+pS/8Wk9DTd6QdPqsOVHLW9WtfBhAOfs7EGFnw35Y7I5i
	UcHhZAsNim5qs/HgBXU0uf2o9aOZ3PPiXRFTPhZ8LvqCDwBRZHsYkN1uvsiX8WTpyzJGEc
	XO9xaJMFpfHOku5DzRvsC8EpSijjRG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxfWYfyMIxulIuER8jgUwKvQAikXPdHcgLpr57+efSU=;
	b=aPeL5cYLH7R/NLGn820Q+9CQR34bcVR+VwfaQcLRvDqOVZTs9Pk4TyDQgi6mh1U20RJ2Zh
	cbDQ0wmnBBrup7Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED3F7779A7;
	Mon,  1 Jun 2026 19:31:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kB4kN/vdHWobLwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:31:07 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 8/9 nf-next] netfilter: flowtable: use DEBUG_NET_WARN_ON_ONCE in offload path
Date: Mon,  1 Jun 2026 21:30:48 +0200
Message-ID: <20260601193049.8131-9-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601193049.8131-1-fmancera@suse.de>
References: <20260601193049.8131-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Replace WARN_ON and WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE in the
flowtable core, IP hook, and offload paths. Errors are handled properly
in packet path and in control-plane meaningful errors are returned to
the user. This prevents unnecessary system panics when panic_on_warn=1
is enabled in production systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_flow_table_core.c    | 4 ++--
 net/netfilter/nf_flow_table_ip.c      | 4 ++--
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..6f1a730e3450 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -141,7 +141,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
@@ -534,7 +534,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 			new_timeout = nf_flow_table_tcp_timeout(ct);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			DEBUG_NET_WARN_ON_ONCE(1);
 			break;
 		}
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..abff543d7e4d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -906,7 +906,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		xmit.source = tuplehash->tuple.out.h_source;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
 	xmit.tuple = other_tuple;
@@ -1227,7 +1227,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		xmit.source = tuplehash->tuple.out.h_source;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
 	xmit.tuple = other_tuple;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988b..092d428f9170 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1055,7 +1055,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_stats);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			DEBUG_NET_WARN_ON_ONCE(1);
 	}
 
 	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
@@ -1180,7 +1180,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		}
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
 	up_write(&flowtable->flow_block_lock);
-- 
2.54.0

