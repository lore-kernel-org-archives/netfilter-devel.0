From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [Fwd: Re: "ip_conntrack_core: Frag of proto 17." error and memory
	leak?]
Date: Sat, 20 Sep 2003 22:37:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1064090237.28506.83.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ok it was as I suspected.
ipt_NOTRACK calls ip_conntrack_get_tuple() which calls get_tuple() for
all packets, even fragments and get_tuple() barfs and returns 0 so
NOTRACK doesn't mark the packet as untracked.

The first packet of a stream of fragments will be marked as untracked
and not handled by conntrack. The rest of the packets will fail in
get_tuple() (it can't succeed for fragments) and nothing will be done.
So conntrack gets the rest of the fragments and tries to defrag but the
first packet has already passed through the machine without conntrack
seeing it so the defrag will never succeed, the fragments will only
consume memory until they are dropped by a timeout.

Jozsef, any ideas how to handle this?

One suggestion would be to call get_tuple() for the first packet.
Lookup the tuple in conntrack, if not found mark packet as untracked.
If found, don't do anything, give the packet to conntrack.

If IP_OFFSET is set this is a fragment, we can't call get_tuple() and do
a lookup in conntrack since we only have the ipheader. Instead we split
ip_find() in ip_fragment.c into two functions so we can do a lookup to
see if the defrag is expecting this fragment or not. If it isn't
expected we mark it as untracked.

But this makes the assumption that it's only conntrack that tries to
defrag packets which isn't true, the ipstack does it for packets
destined for the local machine. So if the first packet was destined for
the local machine and was marked as untracked by NOTRACK the ipstack
will try to defrag and when the rest of the fragments arrive we find
that they are expected for defrag and give them to conntrack which isn't
right.

A small variant of this is to still split ip_find() into two functions
and if we find that the fragment is expected (either conntrack or the
ipstack has seen the first packet and tries to defrag it) we simply
continue the defraging on their behalf and rerun the now complete packet
through ip_conntrack_tuple_taken() to see if conntrack should have it or
not. This way I think everyone's happy. There will be some extra
searching in the defrag-hashtable for all fragments handled by NOTRACK
and one extra search in conntrack for each defragged packet. For the
case where the arriving fragments are expected there will be two
searches in the defrag-hashtable unless we split those things up a bit
and modify them, I wonder how keen davem is on that.

/Martin

-----Forwarded Message-----
From: c0g <c0g@wp.pl>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error and memory leak?
Date: Sat, 20 Sep 2003 21:45:06 +0200

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

| Are you using the NOTRACK target in raw/PREROUTING?

Yes I am. Policy of raw table is set to ACCEPT for all chains, and the
rules are put in PREROUTING:
iptables -t raw -A PREROUTING -s ! 192.168.0.0/16 -j NOTRACK
iptables -t raw -A PREROUTING -d ! 192.168.0.0/16 -j NOTRACK

Why I'm using raw table? This router doesn't need connection tracking of
Internet traffic - this is being done on my next router. So I disabled
it to save few bits of memory for other, cpu and memory consuming tasks.

The second use of raw patch is in FORWARD chain of filter table:
iptables -A FORWARD -m state --state UNTRACKED -j ACCEPT

| This is the only source of this I can see and it is indeed a bug. This
| message shouldn't be printed for this case. It doesn't defrag packets
| and calls get_tuple() for all packets, even the fragments and
| get_tuple() barfs. This causes only the first fragment to be marked as
| untracked and leaves the rest of the fragments to conntrack which tries
| to defrag them but that won't succeed since conntrack will never see the
| first packet. And thus the kernel keeps lots of fragments in memory
| until they time out and are dropped.
| We'll look into how to best solve this if this is what is causing the
| problem for you.

I see. This is production machine, so I can't test it too much, but I
will try to help, if I can.

Greets

- --
c0g@wp.pl
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/bK5CPqmVt5WhbA8RAmvTAJ43OhaO4/IzdK7DrzXQ/uavyLVIxgCcCt/H
kW56eU4QQQAiMQn7E9FyCu4=
=yWKY
-----END PGP SIGNATURE-----
-- 
/Martin
