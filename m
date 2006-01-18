From: Moises Silva <moises.silva@gmail.com>
Subject: p_nat_sip understanding, may be not working for 2.6.14?
Date: Wed, 18 Jan 2006 13:31:55 -0600
Message-ID: <c4d05cbe0601181131x593172b0p2f5ca29d3fc64a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

i have already posted this in users list with no single response,
please let me know if this post is not suitable to dev-list.

I have kernel 2.6.14 with ip_nat_sip and ip_conntrack_sip modules
loaded. I have te following setup:

SIP UA <--------- Gnu/Linux Firewall -----------> Asterisk VoIP server

So, my SIP UA is sending REGISTER requests to the VoIP server, but
since the contact: field has a private IP address, Asterisk is trying
to reply to the private IP address. I have checked that using snort
(network sniffer), having the next results.

GNU/Linux Firewal, snort attached to eth2 interface (the one connected
to SIP UA)

01/14-12:34:31.469420 192.168.1.89:5060 -> 201.137.229.81:5060
UDP TTL:250 TOS:0xC0 ID:40650 IpLen:20 DgmLen:479
Len: 451

UA has the 192.168.1.89, and Asterisk VoIP server has 201.137.229.81.
So the UA is attempting to send a REGISTER. Then in The Asterisk box i
have snort reading all that is sent from GNU/Linux firewall, and this
show up:

01/14-12:37:40.882310 200.95.104.45:1025 -> 201.137.229.81:5060
UDP TTL:248 TOS:0xD0 ID:40627 IpLen:20 DgmLen:479
Len: 451

so the same register request is mapped to src 200.95.104.45 (the IP
address of the firewall, duh!) and to port 1025 (dont know why is
mapping to other port, since 5060 is not being used)

And finally i have listening snort in VoIP server eth0 (the one in the
LAN side) and this is shown:

01/14-12:46:30.317974 ARP who-has 192.168.1.89 tell 192.168.1.1

01/14-12:46:31.317927 ARP who-has 192.168.1.89 tell 192.168.1.1

so, its attempting to get the MAC of the UA in the LAN, but obviously
the UA is not in that LAN, but in the other across internet.

Well, the register problem can be solved with a parameter in VoIP
server (nat=3Dyes), so it will try to contact the UA ignoring the
"contact" field info. And succeeds. But the fact is that i guess
ip_nat_sip, should be rewritting the SIP REGISTER request properly.
Despite that once done that, Native Transfer (RTP media not passing by
the VoIP server) does not work, even when i have sip modules loaded in
both kernels (the voip-server and the firewall).

I have some ideas in the working of "static unsigned int ip_nat_sip()"
regarding to Contact header.

1. This function should receive ALL the 5060 port packets.
2. First look for the packet having at least the  SIP/2.0 string.
3. look for "REGISTER" string in the Cseq line of the packet
4. In case a register is found it will call to "static unsigned int
mangle_sip_packet()", telling it to mangle the sip header contact.
5. then ct_sip_get_info() calculate the matchoff and matchlen values
(i guess are the positions of the IPs or Ports to rewrite), these
positions are then passed to the int ip_nat_mangle_udp_packet(), who
actually rewrittes the addresses to do the NAT.

Thats what i have of looking on the code for a couple of hours, and im
starting to understand it, but guidelines will be much appreciated.

I have set DEBUGP turned on, but only logs about registering and
unregistering the ip_conntrack_sip helper module are shown.

Sincerly,
moy (Moises Silva)

--
"Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.org=
"
