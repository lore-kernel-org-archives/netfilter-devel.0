From: Victor Stinner <victor.stinner@inl.fr>
Subject: Bugfix: libnetfilter_conntrack getter and setter
Date: Thu, 4 Jan 2007 11:03:39 +0100
Message-ID: <200701041103.39580.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7DNnFvzgYOzuTIQ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_7DNnFvzgYOzuTIQ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Libnetfilter_conntrack getters and setters of new API are not complete:
 * it's not possible to set counter attributes value
 * it's not possible to set or read 'use' and 'id' attributes value

I can understand that setting counter values is not very useful, but trying to 
set them would lead to a crash (call NULL function). Same problem when trying 
to read use/id attribute value.

I attached two patches to fix that.

---

An alternative for nfct_set_attr() is to do nothing if the getter in NULL (and 
set an error?).

Victor Stinner
http://www.inl.fr/

--Boundary-00=_7DNnFvzgYOzuTIQ
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_conntrack_getter.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="libnetfilter_conntrack_getter.patch"

Index: src/conntrack/getter.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/conntrack/getter.c	(r=C3=A9vision 6720)
+++ src/conntrack/getter.c	(copie de travail)
@@ -157,6 +157,16 @@
 	return &ct->counters[__DIR_REPL].bytes;
 }
=20
+static const void *get_attr_use(const struct nf_conntrack *ct)
+{
+	return &ct->use;
+}
+
+static const void *get_attr_id(const struct nf_conntrack *ct)
+{
+	return &ct->id;
+}
+
 static const void *get_attr_status(const struct nf_conntrack *ct)
 {
 	return &ct->status;
@@ -190,8 +200,10 @@
 	[ATTR_TIMEOUT]			=3D get_attr_timeout,
 	[ATTR_MARK]			=3D get_attr_mark,
 	[ATTR_ORIG_COUNTER_PACKETS] 	=3D get_attr_orig_counter_packets,
=2D	[ATTR_ORIG_COUNTER_BYTES]	=3D get_attr_orig_counter_bytes,
 	[ATTR_REPL_COUNTER_PACKETS]	=3D get_attr_repl_counter_packets,
+	[ATTR_ORIG_COUNTER_BYTES]	=3D get_attr_orig_counter_bytes,
 	[ATTR_REPL_COUNTER_BYTES]	=3D get_attr_repl_counter_bytes,
+	[ATTR_USE]			=3D get_attr_use,
+	[ATTR_ID]			=3D get_attr_id,
 	[ATTR_STATUS]			=3D get_attr_status,
 };

--Boundary-00=_7DNnFvzgYOzuTIQ
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_conntrack_setter.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="libnetfilter_conntrack_setter.patch"

Index: src/conntrack/setter.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/conntrack/setter.c	(r=C3=A9vision 6720)
+++ src/conntrack/setter.c	(copie de travail)
@@ -137,37 +137,73 @@
 	ct->mark =3D *((u_int32_t *) value);
 }
=20
+static void set_attr_orig_counter_packets(struct nf_conntrack *ct, const v=
oid *value)
+{
+	ct->counters[__DIR_ORIG].packets =3D *((u_int64_t *) value);
+}
+
+static void set_attr_repl_counter_packets(struct nf_conntrack *ct, const v=
oid *value)
+{
+	ct->counters[__DIR_REPL].packets =3D *((u_int64_t *) value);
+}
+
+static void set_attr_orig_counter_bytes(struct nf_conntrack *ct, const voi=
d *value)
+{
+	ct->counters[__DIR_ORIG].bytes =3D *((u_int64_t *) value);
+}
+
+static void set_attr_repl_counter_bytes(struct nf_conntrack *ct, const voi=
d *value)
+{
+	ct->counters[__DIR_REPL].bytes =3D *((u_int64_t *) value);
+}
+
+static void set_attr_use(struct nf_conntrack *ct, const void *value)
+{
+	ct->use =3D *((u_int32_t *) value);
+}
+
+static void set_attr_id(struct nf_conntrack *ct, const void *value)
+{
+	ct->id =3D *((u_int32_t *) value);
+}
+
 static void set_attr_status(struct nf_conntrack *ct, const void *value)
 {
 	ct->status |=3D *((u_int32_t *) value);
 }
