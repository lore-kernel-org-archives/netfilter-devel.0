From: Bart De Schuymer <bart.de.schuymer@pandora.be>
Subject: [PATCH] (trivial) memory leakage in userspace iptables.c::merge_options()
Date: Wed, 26 Jun 2002 23:17:24 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206262317.24869.bart.de.schuymer@pandora.be>
References: <20020613175053.J2543@sunbeam.de.gnumonks.org> <200206131931.23688.hno@marasystems.com> <200206150014.28710.bart.de.schuymer@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_0H0C2EFM3N7P6I044WNM"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
In-Reply-To: <200206150014.28710.bart.de.schuymer@pandora.be>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_0H0C2EFM3N7P6I044WNM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

This is just a small patch that free's unused memory in=20
iptables.c::merge_options(). It's vs the file in the CVS.

--=20
cheers,
Bart
--------------Boundary-00=_0H0C2EFM3N7P6I044WNM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="iptables.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iptables.c.diff"

--- iptables.c.old	Mon Jun 24 14:37:29 2002
+++ iptables.c	Wed Jun 26 23:05:34 2002
@@ -986,6 +986,8 @@
 		merge[num_old + i].val += *option_offset;
 	}
 	memset(merge + num_old + num_new, 0, sizeof(struct option));
+	if (oldopts != original_opts)
+		free(oldopts);
 
 	return merge;
 }

--------------Boundary-00=_0H0C2EFM3N7P6I044WNM--
