From: "dravya" <dravya@magma.ca>
Subject: Re: icmp packets going over the wrong link!!!!
Date: Fri, 5 Nov 2004 10:43:33 -0500 (EST)
Message-ID: <200411051543.iA5FhXSP019670@webmail2.magma.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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


> Please describe your setup in more detail and show some examples
> of the packets with wrong address.
> 
> Regards
> Patrick
 
ICMP Packets going over wrong link:

If you have any questions, PLEASE don't hesistate to ask.


SETUP:
                   ppp0   ppp1
		    |      |	
		  ------------ 
                 | linux box  |
		  ------------			
			|
			|
      Laptop (Any client with Linux box as gateway)    	


ppp0: 69.158.208.231
ppp1: 204.101.81.168
linux box: 192.168.1.93
laptop: 192.168.1.85 (Accesses internet via gateway --> 192.168.1.93)


TEST 1: From laptop --> ping www.nba.com -n 10

----------------------------------------------------------------------------------

On LINUX BOX:

/usr/sbin/tethereal -i ppp1:

  0.000000 204.101.81.168 -> 209.226.175.236 DNS Standard query A www.nba.com
  0.999774 204.101.81.168 -> 209.226.175.236 DNS Standard query A www.nba.com
  3.000458 204.101.81.168 -> 209.226.175.236 DNS Standard query A www.nba.com
  3.720736 209.226.175.236 -> 204.101.81.168 DNS Standard query response CNAME
www.nba.com.edgesuite.net CNAME a1570.gd.akamai.net A 207.61.132.10 A 207.61.132.35
  4.296769 209.226.175.236 -> 204.101.81.168 DNS Standard query response CNAME
www.nba.com.edgesuite.net CNAME a1570.gd.akamai.net A 207.61.132.10 A 207.61.132.35
  4.434785 209.226.175.236 -> 204.101.81.168 DNS Standard query response CNAME
www.nba.com.edgesuite.net CNAME a1570.gd.akamai.net A 207.61.132.10 A 207.61.132.35
  5.016470 69.158.208.231 -> 207.61.132.10 ICMP Echo (ping) request  <-- ppp0's src
addr!!!!!!!!!!!
tethereal: Error while capturing packets: recvfrom: Network is down  <-- tethereal dies...


/usr/sbin/tethereal -i ppp0:

  0.000000 69.158.208.231 -> 207.61.132.10 ICMP Echo (ping) request
  2.273904 69.158.208.231 -> 207.61.132.10 ICMP Echo (ping) request
  4.047609 207.61.132.10 -> 69.158.208.231 ICMP Echo (ping) reply
  4.111612 207.61.132.10 -> 69.158.208.231 ICMP Echo (ping) reply
  4.277095 69.158.208.231 -> 207.61.132.10 ICMP Echo (ping) request
  4.623649 207.61.132.10 -> 69.158.208.231 ICMP Echo (ping) reply
  6.279748 69.158.208.231 -> 207.61.132.10 ICMP Echo (ping) request
  6.910795 207.61.132.10 -> 69.158.208.231 ICMP Echo (ping) reply
  8.782826 69.158.208.231 -> 207.61.132.10 ICMP Echo (ping) request
  9.101956 207.61.132.10 -> 69.158.208.231 ICMP Echo (ping) reply
----------------------------------------------------------------------------------


As you can see, the first ICMP Echo request out of ppp1 has the src addr of ppp0 and every
subsequent echo requests (for this set of pings) through ppp1 will go out with the wrong
src address (this causes a change of ip address of ppp1).

I have tested, using sequence numbers from ethereal, LOGging echo requests and printouts
in the MASQUERADE code, that bad packets (wrong src address) do not go through the
MASQUERADING code at all. Infact, ONCE a bad packet it sent out, all the other echo
requests (that get replies) also don't go through the MASQUERADING CODE. The following are
the results of that test:


TEST 2: from laptop --> ping www.nba.com

----------------------------------------------------------------------------------
/usr/sbin/tethereal -i ppp0:

 87.576267 69.158.208.231 -> 64.26.141.78 ICMP Echo (ping) request
 90.538898 69.158.208.231 -> 64.26.141.78 ICMP Echo (ping) request
 91.392153 64.26.141.78 -> 69.158.208.231 ICMP Echo (ping) reply
 91.440157 64.26.141.78 -> 69.158.208.231 ICMP Echo (ping) reply
 91.546307 69.158.208.231 -> 64.26.141.78 ICMP Echo (ping) request
 91.872192 64.26.141.78 -> 69.158.208.231 ICMP Echo (ping) reply

/usr/sbin/tethereal -i ppp1:

131.214545 69.158.208.148 -> 206.191.0.140 DNS Standard query A www.nba.com
131.943984 206.191.0.140 -> 69.158.208.148 DNS Standard query response CNAME
www.nba.com.edgesuite.net CNAME a1570.gd.akamai.net A 64.26.141.78 A 64.26.141.71
133.427473 69.158.208.231 -> 64.26.141.78 ICMP Echo (ping) request <-- ppp0's src
addr!!!!!!!!!!
tethereal: Error while capturing packets: recvfrom: Network is down <-- tethereal dies...
----------------------------------------------------------------------------------

NOTE: Bad packets go over ppp0 also, not always through ppp1


