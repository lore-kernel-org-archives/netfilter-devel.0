From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] TCP window tracking over-window handling
Date: Fri, 28 Jan 2005 15:43:34 -0800
Message-ID: <20050128234334.GA20713@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This was a tough one to track down, and also tough to explain...

In cases of packet loss, some broken TCP stacks will send data over the
window of the receiver.  Then, on the next packet they will resend the
missing packet, then move on.  

The current window tracking code 'ignores' this window overage by resetting
the end of the packet to the theoretical maximum (corrects the math of the
stupid sender).

Unfortunately, the sender does receive this over-the-window packet, and does 
increment its ack seq.  So on the next ack after receiving the missing
packet, the receiver acks with the ack seq it knows about, which is higher
than that which the window tracking code thinks it has seen.  Consequently,
it complains that the ACK is over the upper bound, and does not adjust
the window.

After this, communications cease, as each new packet from the sender is
dropped by the window tracking code -- it thinks it is over the window
of the sender.

So, we have seen situations where large ftp transfers stop midstream, but
smaller transfers complete fine (they got lucky).  I've attached a tcpdump
log at the bottom of this message with some annotation and conntrack
debugging inserted in appropriate locations for the interested.

The solution IMO is not to correct the math of the sender -- there is no
benefit to doing so.  The attached patch does this (and also clarifies
the language in some debugging code).

Patrick: this is incremental to the retransmission handling patch you have
already queued up.  Like that patch, I think this should go into 2.6.11.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-overwindow

diff -ru linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-testdellfw/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-28 17:48:10.620973992 -0500
+++ linux-testdellfw/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-28 17:54:02.799434728 -0500
@@ -622,7 +622,6 @@
 	/* Ignore data over the right edge of the receiver's window. */
 	if (after(end, sender->td_maxend) &&
 	    before(seq, sender->td_maxend)) {
-		end = sender->td_maxend;
 		if (*index == TCP_FIN_SET)
 			*index = TCP_ACK_SET;
 	}
@@ -691,9 +690,9 @@
 			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
 			before(sack, receiver->td_end + 1) ?
 			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
-			: "ACK is under the lower bound (possibly overly delayed ACK)"
-			: "ACK is over the upper bound (ACKed data has never seen yet)"
-			: "SEQ is under the lower bound (retransmitted already ACKed data)"
+			: "ACK is under the lower bound (possible overly delayed ACK)"
+			: "ACK is over the upper bound (ACKed data not seen yet)"
+			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
 
 		res = ip_ct_tcp_be_liberal && !tcph->rst;

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dump

00:29:51.936687 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692880475:3692881855(1380) ack 4116033054 win 8280
00:29:51.936767 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692865295 win 32767
----> packet lost here
00:29:51.977254 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692865295:3692866675(1380) ack 4116033054 win 8280
00:29:51.977340 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.014823 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692883235:3692884615(1380) ack 4116033054 win 8280
00:29:52.014937 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.055532 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692884615:3692885995(1380) ack 4116033054 win 8280
00:29:52.055613 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.055676 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692885995:3692887375(1380) ack 4116033054 win 8280
00:29:52.055758 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.055960 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692887375:3692888755(1380) ack 4116033054 win 8280
00:29:52.056036 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.056248 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692888755:3692890135(1380) ack 4116033054 win 8280
00:29:52.056324 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.093099 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692890135:3692891515(1380) ack 4116033054 win 8280
00:29:52.093178 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.134237 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692891515:3692892895(1380) ack 4116033054 win 8280
00:29:52.134316 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.134525 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692892895:3692894275(1380) ack 4116033054 win 8280
00:29:52.134604 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.171234 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692894275:3692895655(1380) ack 4116033054 win 8280
00:29:52.171314 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.212371 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692895655:3692897035(1380) ack 4116033054 win 8280
00:29:52.212450 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.212800 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692897035:3692898415(1380) ack 4116033054 win 8280
00:29:52.212876 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.249368 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692898415:3692899795(1380) ack 4116033054 win 8280
00:29:52.249448 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.290649 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692899795:3692901175(1380) ack 4116033054 win 8280
00:29:52.290736 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.291077 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692901175:3692902555(1380) ack 4116033054 win 8280
00:29:52.291158 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.327645 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692902555:3692903935(1380) ack 4116033054 win 8280
00:29:52.327729 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.368927 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692903935:3692905315(1380) ack 4116033054 win 8280
00:29:52.369020 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.369214 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692905315:3692906695(1380) ack 4116033054 win 8280
00:29:52.369293 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.405923 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692906695:3692908075(1380) ack 4116033054 win 8280
00:29:52.406004 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.447204 IP x.x.113.7.2877 > x.x.11.14.32773: P 3692908075:3692909455(1380) ack 4116033054 win 8280
00:29:52.447286 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.447633 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692909455:3692910835(1380) ack 4116033054 win 8280
00:29:52.447712 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.484343 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692910835:3692912215(1380) ack 4116033054 win 8280
00:29:52.484424 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
00:29:52.525338 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692912215:3692913595(1380) ack 4116033054 win 8280
00:29:52.525435 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
----> sender sends data over the window here.  tracking code adjusts end to maxend
00:29:52.525910 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692913595:3692914975(1380) ack 4116033054 win 8280
00:29:52.656511 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692881855 win 32767
----> sender resends the missing packet:
00:29:53.333968 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692881855:3692883235(1380) ack 4116033054 win 8280
----> receiver acks up to the full range it has received, which now does not match tracking code:
00:29:53.811731 IP x.x.11.14.32773 > x.x.113.7.2877: . ack 3692914975 win 32767
----> kernel complains, and we see it believes the max data seen is 3692914622
Jan 28 00:29:53 fw02 kernel: ip_ct_tcp: ACK is over the upper bound (ACKed data has never seen yet) IN= OUT= SRC=x.x.11.14 DST=x.x.113.7 LEN=40 TOS=0x08 PREC=0x00 TTL=64 ID=48752 DF PROTO=TCP SPT=32773 DPT=2877 SEQ=4116033054 ACK=3692914975 WINDOW=32767 RES=0x00 ACK URGP=0 
Jan 28 00:29:53 fw02 kernel: tcp_in_window: res=0 sender end=4116033054 maxend=4116041334 maxwin=32767 receiver end=3692914622 maxend=3692914622 maxwin=8280
----> all is lost now...sender cannot send any packets which appear legal to tracking code:
00:29:53.889995 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692914975:3692916355(1380) ack 4116033054 win 8280
00:29:54.372055 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692916355:3692917735(1380) ack 4116033054 win 8280
00:29:56.286994 IP x.x.113.7.2877 > x.x.11.14.32773: . 3692914975:3692916355(1380) ack 4116033054 win 8280


--x+6KMIRAuhnl3hBn--
