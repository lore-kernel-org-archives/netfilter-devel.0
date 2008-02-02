From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 12/34]  Changed to show pcap file name when open failed.
Date: Sat,  2 Feb 2008 22:24:07 +0100
Message-ID: <12019874702349-git-send-email-eric@inl.fr>
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
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46006 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761850AbYBBWOq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:46 -0500
In-Reply-To: <12019874701370-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Port of Marius Tomaschewski work on ulogd.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 90f7e0a... 59b5d2c... M	output/pcap/ulogd_output_PCAP.c
 output/pcap/ulogd_output_PCAP.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 90f7e0a..59b5d2c 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -204,7 +204,8 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
 	if (!exist) {
 		pi->of = fopen(filename, "w");
 		if (!pi->of) {
-			ulogd_log(ULOGD_ERROR, "can't open pcap file: %s\n",
+			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
+				  filename,
 				  strerror(errno));
 			return -EPERM;
 		}
-- 
1.5.2.5

