From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables 2/2] extensions: add some test cases for 'SEG6' target
Date: Fri, 12 Jan 2018 05:39:59 +0100
Message-ID: <1515731999-6381-2-git-send-email-amsalam20@gmail.com>
References: <1515731999-6381-1-git-send-email-amsalam20@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515731999-6381-1-git-send-email-amsalam20@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds some test cases for 'SEG6' target.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_SEG6.t | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 extensions/libip6t_SEG6.t

diff --git a/extensions/libip6t_SEG6.t b/extensions/libip6t_SEG6.t
new file mode 100644
index 0000000..8dc30cb
--- /dev/null
+++ b/extensions/libip6t_SEG6.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD,OUTPUT
+-j SEG6 --seg6-action go-next;=;OK
+-j SEG6 --seg6-action skip-next;=;OK
+-j SEG6 --seg6-action go-last;=;OK
+-j SEG6;=;OK
-- 
2.1.4
