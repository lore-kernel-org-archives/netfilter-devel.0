From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: [PATCH]Re: sparc64 ipv6 ip6tables nogo
Date: Thu, 26 Sep 2002 18:48:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1033058911.1015.13.camel@arwen>
References: <20020912155314.GA20741@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_GGBzfLE7OwqwBMfQ9oRY+A)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <20020912155314.GA20741@paradigm.rfc822.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary_(ID_GGBzfLE7OwqwBMfQ9oRY+A)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Hi,

(I send the patch to the Netfilter-Devel list, too. I forgot it :()
> i seem to have been hit by a ip6tables problem on sparc64 - It seems
> that there are some hidden 64bit kernel / 32 bit userspace problems
> somewhere in netfilter (Same happened with tunnel ioctls on sparc64)
One quick workaround is attached for this problem. (The counter-problem
remained)
Thanks to: Florian Lohoff <flo@rfc822.org>

Regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /------------------------------------------->

--Boundary_(ID_GGBzfLE7OwqwBMfQ9oRY+A)
Content-type: text/plain; name=align.20020926; charset=ISO-8859-2
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=align.20020926

--- linux/net/ipv6/netfilter/ip6_tables.c.as	2002-09-26 18:28:27.000000000 +0200
+++ linux/net/ipv6/netfilter/ip6_tables.c	2002-09-26 18:31:54.000000000 +0200
@@ -101,10 +101,8 @@
 	unsigned int hook_entry[NF_IP6_NUMHOOKS];
 	unsigned int underflow[NF_IP6_NUMHOOKS];
 
-	char padding[SMP_ALIGN((NF_IP6_NUMHOOKS*2+2)*sizeof(unsigned int))];
-
 	/* ip6t_entry tables: one per CPU */
-	char entries[0];
+	char entries[0] ____cacheline_aligned;
 };
 
 static LIST_HEAD(ip6t_target);
@@ -1449,7 +1447,7 @@
 	int ret;
 	struct ip6t_table_info *newinfo;
 	static struct ip6t_table_info bootstrap
-		= { 0, 0, 0, { 0 }, { 0 }, { }, { } };
+		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	MOD_INC_USE_COUNT;
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)

--Boundary_(ID_GGBzfLE7OwqwBMfQ9oRY+A)--
