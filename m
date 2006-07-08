From: Daniel De Graaf <danield@iastate.edu>
Subject: Re: [PATCH] ipt_recent: add module parameter for changing GID of
 /proc/net/ipt_recent/*
Date: Fri, 07 Jul 2006 22:25:19 -0500
Message-ID: <44AF259F.6000204@iastate.edu>
References: <44AF0E7E.70507@iastate.edu> <44AF205F.3070600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040202010505040701010507"
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44AF205F.3070600@trash.net>
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
--------------040202010505040701010507
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Patrick McHardy wrote:
> Daniel De Graaf wrote:
>> This patch adds an ip_list_gid module parameter to ipt_recent,
>> which is meant to be used in combination with the ip_list_perms.
>> In the current implementation, the files must either be
>> world-writable or require programs which write to them to be (at
>> least) setgid root.
>>
>> - Daniel De Graaf
>
> /* Structure of our list of recently seen addresses. */ struct
> recent_ip_list { @@ -852,6 +855,7 @@ } 
> curr_table->status_proc->owner = THIS_MODULE; +
> curr_table->status_proc->gid = ip_list_gid;
> curr_table->status_proc->data = curr_table; wmb();
> curr_table->status_proc->read_proc = ip_recent_get_info;
>
>
> That code is gone for good, please check if your patch is still
> necessary for current -git and resubmit in case it is.
Here's an updated patch against 2.6.18-rc1.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEryWfZz9quLVV3/MRAoFbAJ0bl5jhgADEm4ppII7etF4g4/Qc5ACfRtzQ
27lEptoQ9kHdv5XusVx7L1w=
=VJVi
-----END PGP SIGNATURE-----


--------------040202010505040701010507
Content-Type: text/x-patch;
 name="ipt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_recent.patch"

--- ipt_recent.c.old	2006-07-07 22:17:37.000000000 -0500
+++ ipt_recent.c	2006-07-07 22:23:36.000000000 -0500
@@ -35,14 +35,17 @@
 static unsigned int ip_pkt_list_tot = 20;
 static unsigned int ip_list_hash_size = 0;
 static unsigned int ip_list_perms = 0644;
+static unsigned int ip_list_gid = 0;
 module_param(ip_list_tot, uint, 0400);
 module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
+module_param(ip_list_gid, uint, 0400);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remember (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* files");
 
 
 struct recent_entry {
@@ -274,6 +277,7 @@
 		goto out;
 	}
 	t->proc->proc_fops = &recent_fops;
+	t->proc->gid       = ip_list_gid;
 	t->proc->data      = t;
 #endif
 	spin_lock_bh(&recent_lock);

--------------040202010505040701010507--
