From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 20/34]  Mark ID as inactive (sequence in pg schema)
Date: Sat,  2 Feb 2008 22:24:15 +0100
Message-ID: <12019874714080-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45995 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761660AbYBBWOQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:16 -0500
In-Reply-To: <12019874712309-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 6697b64... 0882357... M	output/pgsql/ulogd_output_PGSQL.c
 output/pgsql/ulogd_output_PGSQL.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 6697b64..0882357 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -196,7 +196,8 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 		strncpy(upi->input.keys[i].name, buf, ULOGD_MAX_KEYLEN);
 	}
 
-	/* FIXME: id? */
+	/* ID is a sequence */
+	upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
 
 	PQclear(pi->pgres);
 	return 0;
-- 
1.5.2.5

