From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] remove exessive timer updates (3/4)
Date: 06 Jun 2002 14:24:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023365846.845.26.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kq1pN+4riW/nZ4NAkBK5"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-kq1pN+4riW/nZ4NAkBK5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Here's the patch that lead up to the first patch (the renaming of
death_by_timeout and exporting it).

This patch adds a check to ip_ct_refresh() so it doesn't update the
timer of a connection unless it's been >HZ ticks since the last update.
both del_timer() and add_timer() disables interrupts while
removing/inserting the timer, no reason to do this for each packet.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-kq1pN+4riW/nZ4NAkBK5
Content-Disposition: attachment; filename=ip_conntrack_core.c-timer-diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack_core.c-timer-diff; charset=ISO-8859-15

--- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c.orig	Mon Jun  =
3 20:32:28 2002
+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c	Mon Jun  3 20:=
48:13 2002
@@ -1091,8 +1091,10 @@
 	if (!is_confirmed(ct))
 		ct->timeout.expires =3D extra_jiffies;
 	else {
-		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
+		/* Don't update timer for each packet, only if it's been >HZ
+		 * ticks since last update.
+		 * Need del_timer for race avoidance (may already be dying). */
+		if (time_after(jiffies, ct->timeout.expires - extra_jiffies + HZ) && del=
_timer(&ct->timeout)) {
 			ct->timeout.expires =3D jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
 		}

--=-kq1pN+4riW/nZ4NAkBK5--
