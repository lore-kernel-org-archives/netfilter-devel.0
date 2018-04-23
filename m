From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables 2/2] extensions: libip6t_srh: add test-cases for matching previous, next and last SID
Date: Mon, 23 Apr 2018 05:48:23 -0500
Message-ID: <1524480503-1883-3-git-send-email-amsalam20@gmail.com>
References: <1524480503-1883-1-git-send-email-amsalam20@gmail.com>
Cc: Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, davem@davemloft.net,
        dav.lebrun@gmail.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524480503-1883-1-git-send-email-amsalam20@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds some test-cases to "libip6t_srh.t" for matching previous SID,
next SID, and last SID.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_srh.t | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/libip6t_srh.t b/extensions/libip6t_srh.t
index 08897d5..88a379e 100644
--- a/extensions/libip6t_srh.t
+++ b/extensions/libip6t_srh.t
@@ -23,4 +23,8 @@
 -m srh ! --srh-tag 0;=;OK
 -m srh --srh-next-hdr 17 --srh-segs-left-eq 1 --srh-last-entry-eq 4 --srh-tag 0;=;OK
 -m srh ! --srh-next-hdr 17 ! --srh-segs-left-eq 0 --srh-tag 0;=;OK
+-m srh --srh-psid A::2/64 --srh-nsid B2::/128 --srh-lsid C::/0;=;OK
+-m srh ! --srh-psid A::2/64 ! --srh-nsid B2::/128 ! --srh-lsid C::/0;=;OK
+-m srh --srh-psid A::2 --srh-nsid B2:: --srh-lsid C::;=;OK
+-m srh ! --srh-psid A::2 ! --srh-nsid B2:: ! --srh-lsid C::;=;OK
 -m srh;=;OK
-- 
2.1.4
