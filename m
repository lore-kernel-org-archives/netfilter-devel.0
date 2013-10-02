From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 2/2] Error: STRING_OVERFLOW
Date: Wed,  2 Oct 2013 10:43:38 +0200
Message-ID: <1380703418-3067-3-git-send-email-jpopelka@redhat.com>
References: <1380703418-3067-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Jarom=C3=ADr=20Kon=C4=8Dick=C3=BD?= <jkoncick@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3JBInu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:43:50 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r928hnQa013389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Wed, 2 Oct 2013 04:43:49 -0400
In-Reply-To: <1380703418-3067-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Jarom=C3=ADr Kon=C4=8Dick=C3=BD <jkoncick@redhat.com>

Error: STRING_OVERFLOW
arptables-v0.0.4/arptables.c:1273: fixed_size_dest: You might overrun t=
he 8192 byte fixed-size string "buf" by copying the return value of "ma=
sk_to_dotted(struct in_addr const *)" without checking the length.

Error: STRING_OVERFLOW
arptables-v0.0.4/arptables.c:1297: fixed_size_dest: You might overrun t=
he 8192 byte fixed-size string "buf" by copying the return value of "ma=
sk_to_dotted(struct in_addr const *)" without checking the length.

Error: STRING_OVERFLOW
arptables-v0.0.4/libarptc/libarptc_incl.c:360: fixed_size_dest: You mig=
ht overrun the 32 byte fixed-size string "(h->cache_chain_heads + h->ca=
che_num_chains).name" by copying "arpt_get_target(e)->data" without che=
cking the length.

Error: STRING_OVERFLOW
arptables-v0.0.4/libarptc/libarptc_incl.c:371: fixed_size_dest: You mig=
ht overrun the 32 byte fixed-size string "(h->cache_chain_heads + h->ca=
che_num_chains).name" by copying "h->hooknames[builtin - 1U]" without c=
hecking the length.

Error: STRING_OVERFLOW
arptables-v0.0.4/libarptc/libarptc_incl.c:213: fixed_size_dest: You mig=
ht overrun the 32 byte fixed-size string "h->entries.name" by copying "=
tablename" without checking the length.
arptables-v0.0.4/libarptc/libarptc_incl.c:213: parameter_as_source: Not=
e: This defect has an elevated risk because the source argument is a pa=
rameter of the current function.

Error: STRING_OVERFLOW
arptables-v0.0.4/libarptc/libarptc_incl.c:212: fixed_size_dest: You mig=
ht overrun the 32 byte fixed-size string "h->info.name" by copying "tab=
lename" without checking the length.
arptables-v0.0.4/libarptc/libarptc_incl.c:212: parameter_as_source: Not=
e: This defect has an elevated risk because the source argument is a pa=
rameter of the current function.

Error: STRING_OVERFLOW
arptables-v0.0.4/arptables.c:2065: fixed_size_dest: You might overrun t=
he 30 byte fixed-size string "target->t->u.user.name" by copying "jumpt=
o" without checking the length.
---
 userspace/arptables/arptables.c              |  9 +++++----
 userspace/arptables/libarptc/libarptc_incl.c | 16 ++++++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/userspace/arptables/arptables.c b/userspace/arptables/arpt=
ables.c
index 8ef445a..4da6fea 100644
--- a/userspace/arptables/arptables.c
+++ b/userspace/arptables/arptables.c
@@ -1270,7 +1270,7 @@ print_firewall(const struct arpt_entry *fw,
 			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.src)));
 		else
 			sprintf(buf, "%s", addr_to_anyname(&(fw->arp.src)));
-		strcat(buf, mask_to_dotted(&(fw->arp.smsk)));
+		strncat(buf, mask_to_dotted(&(fw->arp.smsk)), sizeof(buf) - strlen(b=
uf) -1);
 		printf("-s %s ", buf);
 	}
