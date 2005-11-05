From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] libnetfilter_queue nfattr[] abstraction
Date: Sat, 05 Nov 2005 13:51:23 +0100
Message-ID: <1131195083.11473.10.camel@localhost.localdomain>
References: <1131063778.11853.6.camel@localhost.localdomain>
	<20051105091854.GR5594@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FnIX71bUErWCwslIJNfB"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051105091854.GR5594@sunbeam.de.gnumonks.org>
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


--=-FnIX71bUErWCwslIJNfB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le samedi 05 novembre 2005 =E0 10:18 +0100, Harald Welte a =E9crit :
> On Fri, Nov 04, 2005 at 01:22:58AM +0100, Eric Leblond wrote:
> > Hi,
> > I've checked the provided test util and NuFW against the modified
> > library.
>=20
> Please re-check after my changes went in (maybe in 30mins).

Done. I've found a problem with timestamp related function. timestamp
structure can not be renamed as it is defined in kernel.
I attach a patch that correct this.

For timestamp, we could use the glibc "struct timeval" but the user will
have to free the structure after use as it is not a pointer to the
message from kernel.

BR,
--=20
Eric Leblond <eric@inl.fr>

--=-FnIX71bUErWCwslIJNfB
Content-Disposition: attachment; filename=libnetfilter_queue.diff
Content-Type: text/x-patch; name=libnetfilter_queue.diff; charset=us-ascii
Content-Transfer-Encoding: 7bit

=== include/libnetfilter_queue/libnetfilter_queue.h
==================================================================
--- include/libnetfilter_queue/libnetfilter_queue.h	(revision 1282)
+++ include/libnetfilter_queue/libnetfilter_queue.h	(local)
@@ -68,7 +68,7 @@
 
 extern u_int32_t nfq_get_nfmark(struct nfq_data *nfad);
 
-extern struct nfq_msg_packet_timestamp *
+extern struct nfqnl_msg_packet_timestamp *
 				nfq_get_timestamp(struct nfq_data *nfad);
 
 /* return 0 if not set */
=== src/libnetfilter_queue.c
==================================================================
--- src/libnetfilter_queue.c	(revision 1282)
+++ src/libnetfilter_queue.c	(local)
@@ -336,7 +335,7 @@
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, u_int32_t));
 }
 
-struct nfq_msg_packet_timestamp *nfq_get_timestamp(struct nfq_data *nfad)
+struct nfqnl_msg_packet_timestamp *nfq_get_timestamp(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_TIMESTAMP,
 					struct nfq_msg_packet_timestamp);

--=-FnIX71bUErWCwslIJNfB--
