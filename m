From: Peter Parkkali <peter.parkkali@iki.fi>
Subject: Question + patch: FTP conntrack fails to recognize a PORT command
Date: 25 Nov 2003 20:02:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1069783352.19640.104.camel@ferrari>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-z4BzAhCKEvL5/FEU4scd"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-z4BzAhCKEvL5/FEU4scd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

I've found a case where an ftp PORT command is not recognized 
by help() in ip_conntrack_ftp.c. This happens only with one 
particular client, so there could be something wrong w/ the 
client too. Anyway, in this case the address in the PORT command
is not rewritten but instead the 192.168.etc address is let through.

The bug can be avoided by commenting out the "return NF_ACCEPT;"
from line 298 (uhh... 2.4.22 source, not cvs, sorry). This allows
the rest of help() to find the "PORT" string, do NAT etc. 

This works, but since I don't really understand the code, I thought
somebody could advice me on the sanity of this approach? ;) Is it safe
to bypass this check is could the actual bug be somewhere else?


The affected code (patch attached):

        if(!old_seq_aft_nl_set ||
                        (ntohl(tcph->seq) != old_seq_aft_nl)) {
                DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u)\n",
                       old_seq_aft_nl_set ? "":"(UNSET) ",
old_seq_aft_nl);
                return NF_ACCEPT;
        }


   Thanks,
	-peter

-- 
pp / pfp@iki.fi / peter.parkkali@profiz.com / 
040-532 95 80 / +358-40-532 95 80



--=-z4BzAhCKEvL5/FEU4scd
Content-Disposition: attachment; filename=ftp_port_cmd.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ftp_port_cmd.patch; charset=ISO-8859-1

--- net/ipv4/netfilter/ip_conntrack_ftp.c	2003-11-25 19:47:15.000000000 +02=
00
+++ net/ipv4/netfilter/ip_conntrack_ftp.c.orig	2003-11-25 19:06:36.00000000=
0 +0200
@@ -295,7 +295,7 @@
 			(ntohl(tcph->seq) !=3D old_seq_aft_nl)) {
 		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u)\n",
 		       old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
-		// return NF_ACCEPT;
+		return NF_ACCEPT;
 	}
=20
 	/* Initialize IP array to expected address (it's not mentioned

--=-z4BzAhCKEvL5/FEU4scd--
