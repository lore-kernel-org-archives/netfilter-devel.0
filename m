From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 3/3] [conntrack] fixed duration connection
Date: Sat, 08 Apr 2006 00:08:04 +0200
Message-ID: <4436E2C4.1030303@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>	<4433CCBF.6060103@trash.net>
	<4436DF6B.4060208@inl.fr> <4436E156.5010306@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040205050008070404040508"
Cc: Patrick McHardy <kaber@trash.net>, nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4436E156.5010306@inl.fr>
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

This is a multi-part message in MIME format.
--------------040205050008070404040508
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi again,

This is better with the patch...

All my apologies

BR,

Eric Leblond wrote:
> Hi,
> 
> This patch against conntrack tool adds support for fixed connection. for
> example  :
>  conntrack  -U -d 153.113.34.136 -s 192.168.11.32 -p tcp \\
> 	--orig-port-src 59119 --orig-port-dst 22 -t 10 \\
> 	-u ASSURED,SEEN_REPLY,FIXED_TIMEOUT
> will fix timeout of connection to 10 seconds after command.
> 
> BR,


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFENuLEnxA7CdMWjzIRAiKaAJ9tC+/xQ44ibVF1ioAakWn9JC7mbgCdFGiO
vZLLCcIN08G45vaNsru4TAw=
=BWXz
-----END PGP SIGNATURE-----

--------------040205050008070404040508
Content-Type: text/x-patch;
 name="conntrack_fixed_timeout-flag.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="conntrack_fixed_timeout-flag.patch"

Index: src/conntrack.c
===================================================================
--- src/conntrack.c	(révision 6578)
+++ src/conntrack.c	(copie de travail)
@@ -335,13 +335,13 @@
 #define PARSE_MAX 2
 
 static struct parse_parameter {
-	char 	*parameter[5];
+	char 	*parameter[6];
 	size_t  size;
-	unsigned int value[5];
+	unsigned int value[6];
 } parse_array[PARSE_MAX] = {
-	{ {"ASSURED", "SEEN_REPLY", "UNSET", "SRC_NAT", "DST_NAT"}, 5,
+	{ {"ASSURED", "SEEN_REPLY", "UNSET", "SRC_NAT", "DST_NAT","FIXED_TIMEOUT"}, 6,
 	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, 
-	    IPS_SRC_NAT_DONE, IPS_DST_NAT_DONE} },
+	    IPS_SRC_NAT_DONE, IPS_DST_NAT_DONE, IPS_FIXED_TIMEOUT} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  {~0U, NF_NETLINK_CONNTRACK_NEW, NF_NETLINK_CONNTRACK_UPDATE, 
 	   NF_NETLINK_CONNTRACK_DESTROY} },

--------------040205050008070404040508--
