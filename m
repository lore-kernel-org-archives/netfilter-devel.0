From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 19/34]  Fix options for pgsql module
Date: Sat,  2 Feb 2008 22:24:14 +0100
Message-ID: <12019874712309-git-send-email-eric@inl.fr>
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
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46044 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762313AbYBBWQS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:18 -0500
In-Reply-To: <1201987471346-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

Options where wrongly set for PGsql module.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 4737d28... 6697b64... M	output/pgsql/ulogd_output_PGSQL.c
 output/pgsql/ulogd_output_PGSQL.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 4737d28..6697b64 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -78,8 +78,8 @@ static struct config_keyset pgsql_kset = {
 #define host_ce(x)	(x->ces[DB_CE_NUM+1])
 #define user_ce(x)	(x->ces[DB_CE_NUM+2])
 #define pass_ce(x)	(x->ces[DB_CE_NUM+3])
-#define port_ce(x)	(x->ces[DB_CE_NUM+5])
-#define schema_ce(x)	(x->ces[DB_CE_NUM+6])
+#define port_ce(x)	(x->ces[DB_CE_NUM+4])
+#define schema_ce(x)	(x->ces[DB_CE_NUM+5])
 
 #define PGSQL_HAVE_NAMESPACE_TEMPLATE 			\
 	"SELECT nspname FROM pg_namespace n WHERE n.nspname='%s'"
-- 
1.5.2.5

