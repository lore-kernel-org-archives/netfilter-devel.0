From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  Missing include files for libiptc.c
Date: Tue, 11 May 2004 11:33:17 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A0F23D.5050102@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_OIMYdE82LoUO0qCHGdSx/g)"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

--Boundary_(ID_OIMYdE82LoUO0qCHGdSx/g)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   the following patch fixes a few compile warnings by including the two 
missing files.

Stephane Ouellette


--Boundary_(ID_OIMYdE82LoUO0qCHGdSx/g)
Content-type: text/plain; name=libiptc.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libiptc.c.patch

--- iptables/libiptc/libiptc.c	Sat Jan 31 10:33:55 2004
+++ iptables-fixed/libiptc/libiptc.c	Tue May 11 11:28:01 2004
@@ -20,6 +20,9 @@
  * 	  up after a ruleset change.  
  */
 
+#include<sys/types.h>
+#include<sys/socket.h>
+
 #ifndef IPT_LIB_DIR
 #define IPT_LIB_DIR "/usr/local/lib/iptables"
 #endif

--Boundary_(ID_OIMYdE82LoUO0qCHGdSx/g)--
