From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 10/34]  Add some missing line break.
Date: Sat,  2 Feb 2008 22:24:05 +0100
Message-ID: <12019874701552-git-send-email-eric@inl.fr>
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
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46012 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761910AbYBBWPD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:03 -0500
In-Reply-To: <12019874703136-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From Marius Tomaschewski <mt@suse.de>

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 563fc3b... 6990f8c... M	output/ulogd_output_OPRINT.c
 output/ulogd_output_OPRINT.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 563fc3b..6990f8c 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -86,9 +86,9 @@ static int oprint_interp(struct ulogd_pluginstance *upi)
 					HIPQUAD(ret->u.value.ui32));
 				break;
 			case ULOGD_RET_NONE:
-				fprintf(opi->of, "<none>");
+				fprintf(opi->of, "<none>\n");
 				break;
-			default: fprintf(opi->of, "default");
+			default: fprintf(opi->of, "default\n");
 		}
 	}
 	if (upi->config_kset->ces[1].u.value != 0)
-- 
1.5.2.5

