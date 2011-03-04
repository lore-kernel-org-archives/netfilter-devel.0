From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [PATCH] netfilter:ipset: fix the compile warning in ip_set_create
Date: Fri, 04 Mar 2011 15:34:35 +0800
Message-ID: <4D70960B.2040209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab1CDHjS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:39:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


net/netfilter/ipset/ip_set_core.c:615: warning: =E2=80=98clash=E2=80=99=
 may be used uninitialized in this function

Signed-off-by: shanw <shanw@shanw-desktop.(none)>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip=
_set_core.c
index 8b1a54c..618a615 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -612,7 +612,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *sk=
b,
 	      const struct nlmsghdr *nlh,
 	      const struct nlattr * const attr[])
 {
-	struct ip_set *set, *clash;
+	struct ip_set *set, *clash =3D NULL;
 	ip_set_id_t index =3D IPSET_INVALID_ID;
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1] =3D {};
 	const char *name, *typename;
--=20
1.6.3.3
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
