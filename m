From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]   Dead code elimination in ip_conntrack_core.c
Date: Sat, 15 Mar 2003 12:30:04 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E73631C.1060102@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_04zQ9GGhZjtsH58eNbrpFg)"
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

This is a multi-part message in MIME format.

--Boundary_(ID_04zQ9GGhZjtsH58eNbrpFg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

List members,

    the following cosmetic patch removes dead code in 
ip_conntrack_init() if CONFIG_SYSCTL is not defined.
The patch applies against a plain 2.4.21-pre5-ac3 kernel.

Regards,

Stephane Ouellette


--Boundary_(ID_04zQ9GGhZjtsH58eNbrpFg)
Content-type: text/plain; name=ip_conntrack_core.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ip_conntrack_core.c.patch

--- linux-2.4.21-pre5-ac3/net/ipv4/netfilter/ip_conntrack_core.c	Sat Mar 15 12:16:55 2003
+++ linux-2.4.21-pre5-ac3-fixed/net/ipv4/netfilter/ip_conntrack_core.c	Sat Mar 15 12:23:34 2003
@@ -1478,8 +1478,10 @@
 	ip_ct_attach = ip_conntrack_attach;
 	return ret;
 
+#ifdef CONFIG_SYSCTL
 err_free_ct_cachep:
 	kmem_cache_destroy(ip_conntrack_cachep);
+#endif /*CONFIG_SYSCTL*/
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:

--Boundary_(ID_04zQ9GGhZjtsH58eNbrpFg)--
