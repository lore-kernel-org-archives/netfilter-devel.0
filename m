Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA33492
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 08:13:43 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
	id 767B158B194F4; Sat, 25 Nov 2023 17:13:42 +0100 (CET)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
	by a3.inai.de (Postfix) with ESMTP id 3C38E58B194F3
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 17:13:42 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] man: proper roff encoding for ^
Date: Sat, 25 Nov 2023 17:13:34 +0100
Message-ID: <20231125161338.77331-1-jengelh@inai.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: ebtables-2.0.10-4-56-g676fab3
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ebtables-legacy.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ebtables-legacy.8.in b/ebtables-legacy.8.in
index 51270d2..9ffef4b 100644
--- a/ebtables-legacy.8.in
+++ b/ebtables-legacy.8.in
@@ -925,7 +925,7 @@ Log with the default logging options
 .TP
 .B \-\-nflog\-group "\fInlgroup\fP"
 .br
-The netlink group (1\(en2\^32\-1) to which packets are (only applicable for
+The netlink group (1\(en2\(ha32\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
 .B \-\-nflog\-prefix "\fIprefix\fP"
-- 
2.43.0

