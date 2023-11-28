Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="L6NcaLUG"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B277AFA9
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 13:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FjYXymakU1IN6RRsLTqBiUwWOt+nl4d93b72L1uH/dE=; b=L6NcaLUGupRBA75+JqUt34M/ds
	IKlZ9DFKodVofDeDHibM//uiNzrZPY8Br3xDShU3Lv8jFEr41I3GwAygjXhycvkiJphl0uLoxnioN
	K/uuIwDy5lLTB7tmwHJtOfVmg0D0EAeTjJV8bATy5OgGGPqP0HhYySGr7Vtb+BTWB1mjhTnmjud/j
	3Au4DA8HtvRQ6Mh5BKlJVNAfAR9A/zdlavSJ50HULDQydFXbV/qKcgfirSU5qFPkbN6WsjaQsYjco
	4A08KIFoW1jXh+MEvua/8PHoPrHReVKJS3f7nqtlT6Y7/QiVwOxOmZF/+Dn0Hm/dkncP8P8fEKN2k
	tuZ/xBtw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r85PF-0003ye-4Z
	for netfilter-devel@vger.kernel.org; Tue, 28 Nov 2023 22:14:09 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] libxtables: xtoptions: Fix for garbage access in xtables_options_xfrm()
Date: Tue, 28 Nov 2023 22:26:30 +0100
Message-ID: <20231128212631.811-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231128212631.811-1-phil@nwl.cc>
References: <20231128212631.811-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocation of the temporary array did not account for a terminating NULL
entry, causing array boundary overstepping in the called
xtables_merge_options(), causing spurious errors in extension parameter
parsing.

Fixes: ed8c3ea4015f0 ("libxtables: Combine the two extension option mergers")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index e27223e339cb2..433a686c2b595 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -93,12 +93,13 @@ xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 	for (num_new = 0; entry[num_new].name != NULL; ++num_new)
 		;
 
-	mp = xtables_calloc(num_new, sizeof(*mp));
+	mp = xtables_calloc(num_new + 1, sizeof(*mp));
 	for (i = 0; i < num_new; i++) {
 		mp[i].name	= entry[i].name;
 		mp[i].has_arg	= entry[i].type != XTTYPE_NONE;
 		mp[i].val	= entry[i].id;
 	}
+
 	merge = xtables_merge_options(orig_opts, oldopts, mp, offset);
 
 	free(mp);
-- 
2.41.0

