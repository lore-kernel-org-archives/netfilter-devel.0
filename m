Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A4942E8FA
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785175795; cv=none; b=kShSgveF1yMrd7O3UTwZ0t5lNtpHI21F6Tft7iOugEcFfVB0KnWb1qz51oX/Ka0Z79UGsatdUzRO5oAcbO9ci54xlFwmvK2bpDYDQo+o+AefdbHQcVbD1xI9z+ksVUpyXITNWEHniCzs2Wz71NcB6YJQLaGOF5ZVqL9b6pa/MS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785175795; c=relaxed/simple;
	bh=OLBdS9U6vXN7yMZfsPU6bymQTHU8wKH/nuh7cA8y5KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJULV6Tnozdft0+RnL2C6jYMS/p5f2IyxyOMlOM5WBnWMD15dqyYFLxa/bGvyyIwzJB0V85RUcC+n6JO8IXPmA5I9GoSbT+S2J11voBZc2f0asn6RpkxIs6V/1f9KgurBCtpEZGh7YLMEyCu6/nySjvFOJpYcUnHmI7pcn7Ml3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtgUa/hH; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtgUa/hH"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84867f07d63so3699103b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785175794; x=1785780594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLODgO01cDfV9ff6XhKqu+PMyWRibmT2eT2umzWtrJY=;
        b=WtgUa/hHwXEIImvVRq6FqzmANherkbL9RE2uw2ilBSifDzi3vHZm0BF9dEP/ofUhLH
         LgE9D293TuXFfvX3eBEtQ+AAIE6hVMRG2Ab8JeEPUu1QKGudflfQGIR8dsJ2w0ItvRi0
         TCa13hFJK444PE94swn3dzcOK/620guxllp+GweVAB5Sjw2F0g2JBLoY4xk0lAIqgt5E
         +gfkG+mwUc5GhtnszTfycRfs7s2X3q1dxYctQyNI0nRhcKW735mKWBWEZy0j/vpFBGD2
         c390W599NL67Pk4PWvhnr1MtK65zPUOiew8SGRI+YsqyFk/iKXFz3UNYNRaUkkqhAD2r
         b6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785175794; x=1785780594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uLODgO01cDfV9ff6XhKqu+PMyWRibmT2eT2umzWtrJY=;
        b=ZWliXpZn1jBR8x1lT120J2P+RCR31v1+KXxCWft5xkcIZ8R3hY7jSqwIa4BHJbQGnu
         CvDHJZU4fTlMxN7+XDNHjKsc5BsOL20AJDLsGKPgLtGnPDbDuJ/SJmhjXZADWMnlsSMn
         /sUS3j13orvfawfVrUL+fBzehYlrZLfLTlmX6jRj3d1qSJtJbp3pce1zNgOv2PASt05p
         2rrUqZfHXz1J/pqpthA1uA1ZMr+xBfahc6QbX6Zeol5CZ5QR/VbvDKp3W8KxiyfPSA7k
         vinGaUx8Um67Q3GtHkt8zJ01u+Lrn6FWp/XyBhsHguWlZRubbpu2/5tR0qedz6xp7/7U
         FLEw==
X-Gm-Message-State: AOJu0Yz8yiCJu464GIOppAqE2jRwHhBLjm+QQw0AyDx2gOeXdZ+Gxuez
	oNZhmrV9knD23kvlutTtcHCAj6sQNsSgJpWzJref2KyUbAKrdVVz8mDqWUd+2bZEoJYo1Q==
X-Gm-Gg: AR+sD11OgoYvOTFmenCUbqGzIsqcqY4S0GtPk5aK04jxAk1RqGLmNOoJbRu9My/s1MN
	mp/44GZco7B6dwkaRX92AOZmWrLTzmBPzLbX9ZU1d6DcUr7nknU4XwtCIl8OobpYBBbf6jd4neh
	rPdL68LeLd+VTKjIRNJimiU+PsvdgwblSPIaTKZqNwzy50eW2hGySqjPWdlWhPSJAByl9aagqdl
	w7IHnPkyEi/94NdzYYRQpVJY0xFqk6IDDWDYqp8ELOKkVQJOlHfOksigyKwggpi7xZfInOcv2Nr
	6KOAJzNw/7z/srhwZ7mj6UKqtZnV1/Xy8ce/4U6AtHabHYwe48xCazFWH7UASyhzvhCkOMvg0Cc
	6iuuY76Npx5rpk92sQBijV0UPzIrWzxHx4g5fQYaadmyk3uLxJJbqAsF2CuoILocNwp/xr9d2Td
	cB+SRsxaGm/v/m+rYaS7Km
