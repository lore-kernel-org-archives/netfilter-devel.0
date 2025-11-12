Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35DE3168E6
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 11:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762947917; cv=none; b=mpXc37WAneYFyP8GhPNveI2sAkNx4tE6PUZlH3+2QFnPBHdwpPjgVhBsoxMuEJ4SEQmyX8bM+bs3fZrC1LfLpY+oCa8+w77M7FCepubbmo5DPs912RUfZpXg8bbawDZqIgObKnuxQLN9CrLuRGhIsUyU2NBn0PQa3LsKe+DR8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762947917; c=relaxed/simple;
	bh=6Kk0RTVwAknqDJ7OniVfMNoMnyRrrvHMFYz6j4bcDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCnCrwQCbBIEGXNopeXuiJvHSbhUTrOLpWemA6JxW7XlEPYh6vtigC0UgueupeJRVZzgkchmo1o5S1RvZG1SrJ/GrLAbrfofVo4gVbDfNnwSAFQ22198xwhoB+FfESNzqKPXF2Ng5nxe5/ycqmEHlAAm36x0+Rm6K57wLe7Hxbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OvI9Rquu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=br8tfQlw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OvI9Rquu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=br8tfQlw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OvI9Rquu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="br8tfQlw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OvI9Rquu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="br8tfQlw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3EF36211D0;
	Wed, 12 Nov 2025 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762947911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tC/tm9WIY+5EzuZLbbkfkxrc7Gz3u4X64HR4x8qSkLk=;
	b=OvI9Rquuscf3wc13OYfJ9cl5wUkSFGu/Spby0xHpRb1aLMNYOVKahCoHw0sjLk+w1H6Gi3
	sdsf1//RR69VjOD6Z+xfp1bEl1edUn8f9AggRaUie/GIchF6/x2lQgVpwn3eRt9iwXuUyp
	SW7peJBKFlQb04RFk1j/wONSq2WvPZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762947911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tC/tm9WIY+5EzuZLbbkfkxrc7Gz3u4X64HR4x8qSkLk=;
	b=br8tfQlwiSQTpprlLXJzybN3hFCo8PAaJcrLb/1MPyB4R5YlGW02u5uQb/1lFLEVoFBwT6
	tUIBcP2brKD01PCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762947911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tC/tm9WIY+5EzuZLbbkfkxrc7Gz3u4X64HR4x8qSkLk=;
	b=OvI9Rquuscf3wc13OYfJ9cl5wUkSFGu/Spby0xHpRb1aLMNYOVKahCoHw0sjLk+w1H6Gi3
	sdsf1//RR69VjOD6Z+xfp1bEl1edUn8f9AggRaUie/GIchF6/x2lQgVpwn3eRt9iwXuUyp
	SW7peJBKFlQb04RFk1j/wONSq2WvPZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762947911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tC/tm9WIY+5EzuZLbbkfkxrc7Gz3u4X64HR4x8qSkLk=;
	b=br8tfQlwiSQTpprlLXJzybN3hFCo8PAaJcrLb/1MPyB4R5YlGW02u5uQb/1lFLEVoFBwT6
	tUIBcP2brKD01PCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A81D33EA61;
	Wed, 12 Nov 2025 11:45:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mLEXJkZzFGmvCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 12 Nov 2025 11:45:10 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/6 nf-next v3] netfilter: xt_connlimit: use nf_conncount_count_skb() directly
Date: Wed, 12 Nov 2025 12:43:48 +0100
Message-ID: <20251112114351.3273-4-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112114351.3273-2-fmancera@suse.de>
References: <20251112114351.3273-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLt5hdgqk6xitctmbg8wz1bcat)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80

The implementation in xt_connlimit can be simplified as now
nf_conncount_count_skb() allow the conncount users to pass the sk_buff.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/xt_connlimit.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 0189f8b6b0bd..848287ab79cf 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -31,8 +31,6 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = xt_net(par);
 	const struct xt_connlimit_info *info = par->matchinfo;
-	struct nf_conntrack_tuple tuple;
-	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
@@ -40,13 +38,8 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	u32 key[5];
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct != NULL) {
-		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	if (ct)
 		zone = nf_ct_zone(ct);
-	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				      xt_family(par), net, &tuple)) {
-		goto hotdrop;
-	}
 
 	if (xt_family(par) == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
@@ -69,10 +62,9 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		key[1] = zone->id;
 	}
 
-	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
-					 zone);
+	connections = nf_conncount_count_skb(net, skb, xt_family(par), info->data, key);
 	if (connections == 0)
-		/* kmalloc failed, drop it entirely */
+		/* kmalloc failed or tuple couldn't be found, drop it entirely */
 		goto hotdrop;
 
 	return (connections > info->limit) ^ !!(info->flags & XT_CONNLIMIT_INVERT);
-- 
2.51.0

