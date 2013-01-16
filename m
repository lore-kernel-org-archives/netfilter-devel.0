From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: state match is obsolete 1.4.17
Date: Wed, 16 Jan 2013 01:11:09 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301160105200.8938@nerf07.vanv.qr>
References: <CAMD-=V+PhM3NLpWyxB0G4KUN6D+-XKL0PZCBAuyUXUw56gmuJw@mail.gmail.com> <alpine.LNX.2.01.1301150958390.16853@nerf07.vanv.qr> <CAMD-=V+p0gv+amQearBpGPD0q3zALUEfQj6xCoTTg197jN3_5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter user mailing list <netfilter@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Nick Edwards <nick.z.edwards@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40109 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab3APALL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:11:11 -0500
In-Reply-To: <CAMD-=V+p0gv+amQearBpGPD0q3zALUEfQj6xCoTTg197jN3_5A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2013-01-16 00:27, Nick Edwards wrote:
>> On Tuesday 2013-01-15 06:09, Nick Edwards wrote:
>>
>>>WARNING: The state match is obsolete. Use conntrack instead.
>>>Getting these errors since upgrading to 1.4.17
>>
>> It is a warning, not an error. (An error would not let use you
>> the command at all.)
>
>I can understand that if there is a lot of pre warning, as others have
>mentioned, most guides show the former..
>And can you confirm my change is the correct method to obtain the same
>net result please?

Yes.

>Maybe the warning could be changed to
>WARNING: The state match is deprecated and will eventually go away.
>Use conntrack instead.
>That wont panic people into thinking the rule is not working.

Cannot guarantee that it will make it in, but I support your
position with this patch.


git://git.inai.de/iptables obsol
>From 6ef6c8821c26d5a8738cf90e397972c97986ac98 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@inai.de>
Date: Wed, 16 Jan 2013 01:03:40 +0100
Subject: [PATCH] iptables: reword warning on using an alias

This by suggestion of Nick Edward.

References: http://marc.info/?l=netfilter&m=135829245822520&w=2
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.c |    9 +++++----
 iptables/iptables.c  |    9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 556647f..ba71aca 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1229,8 +1229,8 @@ static void command_jump(struct iptables_command_state *cs)
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
 	} else {
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-		fprintf(stderr, "WARNING: The %s target is obsolete. "
-		        "Use %s instead.\n",
+		fprintf(stderr, "WARNING: The %s target is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
 		        cs->jumpto, cs->target->real_name);
 	}
 	cs->target->t->u.user.revision = cs->target->revision;
@@ -1265,8 +1265,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		fprintf(stderr, "WARNING: The %s match is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
+		        m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 00e3f01..f0dc14b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1222,8 +1222,8 @@ static void command_jump(struct iptables_command_state *cs)
 	} else {
 		/* Alias support for userspace side */
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-		fprintf(stderr, "WARNING: The %s target is obsolete. "
-		        "Use %s instead.\n",
+		fprintf(stderr, "WARNING: The %s target is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
 		        cs->jumpto, cs->target->real_name);
 	}
 	cs->target->t->u.user.revision = cs->target->revision;
@@ -1259,8 +1259,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		fprintf(stderr, "WARNING: The %s match is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
+		        m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
-- 
1.7.10.4

