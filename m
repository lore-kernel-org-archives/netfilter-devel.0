From: Andrew Kozachenko <andrew@entri.com.ua>
Subject: patch for ulogd pgsql output plugin
Date: Fri, 08 Apr 2005 12:58:24 +0300
Message-ID: <425655C0.1080903@entri.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
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

Bug in pgsql/ulogd_PGSQL.c causes ifinite loop on ulogd-1.21 startup.
Here is the fix.

Index: pgsql/ulogd_PGSQL.c
===================================================================
--- pgsql/ulogd_PGSQL.c (revision 56)
+++ pgsql/ulogd_PGSQL.c (working copy)
@@ -81,7 +81,7 @@
 };
 
 static config_entry_t port_ce = {
-       .next = &port_ce,
+       .next = &table_ce,
        .key = "port",
        .type = CONFIG_TYPE_INT,
        .options = CONFIG_OPT_NONE,


-- 
Regards,
Andrew Kozachenko
Entri ltd.

    
Look at the source, Luke.
