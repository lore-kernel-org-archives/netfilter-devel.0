From: Thomas Karlsson <netfilter@planet.eu.org>
Subject: bugfix for ip_conntrack_irc
Date: Sat, 10 May 2003 14:00:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.55.0305101334520.463@thorix.in.space.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi

Here comes a bugfix for the ip_conntrack_irc module. The fix makes it
possible to send files to other irc users With the character "space" in
the filename.
A DCC SEND packet looks like this:
0x0030   2f2d 3bb3 5052 4956 4d53 4720 7473 7420        ..;.PRIVMSG.tst.
0x0040   3a01 4443 4320 5345 4e44 2070 6c75 6769        :.DCC.SEND.plugi
0x0050   6e31 3331 5f30 322e 7472 6163 6520 3130        n131_02.trace.10
0x0060   3438 3437 3932 3920 3332 3839 3420 3130        4847929.32894.10
0x0070   3931 010d 0a                                   91...

When the ip_conntrack_irc module parses DCC SEND packets it looks for the
space-character as the delimiter between the filename,ipaddress, port and
filesize. Now IF the filename contains a space then the parse will stop
and remaining filename will be used as the ipaddress and port.

What I have done in the patch is to parse the packet backwards to get the
real position of the ipaddress and port.

--- org.ip_conntrack_irc.c      Mon Apr 21 22:25:51 2003
+++ ip_conntrack_irc.c  Mon Apr 21 22:28:21 2003
@@ -82,11 +82,22 @@
        ad_beg_p        returns pointer to first byte of addr data
        ad_end_p        returns pointer to last byte of addr data */
 {
+       int space=0;                    /* Set spaces found to zero */

        /* at least 12: "AAAAAAAA P\1\n" */
        while (*data++ != ' ')
                if (data > data_end - 12)
                        return -1;
+
+        data = data_end;               /* we want to go to the end of
data */
+
+        while ( space < 3 ) {
+                data--;                 /* Go back one step */
+                if ( *data == ' ')      /* if space is found, the last
number also */
+                        space++;        /* Add a space found */
+        }
+       while (*data++ != ' ');
+       DEBUGP("This should be the correct data !%s!",data);

        *ad_beg_p = data;
        *ip = simple_strtoul(data, &data, 10);

//Thomas Karlsson
