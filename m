From: =?ISO-8859-1?Q?Pedro_Lamar=E3o?= <pedro.lamarao@globo.com>
Subject: Re: why don't we use /etc/protocols ?
Date: Thu, 01 Apr 2004 21:54:03 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406CB9AB.4090306@globo.com>
References: <4059F06F.1050306@globo.com> <20040328184541.GA7039@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090608020704040001040205"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040328184541.GA7039@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090608020704040001040205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Harald Welte wrote:

> Thanks for your patch.  I think the original idea of that array was to
> have it working even if there is no /etc/protocols (small embedded
> system, ..).
>=20
> So in a 'perfect' world, we would keep our small table for
> commonly-used protocol and only query /etc/protocols if we don't have a=

> match.
>=20
> Please also update iptables.c to make it consistent with
> iptables-save/restore.

I'm sorry to have taken so long to respond.
I've been studying this stuff and preparing a version of iptables-save=20
that outputs in a XML format (with the appropriate DTD). I'm not quite=20
finished yet.

As per your request, I've modified the patch to keep the protocol table.
Peeking more I saw that ip6tables-save.c has code to use=20
getprotobynumber, so I've sort of reproduced that exactly.
The patch got quite small.

And iptables.c uses getprotobynumber in proto-to-name -- if there's=20
somewhere else that requires change, I've not found it by myself.

When I'm finished with my little project, I'll post the code (rather=20
small) to the list for review.

--
  Pedro Lamar=E3o

--------------090608020704040001040205
Content-Type: text/x-patch;
 name="iptables-save.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-save.patch"

? .cdtproject
? .project
? iptables-save.patch
Index: iptables-save.c
===================================================================
RCS file: /cvspublic/iptables/iptables-save.c,v
retrieving revision 1.27
diff -u -r1.27 iptables-save.c
--- iptables-save.c	21 Feb 2004 09:20:34 -0000	1.27
+++ iptables-save.c	2 Apr 2004 00:53:10 -0000
@@ -84,6 +84,13 @@
 		unsigned int i;
 		const char *invertstr = invert ? "! " : "";
 
+                struct protoent *pent = getprotobynumber(proto);
+                if (pent) {
+			printf("-p %s%s ",
+			       invertstr, pent->p_name);
+	                return;
+		}
+
 		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
 			if (chain_protos[i].num == proto) {
 				printf("-p %s%s ",

--------------090608020704040001040205--