X-Received: by 2002:a05:6a00:a586:b0:83e:b443:965e with SMTP id d2e1a72fcca58-84e5940aefbmr8409625b3a.3.1785175793794;
        Mon, 27 Jul 2026 11:09:53 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5343a9c6sm3494198b3a.51.2026.07.27.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 11:09:53 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	vega@nebusec.ai,
	zihanx@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf 1/1] netfilter: ebtables: avoid unbounded counter allocations
Date: Tue, 28 Jul 2026 02:09:44 +0800
Message-ID: <783a8ef151994345c0c251b5d31a1acb425f8d34.1785131981.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785131981.git.zihanx@nebusec.ai>
References: <cover.1785131981.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zihan Xi <zihanx@nebusec.ai>

EBT_SO_SET_COUNTERS copies only the fixed ebt_replace header before
calling do_update_counters().  update_counters() checks the user supplied
length against the user supplied num_counters, but do_update_counters()
then allocates the temporary counter array before it looks up the table
and before it compares num_counters with the table's real entry count.

EBT_SO_SET_ENTRIES has the same issue when userspace asks for the old
counters back.  do_replace_finish() used repl->num_counters to allocate
the temporary counter array before it looked up the table and before it
validated repl->num_counters against t->private->nentries.

A caller with CAP_NET_ADMIN in its network namespace can therefore pass a
large num_counters value and force a multi-gigabyte vmalloc attempt even
when the named table does not exist or the counter count does not match
the table.  The request is rejected only after the allocation attempt.

Look up the table and validate num_counters against t->private->nentries
before allocating temporary counter arrays.  This keeps valid counter
updates and replacements unchanged while bogus table names and
counter-count mismatches are rejected before any user-sized counter
allocation is attempted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
 net/bridge/netfilter/ebtables.c | 34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 96c9a8f57c87..81496ebf92a9 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1017,16 +1017,6 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	struct ebt_table_info *table;
 	struct ebt_table *t;
 
-	/* the user wants counters back
-	 * the check on the size is done later, when we have the lock
-	 */
-	if (repl->num_counters) {
-		counterstmp = vmalloc_array(repl->num_counters,
-					    sizeof(*counterstmp));
-		if (!counterstmp)
-			return -ENOMEM;
-	}
-
 	newinfo->chainstack = NULL;
 	ret = ebt_verify_pointers(repl, newinfo);
 	if (ret != 0)
@@ -1053,6 +1043,15 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_unlock;
 	}
 
+	if (repl->num_counters) {
+		counterstmp = vmalloc_array(repl->num_counters,
+					    sizeof(*counterstmp));
+		if (!counterstmp) {
+			ret = -ENOMEM;
+			goto free_unlock;
+		}
+	}
+
 	/* we have the mutex lock, so no danger in reading this pointer */
 	table = t->private;
 	/* make sure the table can only be rmmod'ed if it contains no rules */
@@ -1386,25 +1385,27 @@ static int do_update_counters(struct net *net, const char *name,
 			      unsigned int num_counters, unsigned int len)
 {
 	int i, ret;
-	struct ebt_counter *tmp;
+	struct ebt_counter *tmp = NULL;
 	struct ebt_table *t;
 
 	if (num_counters == 0)
 		return -EINVAL;
 
-	tmp = vmalloc_array(num_counters, sizeof(*tmp));
-	if (!tmp)
-		return -ENOMEM;
-
 	t = find_table_lock(net, name, &ret, &ebt_mutex);
 	if (!t)
-		goto free_tmp;
+		return ret;
 
 	if (num_counters != t->private->nentries) {
 		ret = -EINVAL;
 		goto unlock_mutex;
 	}
 
+	tmp = vmalloc_array(num_counters, sizeof(*tmp));
+	if (!tmp) {
+		ret = -ENOMEM;
+		goto unlock_mutex;
+	}
+
 	if (copy_from_user(tmp, counters,
 			   array_size(num_counters, sizeof(*counters)))) {
 		ret = -EFAULT;
@@ -1422,7 +1423,6 @@ static int do_update_counters(struct net *net, const char *name,
 	ret = 0;
 unlock_mutex:
 	mutex_unlock(&ebt_mutex);
-free_tmp:
 	vfree(tmp);
 	return ret;
 }
-- 
2.43.0
