From: Peter Volkov <pva@gentoo.org>
Subject: [Fwd: [iptables]fix a typo]
Date: Tue, 21 Dec 2010 12:44:58 +0300
Message-ID: <1292924699.18804.19.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Li Yewang <lyw@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:51993 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661Ab0LUJp3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:45:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys, this patch looks correct to me. Could somebody apply it?

--
Peter.

-------- =D0=9F=D0=B5=D1=80=D0=B5=D1=81=D1=8B=D0=BB=D0=B0=D0=B5=D0=BC=D0=
=BE=D0=B5 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B5 ------=
--
=D0=9E=D1=82: Li Yewang <lyw@cn.fujitsu.com>
=D0=9A=D0=BE=D0=BC=D1=83: netfilter-devel@vger.kernel.org
=D0=A2=D0=B5=D0=BC=D0=B0: [iptables]fix a typo
=D0=94=D0=B0=D1=82=D0=B0: 	Wed, 04 Aug 2010 13:22:21 +0800

=46ix a typo.


Signed-off-by: Li Yewang <lyw@cn.fujitsu.com>

---
  xtables.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index ed082f3..31fd8f9 100644
--- a/xtables.c
+++ b/xtables.c
@@ -734,7 +734,7 @@ void xtables_register_match(struct xtables_match *m=
e)
  	}

  	if (strlen(me->name) >=3D XT_EXTENSION_MAXNAMELEN) {
-		fprintf(stderr, "%s: target `%s' has invalid name\n",
+		fprintf(stderr, "%s: match `%s' has invalid name\n",
  			xt_params->program_name, me->name);
  		exit(1);
  	}
--=20
1.5.5.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
