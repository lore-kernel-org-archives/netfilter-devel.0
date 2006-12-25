From: Krzysztof Oledzki <ole@ans.pl>
Subject: What should we do with packets marked as INVALID?
Date: Mon, 25 Dec 2006 02:33:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-172121746-1167010439=:27316"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-172121746-1167010439=:27316
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

One of the most important feature provided by the netfilter subsystem is=20
stateful connection tracking - the ability to decide that a packet is=20
valid (or not) using not only data from a packet itself but also from a=20
history of a flaw.

So, the question is: what should we do with packets marked as INVALID?

For a very long time I have thought that something like this should work=20
best:

-A INVALID -m limit --limit 10/s -j LOG --log-prefix "INVALID: " --log-leve=
l 7 --log-tcp-sequence --log-tcp-options --log-ip-options
-A INVALID -p tcp -m limit --limit 4/s -j REJECT --reject-with tcp-reset
-A INVALID -p udp -m limit --limit 4/s -j REJECT
-A INVALID -j DROP

-A FORWARD -m conntrack --ctstate INVALID -j INVALID

This whole REJECT idea is to kill out of sync sessions - IMO it is better=
=20
to send RST/port-unreachable ASAP, so hosts know they should reconnect=20
immediatley (if that's appropriately) without needing to wait (sometines=20
very long) for a session to timeout. Think on stalled NFS mounts, etc.

Then I realized that the same INVALID state handles packets from a valid=20
flow (proto/src/dst/sport/dport match conntrack table) but with something=
=20
the netfilter decides that is wrong (ex. out of window segments,=20
short/truncated/malformed packets, bad checksum, etc). Rejecting such=20
packets kills valid connections, and it is quite common to get a lot of,=20
for example, "ip_ct_tcp: ACK is under the lower bound (possible overly=20
delayed ACK)" on bigger firewalls:

root@fw2:~# grep -c "ip_ct_tcp: ACK is under the lower bound (possible over=
ly delayed ACK)" /var/log/syslog
905

So OK, REJECT is wrong (possibly kills valid connections), DROP (makes=20
invalid connections hang "forever") is also wrong, so maybe we should=20
forward such packets and allow dst hosts to handle it (ignore/reset/etc).=
=20
Bzzzz... no, wait, it is also wrong as we lose one of the most important=20
netfilter feature.

So, I have two propositions:
  - Add another state (ex. UNCLEAN) for packet that matches=20
proto/src/dst/sport/dport, but netfilter consider that it is wrong. There=
=20
will be two states: INVALID (for packet with no known conntrack entry) and=
=20
UNCLEAN and that gives us possibility to distinguish between these two=20
states:

-A FORWARD -m conntrack --ctstate UNCLEAN -j DROP
-A FORWARD -m conntrack --ctstate INVALID -j INVALID

  - Drop such packets implicitly (something like s/-NF_ACCEPT/-NF_DROP/ in=
=20
ip_conntrack_proto_*.c) and safely REJECT packets with INVALID state, like=
=20
in my first example. This time INVALID will means that there is no=20
appropriate conntrack entry, nothing else.

Comments?

Best regardas,


 =09=09=09Krzysztof Ol=EAdzki
---187430788-172121746-1167010439=:27316--