=20
 set_attr set_attr_array[] =3D {
=2D	[ATTR_ORIG_IPV4_SRC]	=3D set_attr_orig_ipv4_src,
=2D	[ATTR_ORIG_IPV4_DST] 	=3D set_attr_orig_ipv4_dst,
=2D	[ATTR_REPL_IPV4_SRC]	=3D set_attr_repl_ipv4_src,
=2D	[ATTR_REPL_IPV4_DST]	=3D set_attr_repl_ipv4_dst,
=2D	[ATTR_ORIG_IPV6_SRC]	=3D set_attr_orig_ipv6_src,
=2D	[ATTR_ORIG_IPV6_DST]	=3D set_attr_orig_ipv6_dst,
=2D	[ATTR_REPL_IPV6_SRC]	=3D set_attr_repl_ipv6_src,
=2D	[ATTR_REPL_IPV6_DST]	=3D set_attr_repl_ipv6_dst,
=2D	[ATTR_ORIG_PORT_SRC]	=3D set_attr_orig_port_src,
=2D	[ATTR_ORIG_PORT_DST]	=3D set_attr_orig_port_dst,
=2D	[ATTR_REPL_PORT_SRC]	=3D set_attr_repl_port_src,
=2D	[ATTR_REPL_PORT_DST]	=3D set_attr_repl_port_dst,
=2D	[ATTR_ICMP_TYPE]	=3D set_attr_icmp_type,
=2D	[ATTR_ICMP_CODE]	=3D set_attr_icmp_code,
=2D	[ATTR_ICMP_ID]		=3D set_attr_icmp_id,
=2D	[ATTR_ORIG_L3PROTO]	=3D set_attr_orig_l3proto,
=2D	[ATTR_REPL_L3PROTO]	=3D set_attr_repl_l3proto,
=2D	[ATTR_ORIG_L4PROTO]	=3D set_attr_orig_l4proto,
=2D	[ATTR_REPL_L4PROTO]	=3D set_attr_repl_l4proto,
=2D	[ATTR_TCP_STATE]	=3D set_attr_tcp_state,
=2D	[ATTR_SNAT_IPV4]	=3D set_attr_snat_ipv4,
=2D	[ATTR_DNAT_IPV4]	=3D set_attr_dnat_ipv4,
=2D	[ATTR_SNAT_PORT]	=3D set_attr_snat_port,
=2D	[ATTR_DNAT_PORT]	=3D set_attr_dnat_port,
=2D	[ATTR_TIMEOUT]		=3D set_attr_timeout,
=2D	[ATTR_MARK]		=3D set_attr_mark,
=2D	[ATTR_STATUS]		=3D set_attr_status,
+	[ATTR_ORIG_IPV4_SRC]	    =3D set_attr_orig_ipv4_src,
+	[ATTR_ORIG_IPV4_DST] 	    =3D set_attr_orig_ipv4_dst,
+	[ATTR_REPL_IPV4_SRC]	    =3D set_attr_repl_ipv4_src,
+	[ATTR_REPL_IPV4_DST]	    =3D set_attr_repl_ipv4_dst,
+	[ATTR_ORIG_IPV6_SRC]	    =3D set_attr_orig_ipv6_src,
+	[ATTR_ORIG_IPV6_DST]	    =3D set_attr_orig_ipv6_dst,
+	[ATTR_REPL_IPV6_SRC]	    =3D set_attr_repl_ipv6_src,
+	[ATTR_REPL_IPV6_DST]	    =3D set_attr_repl_ipv6_dst,
+	[ATTR_ORIG_PORT_SRC]	    =3D set_attr_orig_port_src,
+	[ATTR_ORIG_PORT_DST]	    =3D set_attr_orig_port_dst,
+	[ATTR_REPL_PORT_SRC]	    =3D set_attr_repl_port_src,
+	[ATTR_REPL_PORT_DST]	    =3D set_attr_repl_port_dst,
+	[ATTR_ICMP_TYPE]	    =3D set_attr_icmp_type,
+	[ATTR_ICMP_CODE]	    =3D set_attr_icmp_code,
+	[ATTR_ICMP_ID]		    =3D set_attr_icmp_id,
+	[ATTR_ORIG_L3PROTO]	    =3D set_attr_orig_l3proto,
+	[ATTR_REPL_L3PROTO]	    =3D set_attr_repl_l3proto,
+	[ATTR_ORIG_L4PROTO]	    =3D set_attr_orig_l4proto,
+	[ATTR_REPL_L4PROTO]	    =3D set_attr_repl_l4proto,
+	[ATTR_TCP_STATE]	    =3D set_attr_tcp_state,
+	[ATTR_SNAT_IPV4]	    =3D set_attr_snat_ipv4,
+	[ATTR_DNAT_IPV4]	    =3D set_attr_dnat_ipv4,
+	[ATTR_SNAT_PORT]	    =3D set_attr_snat_port,
+	[ATTR_DNAT_PORT]	    =3D set_attr_dnat_port,
+	[ATTR_TIMEOUT]		    =3D set_attr_timeout,
+	[ATTR_MARK]		    =3D set_attr_mark,
+	[ATTR_ORIG_COUNTER_PACKETS] =3D set_attr_orig_counter_packets,
+	[ATTR_REPL_COUNTER_PACKETS] =3D set_attr_repl_counter_packets,
+	[ATTR_ORIG_COUNTER_BYTES]   =3D set_attr_orig_counter_bytes,
+	[ATTR_REPL_COUNTER_BYTES]   =3D set_attr_repl_counter_bytes,
+	[ATTR_USE]		    =3D set_attr_use,
+	[ATTR_ID]		    =3D set_attr_id,
+	[ATTR_STATUS]		    =3D set_attr_status,
 };

--Boundary-00=_7DNnFvzgYOzuTIQ--
