From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 30/34]  Convert SQL procedure to function call.
Date: Sat,  2 Feb 2008 22:24:25 +0100
Message-ID: <12019874721299-git-send-email-eric@inl.fr>
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
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
 <12019874713782-git-send-email-eric@inl.fr>
 <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr>
 <12019874711187-git-send-email-eric@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46028 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762207AbYBBWPs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:48 -0500
In-Reply-To: <12019874711187-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

SQL standard says a function has to be called with SELECT and not CALL.
This patch modify code accordingly.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 4c4298c... d57ab6a... M	util/db.c
 util/db.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util/db.c b/util/db.c
index 4c4298c..d57ab6a 100644
--- a/util/db.c
+++ b/util/db.c
@@ -90,7 +90,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		return -ENOMEM;
 	}
 
-	sprintf(mi->stmt, "CALL %s(", procedure);
+	sprintf(mi->stmt, "SELECT %s(", procedure);
 
 	mi->stmt_val = mi->stmt + strlen(mi->stmt);
 
-- 
1.5.2.5

