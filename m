From: Jonathan Cooper <netfilter@jonc.me.uk>
Subject: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 11 Mar 2004 16:04:01 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040311160401.GA1565@finarfin.cooper.xfnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Specifically, the message:

kernel: LIST_DELETE: ip_conntrack_core.c:302
&ct->tuplehash[IP_CT_DIR_REPLY]'(d40acea4) not in ip_conntrack_hash[hr].

=46rom doing a bit of googling it appears this problem has been around for
some time; hopefully my situation will help you track it down.

The machine exhibiting the problem has 2 network cards: an nForce2 card
(eth1) on the motherboard (connected to external network) and a sis900
(eth0) which is connected via crossover cable to another computer. This
connection is masqueraded.

It would appear that trying to access the machine via the masqueraded
interface leads to the message being produced after a delay of perhaps 2
minutes. Certainly this is the case when trying to access a webserver or
webcache on the machine directly via that interface. The connection times
out and shortly afterwards the message appears in syslog. DHCP & ICMP
appear to work OK. Also interestingly you will note from the iptables -L
output shown below that I have squid set up as a transparent proxy for
the masqueraded network using a redirect rule in the prerouting chain -
the computer that is being masqueraded can access webpages from the
outside world, so the redirect seems to avoid the problem.

Under the 2.4.23 and 2.4.24 kernels my machine would oops on reboot (just
after killing syslog) after the message had occurred. This has not (yet)
happened on 2.4.25. One common feature, that has occurred once under
2.4.23 and once under 2.4.25 is that after several occurrences of this
message the computer froze solid, with no keyboard, mouse or network
response.

I have experienced no problems of this nature with Debian's 2.4.22
kernel.

Experiments I have performed so far include:

* Delete the MASQUERADE rule. Same problem, although have not yet tried
this fresh after a reboot.

* Add an ACCEPT rule to the top of the FORWARD chain. Same problem. Have
tried this fresh after a reboot.

* Flush the FORWARD chain. Same problem, although have not yet tried
this fresh after a reboot.


(Under 2.4.25 I did notice that one failed connection appeared to be
producing multiple LIST_DELETE messages. However I did have the http
connection in question going through a local squid, so it could be that
that was making multiple tries to fetch the page. Stopping proxying for
local addresses appears to have returned us to the previously noted
behaviour.)


Excepts from my iptables configuration:
# iptables -L -n
[snip]
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
LOG        all  --  0.0.0.0/0            0.0.0.0/0           state
  INVALID LOG flags 0 level 4 prefix 'invalid-state: '
DROP       all  --  0.0.0.0/0            0.0.0.0/0           state
  INVALID
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state
  RELATED,ESTABLISHED
ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:6112
good-bad   all  --  192.168.1.0/24       0.0.0.0/0
good-vpn   all  --  192.168.1.0/24       0.0.0.0/0
vpn-good   all  --  0.0.0.0/0            0.0.0.0/0
bad-good   all  --  0.0.0.0/0            0.0.0.0/0
DROP       all  --  192.168.168.0/24     0.0.0.0/0
LOG        all  --  0.0.0.0/0            0.0.0.0/0           LOG flags 0
  level 4 prefix 'chain-jump: '
DROP       all  --  0.0.0.0/0            0.0.0.0/0
[snip]

# iptables -t nat -L -n
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
REDIRECT   tcp  --  192.168.1.0/24       0.0.0.0/0           tcp dpt:80
  redir ports 8080
DNAT       udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:6112
  to:192.168.1.2:6112

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  192.168.1.0/24       0.0.0.0/0

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

(The DNAT rule is to allow the other computer to create StarCraft games
on Battle.net.)


Output from scripts/ver_linux:
Linux finarfin 2.4.25 #1 Wed Mar 10 12:32:06 GMT 2004 i686 GNU/Linux

Gnu C                  3.3.3
Gnu make               3.80
binutils               2.14.90.0.7
util-linux             2.12
mount                  2.12
modutils               2.4.26
e2fsprogs              1.35-WIP
PPP                    2.4.2
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 3.2.0
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.0.91
Modules Loaded         nvidia parport_pc lp parport apm snd-seq-oss
snd-seq-midi-event snd-seq snd-pcm-oss snd-mixer-oss snd-intel8x0 snd-pcm
snd-timer snd-ac97-codec snd-page-alloc snd-mpu401-uart snd-rawmidi
snd-seq-device snd soundcore ipt_limit ipt_REJECT ipt_MASQUERADE
ipt_REDIRECT ipt_LOG ipt_state iptable_nat ip_conntrack iptable_filter
ip_tables nls_cp437 vfat fat nls_iso8859-1 ntfs forcedeth ide-scsi
scsi_mod ide-cd cdrom keybdev input usb-ohci usbcore rtc


My 2.4.25 kernel config is at <http://jonc.me.uk/stuff/config-2.4.25>

Let me know if there's any other information you want, or any tests that
you would like me to run.

Jonathan.

--=20
Jonathan Cooper        MSN: msn@jonc.me.uk        jonc.me.uk/

Spotted at the railway station:
  Passengers are asked not to cross the lines - it takes ages for us to
  uncross them again.
