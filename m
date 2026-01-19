Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F409A270552
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 06:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=103.117.158.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804739; cv=pass; b=GMdiij26QwJ8ToPysq0vNAuzeq7A4SvxzYVlf8xOCI70puSPvX6lBX5oqTxthkznPDfTyoPSvw7B2ci+S6NgPS7/tV9tzYo2v4FCdlOMNlZt8E7jW3RlLDOmfMxMhgfmxT0iklEwAPOJMPU+EqQmtN27CeG7SZBokqsxcYiVHcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804739; c=relaxed/simple;
	bh=fEhaqK+fzB5PHZVmOyCZRiBx7k/3CMNRhcpPDuhfbYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aKNxC4Skx1X83e5rDk2oAZOZbzvWsyjK8kxCEEfQZwN/aF1YJWc/H3ACe0Rd6NY7JrA3P4CoHXQyaEDn3MtEzPmszqhY96gDYN1J+LjZ9k5mVtWYVyrp2UD327sb55/D4ArM0NQmVCX+PkAJZDNUaVEo27gy3QOBZkyJMQ9zrjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in; spf=pass smtp.mailfrom=zohomail.in; dkim=pass (1024-bit key) header.d=zohomail.in header.i=kshitiz.bartariya@zohomail.in header.b=OaV/p7Vz; arc=pass smtp.client-ip=103.117.158.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.in header.i=kshitiz.bartariya@zohomail.in header.b="OaV/p7Vz"
ARC-Seal: i=1; a=rsa-sha256; t=1768804668; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=eH67j+FiWu1bq90lddCqF7Pah0xd7vPXwrpu2s1TtWd2+VLux78plPlewUDltStc1i74/W7eXz7r+zqHqgPKnqfADMfBJCJ8l3h8bTmIZENI5dEljRS5e4xNn0F0ZKAjcanK/EaXwObLV+D9SlGRdHABxJ2EOuKDdJ/cWQEHKCA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1768804668; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=S1DYyxhh8r1LOgubjCvsaO9OllBcKvtcT+22BlOLsTI=; 
	b=Ny7Ql9UHFAmdH0mf0W3z+KO/jFg2Rz8518Bav11gVuXfICKp10e3Mozi0rzcU5HOPCbQ7dImJ+zZCCBEnD/ku7j6uKR98rGSFfL8kglkLIwDaK27KPBaoN1xelmbIKiHxpsh+jCiwQctSqQXkbHfb4utSlNV1yK+Lg19KKYF4C0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=kshitiz.bartariya@zohomail.in;
	dmarc=pass header.from=<kshitiz.bartariya@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1768804668;
	s=zoho; d=zohomail.in; i=kshitiz.bartariya@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=S1DYyxhh8r1LOgubjCvsaO9OllBcKvtcT+22BlOLsTI=;
	b=OaV/p7VzBXviFAWMUZGBYczvKVsn4DcSUicktZ1QKVeOw9zjziYVOfUmPr+pVDOk
	lrVRWIDmvRQSzLzXRdWf3doLiNfLmMGonoXynJJRgfag3LEbqiGN1D22xV1ic0dPmKZ
	Ec+4oJJlLXik8Wl3hKrBq5zthG/JDyRMLi7GVg1k=
Received: by mx.zoho.in with SMTPS id 1768804661659312.3357861596362;
	Mon, 19 Jan 2026 12:07:41 +0530 (IST)
From: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
Subject: [PATCH net-next] netfilter: arptables: use xt_entry_foreach() in copy_entries_to_user()
Date: Mon, 19 Jan 2026 12:07:04 +0530
Message-ID: <20260119063704.12989-1-kshitiz.bartariya@zohomail.in>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace the manual offset-based iteration with xt_entry_foreach(),
thereby removing FIXME. The byte offset semantics and user ABI
are preserved.

Signed-off-by: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
---
 net/ipv4/netfilter/arp_tables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..9f82ce0fcaa5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -684,12 +684,11 @@ static int copy_entries_to_user(unsigned int total_size,
 
 	loc_cpu_entry = private->entries;
 
-	/* FIXME: use iterator macros --RR */
-	/* ... then go back and fix counters and names */
-	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
+	num = 0;
+	xt_entry_foreach(e, loc_cpu_entry, total_size) {
 		const struct xt_entry_target *t;
 
-		e = loc_cpu_entry + off;
+		off = (unsigned char *)e - (unsigned char *)loc_cpu_entry;
 		if (copy_to_user(userptr + off, e, sizeof(*e))) {
 			ret = -EFAULT;
 			goto free_counters;
@@ -707,6 +706,7 @@ static int copy_entries_to_user(unsigned int total_size,
 			ret = -EFAULT;
 			goto free_counters;
 		}
+		num++;
 	}
 
  free_counters:
-- 
2.50.1 (Apple Git-155)

