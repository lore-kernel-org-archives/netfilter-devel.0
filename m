From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: 2.4.20 and user space ICMP REDIRECT
Date: Sat, 08 Mar 2003 16:25:57 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303080625.h286Pw206614@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Harald / All,

  I am not sure how on-topic this is ... but I came across Harald's name
in some code and that's what made me think to ask ...

  For intrusion evaluation, I'm trying to send spoofed ICMP REDIRECT
messages from a 2.4.20 linux box (owned and operated by me) into
my local LAN, and I'm getting a "sendto: Operation not permitted" error.
  Everything on the net regarding this type of failure on the "sendto" 
socket command indicates either screwed routing or conflicting 
filtering, however this was for the local subnet, and I my compiled
in iptables was all flushed out and set on policies of ACCEPT.

Using the Project Purple "sendip" software;
    http://www.earth.li/projectpurple/progs/sendip.html

with the following;
  echo "ECHO REQUEST"
  sendip -v -p ipv4 -is ${ipgw} -d ${iptgt} -p icmp -ct 8 -cd 0 hostname
  echo
  echo "REDIRECT"
  sendip -v -p ipv4 -is ${ipgw} -d ${iptgt} -p icmp -ct 5 -cd 1 hostname

.. demonstrates that the spoofed echo request packet is fine (and if
I log my outgoing data I see it in the logs as expected), but the spoofed
redirect packet gets killed on the sendto.

  Similarly, using the icmp_redir.c code (found here;
http://www.insecure.org/sploits/arp.games.html) with a similar 
command;
  echo "REDIRECT"
  icmp_redir ${ipgw} ${iptgt} ${ipdest} ${ipnewgw}

  I get the same "sendto: Operation not permitted". (I am conscious
that the "Operation not permitted" is a perror response to the sendto
error .. but the cause still illudes me).

  I won't bore you with more detail, but I've been through proc and 
made the changes seen below .. and I've added an iptables
rule (in my default allow ruleset) to allow icmp-redirect packets
outbound, and it increment the count against the rule.

  Harald's name came up in the kernel code (of course ;-) some
place like ip_nat_core (sample of the interesting bit below - but
not incl Harald ref) ..  is there something like this in the kernel
that is causing me problems?

Ie -  Is there some sort of safe guard or config option that I'm missing?


Any help greatly appreciated.

----------------------------------------
echo "1" > /proc/sys/net/ipv4/conf/all/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/all/secure_redirects
echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
echo "1" > /proc/sys/net/ipv4/conf/default/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/secure_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
echo "1" > /proc/sys/net/ipv4/conf/eth0/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/eth0/secure_redirects
echo "0" > /proc/sys/net/ipv4/conf/eth0/accept_redirects
echo "1" > /proc/sys/net/ipv4/conf/lo/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/lo/secure_redirects
echo "0" > /proc/sys/net/ipv4/conf/lo/accept_redirects

echo "0" > /proc/sys/net/ipv4/conf/all/rp_filter
echo "0" > /proc/sys/net/ipv4/conf/default/rp_filter
echo "0" > /proc/sys/net/ipv4/conf/eth0/rp_filter
echo "0" > /proc/sys/net/ipv4/conf/lo/rp_filter
-----------------------------------------
        /* Redirects on non-null nats must be dropped, else they'll
           start talking to each other without our translation, and be
           confused... --RR */
        if (hdr->type == ICMP_REDIRECT) {
                /* Don't care about races here. */
                if (info->initialized
                    != ((1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST))
                    || info->num_manips != 0)
                        return NF_DROP;
        }

        DEBUGP("icmp_reply_translation: translating error %p hook %u dir %sn",
               skb, hooknum, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
        /* Note: May not be from a NAT'd host, but probably safest to
           do translation always as if it came from the host itself
           (even though a "host unreachable" coming from the host
           itself is a bit weird).

           More explanation: some people use NAT for anonymizing.
           Also, CERT recommends dropping all packets from private IP
           addresses (although ICMP errors from internal links with
           such addresses are not too uncommon, as Alan Cox points
           out) */
-----------------------------------------
/usr/local/sbin/iptables -A OUTPUT -p icmp --icmp-type redirect -j ACCEPT
-----------------------------------------
Chain INPUT (policy ACCEPT 11810 packets, 2521K bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 8593 packets, 836K bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     icmp --  any    any     anywhere             anywhere           icmp redirect

Chain PREROUTING (policy ACCEPT 81 packets, 13375 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain POSTROUTING (policy ACCEPT 3 packets, 144 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 3 packets, 144 bytes)
 pkts bytes target     prot opt in     out     source               destination
-----------------------------------------





--
Ian Latter
Internet and Networking Security Officer
Macquarie University
