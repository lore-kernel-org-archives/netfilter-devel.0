From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim 3/4] escape non-printables and 8bit characters
Date: Mon, 21 Feb 2005 18:21:14 +0100
Message-ID: <20050221172114.GA32447@roonstrasse.net>
References: <20050221171719.GA32254@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050221171719.GA32254@roonstrasse.net>
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


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

escape all non-printable and 8 bit characters in print_data(). This is
required to write nfsim scripts in 7bit US-ASCII.

This patch is actually a repost from:
 http://lists.netfilter.org/pipermail/netfilter-devel/2005-February/018451.html





--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="03-nfsim-escape_non_printable_and_8bit.patch"

Mon Feb 21 16:51:04 CET 2005  max@duempel.org
  * escape all non-printable characters, including 8bit
diff -rN -u nfsim-1-old/core/ipv4/ipv4.c nfsim-1-new/core/ipv4/ipv4.c
--- nfsim-1-old/core/ipv4/ipv4.c	Mon Feb 21 18:05:09 2005
+++ nfsim-1-new/core/ipv4/ipv4.c	Mon Feb 21 17:48:30 2005
@@ -740,6 +740,7 @@
 
 static char *print_data(char *ptr, const char *data, int len)
 {
+	static const char hexbuf[]= "0123456789abcdef";
 	int i;
 
 	ptr += sprintf(ptr, "DATA ");
@@ -759,6 +760,11 @@
 		} else if (data[i] == '\\') {
 			*ptr++ = '\\';
 			*ptr++ = '\\';
+		} else if (data[i] & 0x80 || (data[i] & 0xe0) == 0) {
+			*ptr++ = '\\';
+			*ptr++ = 'x';
+			*ptr++ = hexbuf[(data[i] >> 4) & 0xf];
+			*ptr++ = hexbuf[data[i] & 0xf];
 		} else
 			*ptr++ = data[i];
 	}


--huq684BweRXVnRxX--
