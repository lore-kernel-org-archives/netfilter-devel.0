From: "Nix N. Nix" <nix@go-nix.ca>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Fri, 13 Aug 2004 18:31:23 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092436283.4792.34.camel@dana.go-nix.ca>
References: <1092170081.9955.12.camel@dana.go-nix.ca>
	 <411A1F1D.7080804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <411A1F1D.7080804@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-08-11 at 09:29, Patrick McHardy wrote:
> >\1DCC <command> <param> <ip> <port> [<size>]\1\n
> >
> >...is the format of a DCC command (where <size> is optional).
> >
> >dcc_parse is responsible for finding the ip and port in this string.  It
> >gets the string starting at <param>.  Unfortunately, so far, dcc_parse
> >assumed that <param> does not contain any spaces.  Thus, the module
> >failed to track connections implied by a string of the form
> >
> >\1DCC SEND "The Big Movie.avi" 10289477 1011 37546262\1\n
> >
> How do filenames which contain a quotation mark look ? I assume the 
> quotation
> marks is escaped ? We should also handle this case.

It turns out that quotes are sent unescaped or otherwise encoded.  Thus,
the transfer of a file named |The Big" Movie.avi| results in a DCC
string of the form

\1DCC SEND "The Big" Movie.avi" 10289477 1011 37546262\1\n

As a result, my previously proposed patch fails.  However, I have found
what I think is another useable rationale:

If <command> starts with a quote then the string is guaranteed to
describe a DCC file transfer and, since all strings indicating DCC file
transfers end in 3 numeric parameters (<ip> <port> <filesize>), we need
only find the beginning of the third-last parameter.

In all other cases, we can skip over the code embodying the above
rationale, directly to the existing code.  Thus, the patch:

--- orig.ip_conntrack_irc.c	2003-11-28 13:26:21.000000000 -0500
+++ ip_conntrack_irc.c	2004-08-13 18:13:20.000000000 -0400
@@ -82,6 +82,24 @@
 	ad_beg_p	returns pointer to first byte of addr data
 	ad_end_p	returns pointer to last byte of addr data */
 {
+	/* if the DCC command parameter starts with a quote then this is
+       a DCC file operation, which means it ends in 3 numeric
+       parameters: 
+       <ip> <port> <filesize> */
+	if ('"' == *data && data <= data_end - 12) {
+		char *third_last_p = data, 
+			 *second_last_p = data, 
+			 *last_p = data, *Nix;
+
+        for (Nix = data ; Nix < data_end - 1 ; Nix++) {
+        	if (' ' == *Nix) {
+                third_last_p = second_last_p ;
+                second_last_p = last_p ;
+                last_p = Nix + 1 ;
+			}
+		}
+		data = third_last_p - 1 ;
+	}
 
 	/* at least 12: "AAAAAAAA P\1\n" */
 	while (*data++ != ' ')

Please let me know what you think of it.
