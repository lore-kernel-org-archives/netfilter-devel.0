Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D2241FA
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2023 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XEeoOOX/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O7qRCxhKyuB1u8HhgJ1eq8aNSfmCbjOZh/I/DAkE4xE=; b=XEeoOOX/QXqq19zGFFcFup3BLM
	hIKWjDKbLQNnyzO4r19XQ76KsBWrWB8LpOoFUeAorozJsiNUsrT3GoZCjREjMeyd9/ENYo9WbO3Qd
	CWA/bl3PR3SbirUlVa8Uu6WNG9KY33Q8XJzsD3wvb4x7Nfz3xz9xFW9EJfFjCDQdZvm+KT7c/9Mdt
	qaOLlH/CyoqRjtXpOz5hcTAHsjsFgZ0x+JIPKRABctzA4ettteUPWliz2ZEF2yVRvKXf7y8MSmhVv
	hEXty0muoD17a8h4UPc+Dj73CUfwwaMPGx87tXz1f6CK9isFCGV1PGWOxDrytvUw9R3pcfjcjYnGH
	KvMzNjjQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGiDk-0002fS-Gv; Fri, 22 Dec 2023 17:17:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] datatype: Initialize rt_symbol_tables' base field
Date: Fri, 22 Dec 2023 17:17:46 +0100
Message-ID: <20231222161747.29265-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ZYV8YnXhwKoDD/o2@calendula>
References: <ZYV8YnXhwKoDD/o2@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is unconditionally accessed in symbol_table_print() so make sure it
is initialized to either BASE_DECIMAL (arbitrary) for empty or
non-existent source files or a proper value depending on entry number
format.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 9ca0516700f81..4d867798222be 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -893,6 +893,7 @@ struct symbol_table *rt_symbol_table_init(const char *filename)
 
 	size = RT_SYM_TAB_INITIAL_SIZE;
 	tbl = xmalloc(sizeof(*tbl) + size * sizeof(s));
+	tbl->base = BASE_DECIMAL;
 	nelems = 0;
 
 	f = open_iproute2_db(filename, &path);
@@ -905,10 +906,13 @@ struct symbol_table *rt_symbol_table_init(const char *filename)
 			p++;
 		if (*p == '#' || *p == '\n' || *p == '\0')
 			continue;
-		if (sscanf(p, "0x%x %511s\n", &val, namebuf) != 2 &&
-		    sscanf(p, "0x%x %511s #", &val, namebuf) != 2 &&
-		    sscanf(p, "%u %511s\n", &val, namebuf) != 2 &&
-		    sscanf(p, "%u %511s #", &val, namebuf) != 2) {
+		if (sscanf(p, "0x%x %511s\n", &val, namebuf) == 2 ||
+		    sscanf(p, "0x%x %511s #", &val, namebuf) == 2) {
+			tbl->base = BASE_HEXADECIMAL;
+		} else if (sscanf(p, "%u %511s\n", &val, namebuf) == 2 ||
+			   sscanf(p, "%u %511s #", &val, namebuf) == 2) {
+			tbl->base = BASE_DECIMAL;
+		} else {
 			fprintf(stderr, "iproute database '%s' corrupted\n",
 				path ?: filename);
 			break;
-- 
2.43.0

