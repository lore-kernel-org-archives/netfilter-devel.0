From: "Nix N. Nix" <nix@go-nix.ca>
Subject: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Tue, 10 Aug 2004 16:34:41 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092170081.9955.12.camel@dana.go-nix.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hi!

The dcc_parse function in ip_conntrack_irc.c has a shortcoming:

\1DCC <command> <param> <ip> <port> [<size>]\1\n

...is the format of a DCC command (where <size> is optional).

dcc_parse is responsible for finding the ip and port in this string.  It
gets the string starting at <param>.  Unfortunately, so far, dcc_parse
assumed that <param> does not contain any spaces.  Thus, the module
failed to track connections implied by a string of the form

\1DCC SEND "The Big Movie.avi" 10289477 1011 37546262\1\n

I have remedied this problem by having it check whether there's a double
quote and, if so, loop on to the corresponding closing double quote
before resuming normal processing:

--- ip_conntrack_irc.c  2003-11-28 13:26:21.000000000 -0500
+++ mod.ip_conntrack_irc.c      2004-08-10 16:07:49.000000000 -0400
@@ -83,6 +83,14 @@
        ad_end_p        returns pointer to last byte of addr data */
 {
  
+       /* file names with spaces in them are double-quoted */
+       if ('"' == *data && data <= data_end - 12) {
+               *data++ ;
+               while (*data++ != '"')
+                       if (data > data_end - 12)
+                               return -1;
+       }
+
        /* at least 12: "AAAAAAAA P\1\n" */
        while (*data++ != ' ')
                if (data > data_end - 12)

This fixes the problem with spaces in file names, and does not affect
DCC CHAT, because, in those cases, <param> always= chat .

I have tested this in kernel vanilla 2.4.24.
