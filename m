Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468A413E3EF;
	Wed,  9 Oct 2024 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506391; cv=none; b=uHmn0dS6EAkYUkCB6YshF96Ik0dX3ZtvATzbJK/ZlztoeIiB3w1OEMCZubUtHRghUcNCSS68DaSb2NbHR2N/wCHrGOyq3NHkC+Lbmsm8hEznANLpgVPAgPm/H6P8Q00alhWKnq4UEtzDZDOuG8+MHN4CuJOJIvaiONR5p/D4778=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506391; c=relaxed/simple;
	bh=nl2+eMYlvByB48AH+EW+Laq5vLJGxsHHq7+CS0XiC8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y9ZufvKs1ad5bWlaWsJHYLEhZr+gHnrYGgKHufD+xrnCvzDvqrJxV2w/KwSmSf3mk/siejRTyRAMbxiLc3BUw8An1xOxQSPgjic6adDDDHCxpJMWIQrlwHwx5QEqRyzUZgPiMovoEBOGNT7gVoBHXziBLg5ZiLdqYZfUGla8UQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 80A22294723;
	Wed,  9 Oct 2024 22:33:11 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id meLTPHl8u3_K; Wed,  9 Oct 2024 22:33:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 10EF82A880F;
	Wed,  9 Oct 2024 22:33:11 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id g5VLosYjX0uD; Wed,  9 Oct 2024 22:33:10 +0200 (CEST)
Received: from foxxylove.corp.sigma-star.at (unknown [82.150.214.1])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 97010294723;
	Wed,  9 Oct 2024 22:33:10 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	kadlec@netfilter.org,
	pablo@netfilter.org,
	rgb@redhat.com,
	paul@paul-moore.com,
	upstream+net@sigma-star.at,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Date: Wed,  9 Oct 2024 22:32:18 +0200
Message-Id: <20241009203218.26329-1-richard@nod.at>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

When recording audit events for new outgoing connections,
it is helpful to log the user info of the associated socket,
if available.
Therefore, check if the skb has a socket, and if it does,
log the owning fsuid/fsgid.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 net/netfilter/xt_AUDIT.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index b6a015aee0cec..d88b5442beaa6 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -9,16 +9,19 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
=20
 #include <linux/audit.h>
+#include <linux/cred.h>
+#include <linux/file.h>
+#include <linux/if_arp.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
-#include <linux/if_arp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_AUDIT.h>
 #include <linux/netfilter_bridge/ebtables.h>
-#include <net/ipv6.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
+#include <net/sock.h>
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Graf <tgraf@redhat.com>");
@@ -66,7 +69,9 @@ static bool audit_ip6(struct audit_buffer *ab, struct s=
k_buff *skb)
 static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
+	struct sock *sk =3D skb->sk;
 	struct audit_buffer *ab;
+	bool got_uidgid =3D false;
 	int fam =3D -1;
=20
 	if (audit_enabled =3D=3D AUDIT_OFF)
@@ -99,6 +104,24 @@ audit_tg(struct sk_buff *skb, const struct xt_action_=
param *par)
 	if (fam =3D=3D -1)
 		audit_log_format(ab, " saddr=3D? daddr=3D? proto=3D-1");
=20
+	if (sk && sk_fullsock(sk)) {
+		read_lock_bh(&sk->sk_callback_lock);
+		if (sk->sk_socket && sk->sk_socket->file) {
+			const struct file *file =3D sk->sk_socket->file;
+			const struct cred *cred =3D file->f_cred;
+
+			audit_log_format(ab, " uid=3D%u gid=3D%u",
+					 from_kuid(&init_user_ns, cred->fsuid),
+					 from_kgid(&init_user_ns, cred->fsgid));
+
+			got_uidgid =3D true;
+		}
+		read_unlock_bh(&sk->sk_callback_lock);
+	}
+
+	if (!got_uidgid)
+		audit_log_format(ab, " uid=3D? gid=3D?");
+
 	audit_log_end(ab);
=20
 errout:
--=20
2.35.3

