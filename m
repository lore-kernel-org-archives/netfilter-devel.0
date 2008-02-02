From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 23/34]  Print RAW as raw string.
Date: Sat,  2 Feb 2008 22:24:18 +0100
Message-ID: <1201987471531-git-send-email-eric@inl.fr>
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
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46057 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762480AbYBBWQu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:50 -0500
In-Reply-To: <12019874711938-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

MySQL need no to be able to print RAW datas to be able to display
IP addresses.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 1702acc... 4c4298c... M	util/db.c
 util/db.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/util/db.c b/util/db.c
index 1702acc..4c4298c 100644
--- a/util/db.c
+++ b/util/db.c
@@ -295,9 +295,7 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 			sprintf(di->stmt_ins, "',");
 			break;
 		case ULOGD_RET_RAW:
-			ulogd_log(ULOGD_NOTICE,
-				"%s: type RAW not supported by MySQL\n",
-				upi->input.keys[i].name);
+			sprintf(di->stmt_ins, "%s,", res->u.value.ptr);
 			break;
 		default:
 			ulogd_log(ULOGD_NOTICE,
-- 
1.5.2.5

