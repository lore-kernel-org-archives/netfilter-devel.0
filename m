From: Daniel De Graaf <danield@iastate.edu>
Subject: Re: [PATCH] ipt_recent: add module parameter for changing GID of
 /proc/net/ipt_recent/*
Date: Sat, 08 Jul 2006 12:21:44 -0500
Message-ID: <44AFE9A8.30203@iastate.edu>
References: <44AF0E7E.70507@iastate.edu> <44AF205F.3070600@trash.net>
	<44AF259F.6000204@iastate.edu> <44AF8C1C.8070800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020105070602040907080808"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44AF8C1C.8070800@trash.net>
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
--------------020105070602040907080808
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Patrick McHardy wrote:
> Daniel De Graaf wrote:
>> Patrick McHardy wrote:
>>
>>>> Daniel De Graaf wrote:
>>>>
>>>>> This patch adds an ip_list_gid module parameter to
>>>>> ipt_recent, which is meant to be used in combination with
>>>>> the ip_list_perms. In the current implementation, the files
>>>>> must either be world-writable or require programs which
>>>>> write to them to be (at least) setgid root.
>>>>>
>> Here's an updated patch against 2.6.18-rc1.
>
>
> I'm fine doing this, but just allowing to set group ownership
> without user ownership will probably soon make someone else send me
> a second patch, so please take care of this as well. Please also
> make sure your patch applies with -p1 in the kernel tree root and
> don't forget to sign off.
>
Patch with UID setting and sign-off.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEr+mnZz9quLVV3/MRAh+VAJ0a1oTXKgSPRhYK4tczTfQ7EV8LjQCgjyFN
WSipG6xM0sS5TTNi40IuM5M=
=DKBS
-----END PGP SIGNATURE-----


--------------020105070602040907080808
Content-Type: text/x-patch;
 name="ipt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_recent.patch"

Add support for setting the UID and GID of /proc/net/ipt_recent/* files.

Signed-off-by: Daniel De Graaf <danield@iastate.edu>

===================================================================
--- a/net/ipv4/netfilter/ipt_recent.c	2006-07-07 22:17:37.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_recent.c	2006-07-08 11:49:10.000000000 -0500
@@ -35,14 +35,20 @@
 static unsigned int ip_pkt_list_tot = 20;
 static unsigned int ip_list_hash_size = 0;
 static unsigned int ip_list_perms = 0644;
+static unsigned int ip_list_uid = 0;
+static unsigned int ip_list_gid = 0;
 module_param(ip_list_tot, uint, 0400);
 module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
+module_param(ip_list_uid, uint, 0400);
+module_param(ip_list_gid, uint, 0400);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remember (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* files");
 
 
 struct recent_entry {
@@ -274,6 +280,8 @@
 		goto out;
 	}
 	t->proc->proc_fops = &recent_fops;
+	t->proc->uid       = ip_list_uid;
+	t->proc->gid       = ip_list_gid;
 	t->proc->data      = t;
 #endif
 	spin_lock_bh(&recent_lock);

--------------020105070602040907080808--
