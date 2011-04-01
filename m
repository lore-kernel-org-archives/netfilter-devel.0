From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 04/17] Delay (statically built) match/target initialization
Date: Thu, 31 Mar 2011 21:27:20 -0700
Message-ID: <1301632053-3694-4-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42303 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DAE2Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:16 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:16 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Matches and targets built into the iptables static binary will always
be registered as the binary starts up, this may potentially (as a resul=
t
of kernel version support checking) result in modules being autoloaded.

This is undesirable (for example it may cause CONNMARK target to load
and thus cause the kernel to load the conntrack module, which isn't a n=
o-op).

Transition to a system where matches and targets are registered into
a pending list, from whence they get fully registered only when require=
d.

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 xtables.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++=
-----
 1 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/xtables.c b/xtables.c
index 7d36742..4c708b8 100644
--- a/xtables.c
+++ b/xtables.c
@@ -174,10 +174,18 @@ static const char *xtables_libdir;
 /* the path to command to load kernel module */
 const char *xtables_modprobe_program;
=20
-/* Keeping track of external matches and targets: linked lists.  */
+/* Keep track of matches/targets pending full registration: linked lis=
ts. */
+struct xtables_match *xtables_pending_matches;
+struct xtables_target *xtables_pending_targets;
+
+/* Keep track of fully registered external matches/targets: linked lis=
ts. */
 struct xtables_match *xtables_matches;
 struct xtables_target *xtables_targets;
=20
+/* Fully register a match/target which was previously partially regist=
ered. */
+static void xtables_fully_register_pending_match(struct xtables_match =
*me);
+static void xtables_fully_register_pending_target(struct xtables_targe=
t *me);
+
 void xtables_init(void)
 {
 	xtables_libdir =3D getenv("XTABLES_LIBDIR");
@@ -556,6 +564,7 @@ struct xtables_match *
 xtables_find_match(const char *name, enum xtables_tryload tryload,
 		   struct xtables_rule_match **matches)
 {
+	struct xtables_match **dptr;
 	struct xtables_match *ptr;
 	const char *icmp6 =3D "icmp6";
=20
@@ -571,6 +580,18 @@ xtables_find_match(const char *name, enum xtables_=
tryload tryload,
 	     (strcmp(name,"icmp6") =3D=3D 0) )
 		name =3D icmp6;
=20
+	/* Trigger delayed initialization */
+	for (dptr =3D &xtables_pending_matches; *dptr; ) {
+		if (strcmp(name, (*dptr)->name) =3D=3D 0) {
+			ptr =3D *dptr;
+			*dptr =3D (*dptr)->next;
+			ptr->next =3D NULL;
+			xtables_fully_register_pending_match(ptr);
+		} else {
+			dptr =3D &((*dptr)->next);
+		}
+	}
+
 	for (ptr =3D xtables_matches; ptr; ptr =3D ptr->next) {
 		if (strcmp(name, ptr->name) =3D=3D 0) {
 			struct xtables_match *clone;
@@ -636,6 +657,7 @@ xtables_find_match(const char *name, enum xtables_t=
ryload tryload,
 struct xtables_target *
 xtables_find_target(const char *name, enum xtables_tryload tryload)
 {
+	struct xtables_target **dptr;
 	struct xtables_target *ptr;
=20
 	/* Standard target? */
@@ -646,6 +668,18 @@ xtables_find_target(const char *name, enum xtables=
_tryload tryload)
 	    || strcmp(name, XTC_LABEL_RETURN) =3D=3D 0)
 		name =3D "standard";
=20
+	/* Trigger delayed initialization */
+	for (dptr =3D &xtables_pending_targets; *dptr; ) {
+		if (strcmp(name, (*dptr)->name) =3D=3D 0) {
+			ptr =3D *dptr;
+			*dptr =3D (*dptr)->next;
+			ptr->next =3D NULL;
+			xtables_fully_register_pending_target(ptr);
+		} else {
+			dptr =3D &((*dptr)->next);
+		}
+	}
+
 	for (ptr =3D xtables_targets; ptr; ptr =3D ptr->next) {
 		if (strcmp(name, ptr->name) =3D=3D 0)
 			break;
@@ -757,8 +791,6 @@ static void xtables_check_options(const char *name,=
 const struct option *opt)
=20
 void xtables_register_match(struct xtables_match *me)
 {
-	struct xtables_match **i, *old;
-
 	if (me->version =3D=3D NULL) {
 		fprintf(stderr, "%s: match %s<%u> is missing a version\n",
 		        xt_params->program_name, me->name, me->revision);
@@ -792,6 +824,15 @@ void xtables_register_match(struct xtables_match *=
me)
 	if (me->family !=3D afinfo->family && me->family !=3D AF_UNSPEC)
 		return;
=20
+	/* place on linked list of matches pending full registration */
+	me->next =3D xtables_pending_matches;
+	xtables_pending_matches =3D me;
+}
+
+static void xtables_fully_register_pending_match(struct xtables_match =
*me)
+{
+	struct xtables_match **i, *old;
+
 	old =3D xtables_find_match(me->name, XTF_DURING_LOAD, NULL);
 	if (old) {
 		if (old->revision =3D=3D me->revision &&
@@ -845,8 +886,6 @@ void xtables_register_matches(struct xtables_match =
*match, unsigned int n)
=20
 void xtables_register_target(struct xtables_target *me)
 {
-	struct xtables_target *old;
-
 	if (me->version =3D=3D NULL) {
 		fprintf(stderr, "%s: target %s<%u> is missing a version\n",
 		        xt_params->program_name, me->name, me->revision);
@@ -880,6 +919,15 @@ void xtables_register_target(struct xtables_target=
 *me)
 	if (me->family !=3D afinfo->family && me->family !=3D AF_UNSPEC)
 		return;
=20
+	/* place on linked list of targets pending full registration */
+	me->next =3D xtables_pending_targets;
+	xtables_pending_targets =3D me;
+}
+
+static void xtables_fully_register_pending_target(struct xtables_targe=
t *me)
+{
+	struct xtables_target *old;
+
 	old =3D xtables_find_target(me->name, XTF_DURING_LOAD);
 	if (old) {
 		struct xtables_target **i;
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
