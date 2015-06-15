From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 02/15] netfilter: use forward declaration instead of including linux/proc_fs.h
Date: Mon, 15 Jun 2015 17:46:44 +0200
Message-ID: <1434383217-13732-3-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36832 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbbFOPlp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:45 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We don't need to pull the full definitions in that file, a simple forwa=
rd
declaration is enough.

Moreover, include linux/procfs.h from nf_synproxy_core, otherwise this =
hits a
compilation error due to missing declarations, ie.

net/netfilter/nf_synproxy_core.c: In function =E2=80=98synproxy_proc_in=
it=E2=80=99:
net/netfilter/nf_synproxy_core.c:326:2: error: implicit declaration of =
function =E2=80=98proc_create=E2=80=99 [-Werror=3Dimplicit-function-dec=
laration]
  if (!proc_create("synproxy", S_IRUGO, net->proc_net_stat,
  ^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/netfilter.h    |    2 +-
 net/netfilter/nf_synproxy_core.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilte=
r.h
index 8874002..cf25b5e 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -1,9 +1,9 @@
 #ifndef __NETNS_NETFILTER_H
 #define __NETNS_NETFILTER_H
=20
-#include <linux/proc_fs.h>
 #include <linux/netfilter.h>
=20
+struct proc_dir_entry;
 struct nf_logger;
=20
 struct netns_nf {
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synpro=
xy_core.c
index 52e20c9..789feea 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -11,6 +11,7 @@
 #include <asm/unaligned.h>
 #include <net/tcp.h>
 #include <net/netns/generic.h>
+#include <linux/proc_fs.h>
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/x_tables.h>
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
