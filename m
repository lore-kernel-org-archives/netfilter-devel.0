From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] RFC: quote control and 8bit characters in the data
	portion
Date: Fri, 11 Feb 2005 23:56:28 +0100
Message-ID: <20050211225628.GA27755@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I had difficulties when I wrote tests for H.323, because it is a
binary protocol. With the current nfsim, I have to insert
non-printable characters into the test source code. This is because
print_data() only escapes only very few special characters.

My patch escapes all characters below 0x20 and above 0x7f. This way, I
can write tests for binary protocols in 7bit ASCII.

This is not a viable solution, it is only my first idea to fix this
problem. With my patch, I am still forced to write 'A' instead of
'\x41', even if the hex value is more clear than the letter 'A'.

Any more ideas? What else can be done to improve nfsim's support for
binary protocols? Maybe unescape everything before checking
expectations?

(ah, btw my patch breaks existing nfsim tests which happen to expect
characters that are now escaped. AFAIK none in nfsim-testsuite
affected.)

Max


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-quote_control_and_8bit_chars.patch"

diff -urN nfsim-orig/core/ipv4/ipv4.c nfsim-new/core/ipv4/ipv4.c
--- nfsim-orig/core/ipv4/ipv4.c	Fri Jan  7 04:04:15 2005
+++ nfsim-new/core/ipv4/ipv4.c	Fri Feb 11 23:44:44 2005
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

--pWyiEgJYm5f9v55/--
