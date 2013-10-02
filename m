From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 1/2] Error: STRING_NULL
Date: Wed,  2 Oct 2013 10:43:37 +0200
Message-ID: <1380703418-3067-2-git-send-email-jpopelka@redhat.com>
References: <1380703418-3067-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Jarom=C3=ADr=20Kon=C4=8Dick=C3=BD?= <jkoncick@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3JBIns (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:43:48 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r928hm1t009585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Wed, 2 Oct 2013 04:43:48 -0400
In-Reply-To: <1380703418-3067-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Jarom=C3=ADr Kon=C4=8Dick=C3=BD <jkoncick@redhat.com>

arptables-v0.0.4/arptables.c:1671: string_null_argument: Function "read=
(int, void *, size_t)" does not terminate string "*ret".
arptables-v0.0.4/arptables.c:1675: string_null: Passing unterminated st=
ring "ret" to "strlen(char const *)", which expects a null-terminated s=
tring.
---
 userspace/arptables/arptables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/userspace/arptables/arptables.c b/userspace/arptables/arpt=
ables.c
index 5535ab2..8ef445a 100644
--- a/userspace/arptables/arptables.c
+++ b/userspace/arptables/arptables.c
@@ -1668,10 +1668,12 @@ static char *get_modprobe(void)
=20
 	ret =3D malloc(1024);
 	if (ret) {
-		switch (read(procfile, ret, 1024)) {
+		int read_bytes =3D read(procfile, ret, 1024);
+		switch (read_bytes) {
 		case -1: goto fail;
 		case 1024: goto fail; /* Partial read.  Wierd */
 		}
+		ret[read_bytes] =3D '\0';
 		if (ret[strlen(ret)-1]=3D=3D'\n')
 			ret[strlen(ret)-1]=3D0;
 		close(procfile);
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
