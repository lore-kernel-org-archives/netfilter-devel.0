From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: [PATCH 2/2] netfilter: add missing macro
Date: Fri, 8 Jul 2016 17:29:11 +0100
Message-ID: <20160708162911.18756-2-eric.engestrom@imgtec.com>
References: <20160708162911.18756-1-eric.engestrom@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Engestrom <eric@engestrom.ch>,
	Eric Engestrom <eric.engestrom@imgtec.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160708162911.18756-1-eric.engestrom@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
---

This can't compile without this macro=E2=80=A6 Is this header really us=
ed by anyone?
Should it be removed, to avoid bit-rot?

---
 include/uapi/linux/netfilter/xt_sctp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_sctp.h b/include/uapi/linu=
x/netfilter/xt_sctp.h
index 58ffcfb..e4410db 100644
--- a/include/uapi/linux/netfilter/xt_sctp.h
+++ b/include/uapi/linux/netfilter/xt_sctp.h
@@ -3,6 +3,8 @@
=20
 #include <linux/types.h>
=20
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr)[0])
+
 #define XT_SCTP_SRC_PORTS	        0x01
 #define XT_SCTP_DEST_PORTS	        0x02
 #define XT_SCTP_CHUNK_TYPES		0x04
--=20
2.9.0
