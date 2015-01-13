From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH 3/3] fix unused value warning
Date: Tue, 13 Jan 2015 11:55:12 +0000
Message-ID: <1421150112-3836-4-git-send-email-ast@fiberby.dk>
References: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([81.7.185.110]:51619 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbbAML5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:57:11 -0500
In-Reply-To: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch silences this warning:
warning: right-hand operand of comma expression has no effect[-Wunused-=
value]

The prefetch macro doesn't seam to be doing anything, but I will
leave it to Pablo to decide if it should be removed entirely.

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 include/linux_list.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux_list.h b/include/linux_list.h
index de182a4..91d9c6a 100644
--- a/include/linux_list.h
+++ b/include/linux_list.h
@@ -340,8 +340,8 @@ static inline void list_splice_init(struct list_hea=
d *list,
  * @head:	the head for your list.
  */
 #define list_for_each(pos, head) \
-	for (pos =3D (head)->next, prefetch(pos->next); pos !=3D (head); \
-        	pos =3D pos->next, prefetch(pos->next))
+	for (pos =3D (head)->next, (void) prefetch(pos->next); pos !=3D (head=
); \
+		pos =3D pos->next, (void) prefetch(pos->next))
=20
 /**
  * __list_for_each	-	iterate over a list
@@ -383,10 +383,10 @@ static inline void list_splice_init(struct list_h=
ead *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos =3D list_entry((head)->next, typeof(*pos), member),	\
-		     prefetch(pos->member.next);			\
+		     (void) prefetch(pos->member.next);			\
 	     &pos->member !=3D (head); 					\
 	     pos =3D list_entry(pos->member.next, typeof(*pos), member),	\
-		     prefetch(pos->member.next))
+		     (void) prefetch(pos->member.next))
=20
 /**
  * list_for_each_entry_reverse - iterate backwards over list of given =
type.
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
