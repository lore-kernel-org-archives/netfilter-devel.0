From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: [PATCH] libip6t_tcp
Date: Mon, 8 Jul 2002 09:56:51 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708095651.A17100@sch.bme.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

2 misstyping bug in libip6t_tcp.c.

Regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /-----Member of the BUTE-MIS-SEARCHlab---------->

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tcp6.20020708"

--- netfilter.old/userspace/extensions/libip6t_tcp.c	Mon Jul  8 09:44:13 2002
+++ netfilter/userspace/extensions/libip6t_tcp.c	Mon Jul  8 09:47:52 2002
@@ -143,7 +143,7 @@
 {
 	unsigned int ret;
 
-	if (string_to_number(option, 1, 266, &ret) == -1)
+	if (string_to_number(option, 1, 255, &ret) == -1)
 		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
 
 	*result = (u_int8_t)ret;
@@ -371,7 +371,7 @@
 	const struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)match->data;
 
 	if (tcpinfo->spts[0] != 0
-	    && tcpinfo->spts[1] != 0xFFFF) {
+	    || tcpinfo->spts[1] != 0xFFFF) {
 		if (tcpinfo->invflags & IP6T_TCP_INV_SRCPT)
 			printf("! ");
 		if (tcpinfo->spts[0]

--pWyiEgJYm5f9v55/--