=20
@@ -1294,7 +1294,7 @@ after_devsrc:
 			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.tgt)));
 		else
 			sprintf(buf, "%s", addr_to_anyname(&(fw->arp.tgt)));
-		strcat(buf, mask_to_dotted(&(fw->arp.tmsk)));
+		strncat(buf, mask_to_dotted(&(fw->arp.tmsk)),  sizeof(buf) - strlen(=
buf) -1);
 		printf("-d %s ", buf);
 	}
=20
@@ -1796,7 +1796,7 @@ int do_command(int argc, char *argv[], char **tab=
le, arptc_handle_t *handle)
 				*table, arptc_strerror(errno));
 			}
 		}
-        }
+	}
=20
 	memset(&fw, 0, sizeof(fw));
 	opts =3D original_opts;
@@ -2064,7 +2064,8 @@ int do_command(int argc, char *argv[], char **tab=
le, arptc_handle_t *handle)
=20
 				target->t =3D fw_calloc(1, size);
 				target->t->u.target_size =3D size;
-				strcpy(target->t->u.user.name, jumpto);
+				strncpy(target->t->u.user.name, jumpto, sizeof(target->t->u.user.n=
ame));
+				target->t->u.user.name[sizeof(target->t->u.user.name)-1] =3D '\0';
 /*
 				target->init(target->t, &fw.nfcache);
 */
diff --git a/userspace/arptables/libarptc/libarptc_incl.c b/userspace/a=
rptables/libarptc/libarptc_incl.c
index 2fa3d43..9c1aeac 100644
--- a/userspace/arptables/libarptc/libarptc_incl.c
+++ b/userspace/arptables/libarptc/libarptc_incl.c
@@ -209,8 +209,10 @@ alloc_handle(const char *tablename, unsigned int s=
ize, unsigned int num_rules)
 	h->counter_map =3D (void *)h
 		+ sizeof(STRUCT_TC_HANDLE)
 		+ size;
-	strcpy(h->info.name, tablename);
-	strcpy(h->entries.name, tablename);
+	strncpy(h->info.name, tablename, sizeof(h->info.name));
+	h->info.name[sizeof(h->info.name)-1] =3D '\0';
+	strncpy(h->entries.name, tablename, sizeof(h->entries.name));
+	h->entries.name[sizeof(h->entries.name)-1] =3D '\0';
=20
 	return h;
 }
@@ -357,8 +359,9 @@ add_chain(STRUCT_ENTRY *e, TC_HANDLE_T h, STRUCT_EN=
TRY **prev)
 		h->cache_chain_heads[h->cache_num_chains-1].end
 			=3D *prev;
=20
-		strcpy(h->cache_chain_heads[h->cache_num_chains].name,
-		       (const char *)GET_TARGET(e)->data);
+		strncpy(h->cache_chain_heads[h->cache_num_chains].name,
+		       (const char *)GET_TARGET(e)->data, TABLE_MAXNAMELEN-1);
+		h->cache_chain_heads[h->cache_num_chains].name[TABLE_MAXNAMELEN-1] =3D=
 '\0';
 		h->cache_chain_heads[h->cache_num_chains].start
 			=3D (void *)e + e->next_offset;
 		h->cache_num_chains++;
@@ -368,8 +371,9 @@ add_chain(STRUCT_ENTRY *e, TC_HANDLE_T h, STRUCT_EN=
TRY **prev)
 			h->cache_chain_heads[h->cache_num_chains-1].end
 				=3D *prev;
=20
-		strcpy(h->cache_chain_heads[h->cache_num_chains].name,
-		       h->hooknames[builtin-1]);
+		strncpy(h->cache_chain_heads[h->cache_num_chains].name,
+		       h->hooknames[builtin-1], TABLE_MAXNAMELEN-1);
+		h->cache_chain_heads[h->cache_num_chains].name[TABLE_MAXNAMELEN-1] =3D=
 '\0';
 		h->cache_chain_heads[h->cache_num_chains].start
 			=3D (void *)e;
 		h->cache_num_chains++;
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
