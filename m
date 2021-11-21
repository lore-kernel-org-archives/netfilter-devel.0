Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1D8C43217
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1FEC06173E
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 12:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ynYtcKNQ9dh55ol7Jpaq4sx1Vq4pg6VfVnltJN4dbyU=; b=fLpLwSrK/ziTpVrSYN8oTYy6ny
        NJ2nHCVbFdEoPvCcvPD6exB3OxmN0DWi9MoSkQTs66covsfvQvlZiPUFJu46IWRey7OCnaO+vkOD5
        +rYV8gF0GSCJIXrn47LufM8JXmx0HxFPAOgBAs3vBYS5b+quSDYfR+ArDUgUJUwN62XsGFL9kENW/
        Dr+X9Eq6GZjvJdzG//rM+6T2AZPk1itGtM0Vxy9YmiDFNwpIA3GRXVJu0V8uFUenWMsF1ojgNbe5P
        J1PhMrZTVUZKEe+uEh2/r16FP7hVq7E7XedDuEXXHYYZ5n+PYtJ55ytooqdRNtN+Qh3SNd67vY26E
        fXh9IX/g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1motel-0025lK-Cn
        for netfilter-devel@vger.kernel.org; Sun, 21 Nov 2021 20:41:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 4/5] input: UNIXSOCK: correct format specifiers
Date:   Sun, 21 Nov 2021 20:41:38 +0000
Message-Id: <20211121204139.2218387-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211121204139.2218387-1-jeremy@azazel.net>
References: <20211121204139.2218387-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a couple of logging calls which use the wrong specifiers for
their integer arguments.  Change the specifiers to match the arguments.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index 39944bf5cdb1..86ab590073d8 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
+#include <inttypes.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <netinet/ether.h>
@@ -632,9 +633,9 @@ static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
 		packet_sig = ntohl(unixsock_packet->marker);
 		if (packet_sig != ULOGD_SOCKET_MARK) {
 			ulogd_log(ULOGD_ERROR,
-				"ulogd2: invalid packet marked received "
-				"(read %lx, expected %lx), closing socket.\n",
-				packet_sig, ULOGD_SOCKET_MARK);
+				  "ulogd2: invalid packet marked received "
+				  "(read %" PRIx32 ", expected %" PRIx32 "), closing socket.\n",
+				  packet_sig, ULOGD_SOCKET_MARK);
 			_disconnect_client(ui);
 			return -1;
 
@@ -663,8 +664,8 @@ static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
 			}
 
 		} else {
-			ulogd_log(ULOGD_DEBUG, "  We have %d bytes, but need %d. Requesting more\n",
-					ui->unixsock_buf_avail, needed_len + sizeof(uint32_t));
+			ulogd_log(ULOGD_DEBUG, "  We have %u bytes, but need %zu. Requesting more\n",
+				  ui->unixsock_buf_avail, needed_len + sizeof(uint32_t));
 			return 0;
 		}
 
-- 
2.33.0

