From: "Nix N. Nix" <nix@go-nix.ca>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Sun, 22 Aug 2004 18:26:29 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1093213589.14159.9.camel@dana.go-nix.ca>
References: <1092170081.9955.12.camel@dana.go-nix.ca>
	 <411A1F1D.7080804@trash.net> <1092436283.4792.34.camel@dana.go-nix.ca>
	 <20040819113532.GO3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040819113532.GO3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-08-19 at 07:35, Harald Welte wrote:
> On Fri, Aug 13, 2004 at 06:31:23PM -0400, Nix N. Nix wrote:
> > On Wed, 2004-08-11 at 09:29, Patrick McHardy wrote:
> > > >\1DCC <command> <param> <ip> <port> [<size>]\1\n
> > > >
> > > >...is the format of a DCC command (where <size> is optional).
> > > >
> > > >\1DCC SEND "The Big Movie.avi" 10289477 1011 37546262\1\n
> > > >
> > It turns out that quotes are sent unescaped or otherwise encoded.  Thus,
> > the transfer of a file named |The Big" Movie.avi| results in a DCC
> > string of the form
> 
> Which IRC clients did you test this with?  If we put a change in
> ip_conntrack_irc, we should make sure that it suports all major clients
> in both linux and windows world.

I have tested this with irssi and xchat.  Also, since this is strictly a
refinement on the existing handling, it should work at least as well as
the unmodified code.

> Mh. I don't like this heuristics and I'd rather rewrite that portion of
> the IRC parser in order to be more intelligent.  We have parsed the
> command just before, so we know whether it is a SEND or CHAT or watever.
> 
> So we should make this whole quotation handlign conditional to the SEND
> operation.

Consider the following (slightly more involved) alternative to my
previous patch:

--- orig.ip_conntrack_irc.c	2004-08-22 17:51:00.070119021 -0400
+++ ip_conntrack_irc.c	2004-08-22 17:59:05.692492504 -0400
@@ -64,17 +64,33 @@
 #define DEBUGP(format, args...)
 #endif
 
-int parse_dcc(char *data, char *data_end, u_int32_t * ip, u_int16_t *
port,
-	      char **ad_beg_p, char **ad_end_p)
+int parse_dcc(int dcc_proto_idx, char *data, char *data_end, u_int32_t
* ip,
+	      u_int16_t * port, char **ad_beg_p, char **ad_end_p)
 /* tries to get the ip_addr and port out of a dcc command
    return value: -1 on failure, 0 on success 
-	data		pointer to first byte of DCC command data
-	data_end	pointer to last byte of dcc command data
-	ip		returns parsed ip of dcc command
-	port		returns parsed port of dcc command
-	ad_beg_p	returns pointer to first byte of addr data
-	ad_end_p	returns pointer to last byte of addr data */
+    dcc_proto_idx	index into the array "dccprotos"
+	data			pointer to first byte of DCC command data
+	data_end		pointer to last byte of dcc command data
+	ip				returns parsed ip of dcc command
+	port			returns parsed port of dcc command
+	ad_beg_p		returns pointer to first byte of addr data
+	ad_end_p		returns pointer to last byte of addr data */
 {
+	/* if this is a DCC SEND, then it ends in 3 numeric parameters: <ip>
<port> <filesize> */
+	if (0 == dcc_proto_idx && '"' == *data && data <= data_end - 12) {
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
@@ -166,7 +182,7 @@
 			/* we have at least 
 			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
-			if (parse_dcc((char *)data, data_limit, &dcc_ip,
+			if (parse_dcc(i, (char *)data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
 				/* unable to parse */
 				DEBUGP("unable to parse dcc command\n");
> 
The function calling parse_dcc first computes an index into an array
consisting of DCC <command>s.  This index can be passed to parse_dcc. 
This will restrict my parse_dcc modification to DCC SENDs without making
use of my previous heuristic.

> btw: Your patch didn't declare 'Nix'.  Did you actually try to run this?
I /did/ declare Nix, and I am currently running this code.  Please have
another look at the statement that reads char *third_last_p ...
