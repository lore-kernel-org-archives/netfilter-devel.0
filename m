From: Ozgur AKAN <akan@aiqa.com>
Subject: [PATCH] coding style
Date: Thu, 22 Apr 2004 13:37:07 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4087A053.8070206@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040305010500020904040200"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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
--------------040305010500020904040200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

A minor patch for better code style in iptables-save.c. 

-- 
Ozgur Akan


--------------040305010500020904040200
Content-Type: text/plain;
 name="print_ip_code_style.PATCH"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="print_ip_code_style.PATCH"

--- iptables/iptables-save.c	2004-04-22 11:53:14.436259656 +0300
+++ iptables_dev/iptables-save.c	2004-04-22 11:54:14.218171424 +0300
@@ -150,9 +150,9 @@ static void print_ip(char *prefix, u_int
 		IP_PARTS(ip));
 
 	if (mask != 0xffffffff) 
-		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
-	else
-		printf(" ");
+		printf("/%u.%u.%u.%u", IP_PARTS(mask));
+	
+	printf(" ");
 }
 
 /* We want this to be readable, so only print out neccessary fields.

--------------040305010500020904040200--
