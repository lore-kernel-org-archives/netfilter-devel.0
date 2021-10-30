Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B035CC43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926D660FC0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhJ3QrI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhJ3QrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799CDC061766
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PO1hu21z0Ig1MiIZaHaHk5csfBnO0KhJXvOBfeHt3d4=; b=eyqORwwzfjfAaIgBVex3zxbzNW
        QaUxngM77fth8uOZrnTkcIfeKs4hnYRWxoI0v24fFUl+clTN5PZ6AYHbBjCmjKaQhkJZygAHX/cXY
        Qt6GFeQWHZehQJrlWwN53eNW1nG7IRwqQ+lLVPmm+F8odyB+ZKKteNOkiDj2V8WLvnopkdyvN4d06
        RStHxtQbybxu14VuODGkAeCxxKh8iYxYTpKUpyrHvwuCZ2BGJAgGwcSmBdk2mJCdCiLM5nzx8BRVQ
        WuP8jmIND7gB10VQZ/ofc+GjLBc39HMGEOGnHNFL1bRy8kQB3upAGvma4YLMTHHVqaybKSd1EhYCr
        Y8Lr/yfQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-A7
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 04/26] ulog: correct log specifiers
Date:   Sat, 30 Oct 2021 17:44:10 +0100
Message-Id: <20211030164432.1140896-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index 39944bf5cdb1..f97c2e174b2d 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
+#include <inttypes.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <netinet/ether.h>
@@ -633,7 +634,7 @@ static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
 		if (packet_sig != ULOGD_SOCKET_MARK) {
 			ulogd_log(ULOGD_ERROR,
 				"ulogd2: invalid packet marked received "
-				"(read %lx, expected %lx), closing socket.\n",
+				"(read %" PRIx32 ", expected %" PRIx32 "), closing socket.\n",
 				packet_sig, ULOGD_SOCKET_MARK);
 			_disconnect_client(ui);
 			return -1;
@@ -663,7 +664,7 @@ static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
 			}
 
 		} else {
-			ulogd_log(ULOGD_DEBUG, "  We have %d bytes, but need %d. Requesting more\n",
+			ulogd_log(ULOGD_DEBUG, "  We have %u bytes, but need %zu. Requesting more\n",
 					ui->unixsock_buf_avail, needed_len + sizeof(uint32_t));
 			return 0;
 		}
-- 
2.33.0

