From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 11/34]  Put O at the real end of the string.
Date: Sat,  2 Feb 2008 22:24:06 +0100
Message-ID: <12019874701370-git-send-email-eric@inl.fr>
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
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46023 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762064AbYBBWPe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:34 -0500
In-Reply-To: <12019874701552-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From Marius Tomaschewski <mt@suse.de>

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 7e417da... 2efc07d... M	filter/ulogd_filter_PWSNIFF.c
 filter/ulogd_filter_PWSNIFF.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 7e417da..2efc07d 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -123,7 +123,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 			return 0;
 		}
 		strncpy((char *) ret[0].u.value.ptr, (char *)begp, len);
-		*((char *)ret[0].u.value.ptr + len + 1) = '\0';
+		*((char *)ret[0].u.value.ptr + len) = '\0';
 	}
 	if (pw_len) {
 		ret[1].u.value.ptr = (char *) malloc(pw_len+1);
@@ -133,7 +133,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 			return 0;
 		}
 		strncpy((char *)ret[1].u.value.ptr, (char *)pw_begp, pw_len);
-		*((char *)ret[1].u.value.ptr + pw_len + 1) = '\0';
+		*((char *)ret[1].u.value.ptr + pw_len) = '\0';
 
 	}
 	return 0;
-- 
1.5.2.5

