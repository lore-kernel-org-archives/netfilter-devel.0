From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 14/14]: ip_table_raw C99 initialization
Date: Mon, 21 Jun 2004 21:46:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194603.GT24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNRUKxUg8lAjUAR/"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tNRUKxUg8lAjUAR/
Content-Type: multipart/mixed; boundary="5SR535opHDmk1Ddx"
Content-Disposition: inline


--5SR535opHDmk1Ddx
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 changes initial_table in iptable_raw to C99,
Sparse didn't like the construct "{[NF_IP_XXX] 0,".

Author: Stephen Hemminger <shemminger@osdl.org>

Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5SR535opHDmk1Ddx
Content-Type: text/plain; charset=us-ascii; name="14.diff"
Content-Disposition: inline; filename="14.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:49:11+02:00 kaber@trash.net=20
#   [NETFILTER]: ip_table_raw C99 initialization
#=20
# net/ipv4/netfilter/iptable_raw.c
#   2004/06/20 22:49:02+02:00 kaber@trash.net +58 -37
#   [NETFILTER]: ip_table_raw C99 initialization
#=20
diff -Nru a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_r=
aw.c
--- a/net/ipv4/netfilter/iptable_raw.c	2004-06-20 23:01:35 +02:00
+++ b/net/ipv4/netfilter/iptable_raw.c	2004-06-20 23:01:35 +02:00
@@ -32,43 +32,64 @@
 	struct ipt_replace repl;
 	struct ipt_standard entries[2];
 	struct ipt_error term;
-} initial_table __initdata
-=3D { { "raw", RAW_VALID_HOOKS, 3,
-      sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
-      { [NF_IP_PRE_ROUTING] 0,
-	[NF_IP_LOCAL_OUT] sizeof(struct ipt_standard) },
-      { [NF_IP_PRE_ROUTING] 0,
-	[NF_IP_LOCAL_OUT] sizeof(struct ipt_standard) },
-      0, NULL, { } },
-    {
-	    /* PRE_ROUTING */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } =
},
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_OUT */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } =
},
-		-NF_ACCEPT - 1 } }
-    },
-    /* ERROR */
-    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-	0,
-	sizeof(struct ipt_entry),
-	sizeof(struct ipt_error),
-	0, { 0, 0 }, { } },
-      { { { { IPT_ALIGN(sizeof(struct ipt_error_target)), IPT_ERROR_TARGET=
 } },
-	  { } },
-	"ERROR"
-      }
-    }
+} initial_table __initdata =3D {
+	.repl =3D {
+		.name =3D "raw",=20
+		.valid_hooks =3D RAW_VALID_HOOKS,=20
+		.num_entries =3D 3,
+		.size =3D sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
+		.hook_entry =3D {=20
+			[NF_IP_PRE_ROUTING] =3D 0,
+			[NF_IP_LOCAL_OUT] =3D sizeof(struct ipt_standard) },
+		.underflow =3D {=20
+			[NF_IP_PRE_ROUTING] =3D 0,
+			[NF_IP_LOCAL_OUT]  =3D sizeof(struct ipt_standard) },
+	},
+	.entries =3D {
+	     /* PRE_ROUTING */
+	     {=20
+		     .entry =3D {=20
+			     .target_offset =3D sizeof(struct ipt_entry),
+			     .next_offset =3D sizeof(struct ipt_standard),
+		     },
+		     .target =3D {=20
+			  .target =3D {=20
+				  .u.target_size =3D IPT_ALIGN(sizeof(struct ipt_standard_target)),
+			  },
+			  .verdict =3D -NF_ACCEPT - 1,
+		     },
+	     },
+
+	     /* LOCAL_OUT */
+	     {
+		     .entry =3D {
+			     .target_offset =3D sizeof(struct ipt_entry),
+			     .next_offset =3D sizeof(struct ipt_standard),
+		     },
+		     .target =3D {
+			     .target =3D {
+				     .u.target_size =3D IPT_ALIGN(sizeof(struct ipt_standard_target)),
+			     },
+			     .verdict =3D -NF_ACCEPT - 1,
+		     },
+	     },
+	},
+	/* ERROR */
+	.term =3D {
+		.entry =3D {
+			.target_offset =3D sizeof(struct ipt_entry),
+			.next_offset =3D sizeof(struct ipt_error),
+		},
+		.target =3D {
+			.target =3D {
+				.u.user =3D {
+					.target_size =3D IPT_ALIGN(sizeof(struct ipt_error_target)),=20
+					.name =3D IPT_ERROR_TARGET,
+				},
+			},
+			.errorname =3D "ERROR",
+		},
+	}
 };
=20
 static struct ipt_table packet_raw =3D {=20


--5SR535opHDmk1Ddx--

--tNRUKxUg8lAjUAR/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zr7XaXGVTD0i/8RAgcCAJ4yYxgiJdRzwZ7F0BOFzQwhS2q7/ACgq/XN
ptaErk1m7NEw2TEtVNf/Tqs=
=MqKS
-----END PGP SIGNATURE-----

--tNRUKxUg8lAjUAR/--