SECTION OF /var/log/messages (with various debug printouts to track packets):

----------------------------------------------------------------------------------
Nov  4 15:45:09 localhost kernel: netfilter.c: Entered nf_hook_slow nf_hook_slow: About to
call nf_iterate()
Nov  4 15:45:09 localhost kernel: netfilter.c: Entered nf_iterate().  ip_tables.c: Entered
ipt_do_table().  ip_tables.c: No
ip tables' rules matched. Protocol=1
Nov  4 15:45:09 localhost kernel: ipt_do_table: Target LOG entered!
Nov  4 15:45:09 localhost kernel: IN=eth0 OUT=ppp0 SRC=192.168.1.85 DST=64.26.141.78
LEN=60 TOS=0x00 PREC=0x00 TTL=127 ID=46290 PROTO=ICMP TYPE=8 CODE=0 ID=512 SEQ=39171 (0x9903)
Nov  4 15:45:09 localhost kernel: ipt_do_table: Target LOG exited!
Nov  4 15:45:09 localhost kernel: ip_tables.c: No ip tables' rules matched. Protocol=1
Nov  4 15:45:09 localhost kernel: nf_hook_slow: Returned from nf_iterate()
Nov  4 15:45:09 localhost kernel: netfilter.c: Entered nf_hook_slow nf_hook_slow: About to
call nf_iterate()
Nov  4 15:45:09 localhost kernel: netfilter.c: Entered nf_iterate().  ip_nat_standalone.c:
Entered ip_nat_fn().  ip_nat_fn:
About to call ip_nat_rule_find()
Nov  4 15:45:09 localhost kernel: ip_tables.c: Entered ipt_do_table().  ipt_do_table:
Target MASQUERADE entered!
Nov  4 15:45:09 localhost kernel: MASQ_NEW: Did IP_NF_ASSERT().
Nov  4 15:45:09 localhost kernel: MASQ_NEW: '(*pskb)->sk' does not exist.
Nov  4 15:45:10 localhost kernel: MASQ_NEW: prot:1 | src=192.168.1.85:17664 |
dst=64.26.141.78:60
Nov  4 15:45:10 localhost kernel: MASQ_NEW: ICMP PACKET: type is 69 and sequence num is 0
Nov  4 15:45:10 localhost kernel: MASQ_NEW: out->name is ppp0
Nov  4 15:45:10 localhost kernel: MASQ_NEW: newsrc = 69.158.208.231
Nov  4 15:45:10 localhost kernel: MASQ_NEW: About to call ip_nat_setup_info() .
Nov  4 15:45:10 localhost kernel: ipt_do_table: Target MASQUERADE exited!
Nov  4 15:45:10 localhost kernel: ip_nat_fn: Returned from ip_nat_rule_find()
Nov  4 15:45:10 localhost kernel: nf_hook_slow: Returned from nf_iterate()
.
.
.
Nov  4 15:45:14 localhost kernel: netfilter.c: Entered nf_iterate().  ip_tables.c: Entered
ipt_do_table().  ipt_do_table: Target LOG entered!
Nov  4 15:45:14 localhost kernel: IN=eth0 OUT=ppp1 SRC=192.168.1.85 DST=64.26.141.78
LEN=60 TOS=0x00 PREC=0x00 TTL=127 ID=46291 PROTO=ICMP TYPE=8 CODE=0 ID=512 SEQ=39427 (0x9a03)
Nov  4 15:45:14 localhost kernel: ipt_do_table: Target LOG exited!
.
.
Nov  4 15:45:14 localhost kernel: ipt_do_table: Target LOG entered!
Nov  4 15:45:14 localhost kernel: IN=eth0 OUT=ppp0 SRC=192.168.1.85 DST=64.26.141.78
LEN=60 TOS=0x00 PREC=0x00 TTL=127 ID=46292 PROTO=ICMP TYPE=8 CODE=0 ID=512 SEQ=39683 (0x9b03)
Nov  4 15:45:14 localhost kernel: ipt_do_table: Target LOG exited!
.
.
----------------------------------------------------------------------------------


The "MASQ_NEW:" lines represent printouts in the ipt_MASQUERADE.c file with
Rusty/Herbert's MASQUERADE patch as well as Phil Oester's patch.

The above test shows that the ICMP echo request (SEQ=39171) was MASQUERADED but the ICMP
packet with SEQ=39427, the packet that went over the wrong link, did not go through the
MASQUERADE code. (I know this is the BAD packet since I compared the sequence number from
LOG target and the sequence number (in hex) from ethereal, which shows it used the wrong
src addr) Also SEQ=39683 did not go through the MASQUERADE code (since no "MASQ_NEW:"
messages). HOWEVER, with the above tethereal logs, you can see that the echo request got
replies. 

So, eventhough the bad packet went over ppp1, why do packets destined to ppp0 not reach
the MASQUERADE code???? How can one explain the above behaviour?? This has now been
troubling me for a while. Similar problems occur with ICMP Destination Unreachable packets
as well. 


I know it is a lot to swallow at once, but do please read through it carefully. I have
been doing these tests for over 2-3 months now and though Rusty's MASQUERADE patch did
solve alot of problems, the icmp packets have been nagging me.

I would really appreciate any feedback.

cheers
Dravya
