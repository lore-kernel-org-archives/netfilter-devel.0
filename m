From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: iptables STILL incorrectly using TCP packet contents without
 checking header!
Date: Thu, 31 Mar 2005 23:04:59 +0300
Message-ID: <424C57EB.7020308@outerspace.dyndns.org>
References: <20050331185732.GA20249@netnation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Kirby <sim@netnation.com>
In-Reply-To: <20050331185732.GA20249@netnation.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Simon Kirby wrote:

| Since my post in December, iptables is STILL incorrectly using TCP packet
| contents without checking the header.  I bet this is resulting in dropped
| connections and other issues all over the place but people aren't easily
| able to see why.

Forgive me, I was not around in december.. :)

| The "state" module checks the TCP checksum.  Good.

What does it do if it mismatches? Match state "INVALID" ? Or not match any
state at all?

| The REJECT module uses TCP data without checking the checksum.  Bad.
|
| In fact, a simple "-p tcp --dport 80" also matches without checking the
| TCP checksum.  This is bad -- the port could be corrupted!

I agree.

| IMHO:
|
| 2: -p tcp --dport 80 needs to verify that the IP _AND_ TCP header is
|    valid, since the port is in the TCP header.  It does not do this now.

I think this sounds just fine, with the implementation note that a flag was
attached to the packet indicating that the layer 4+ checksum has been
verified (and what was the outcome) so it would only be verified the first
time someone (match, target) requests verification. Of course then there's
the issue if someone (userspace for example) modifies the packet in
between.. maybe these possibilities could be intercepted and the cached
result be destroyed in these cases?

If (and only if) the "state" match doesn't let us match the packet with
f.ex. the INVALID state, how would we allow the user to match these packets?
Maybe a --verify-checksum could be added to -p tcp and -p udp, which would
maybe mostly be used inverted?

| 3: REJECT needs to verify that the data it is using in --tcp-reset is
|    actually valid, because it can be used with just "-p tcp".  ICMP
|    REJECT might also need checking.

But what will be done in case REJECT notices it's not valid? Return
IPT_CONTINUE? If that, then at least the packet & byte counters will
possibly be misleading - aren't they incremented regardless of the return
value of the target?

Another possibility of REJECT would be to drop the packet, but that's not
very customizable behaviour.. Looking at your first point, I find one more
possibility:

| 1: -p tcp needs to verify that the IP header is valid (it probably does
|    this already), since the protocol is specified there.

If it would verify the TCP header too, then things like -j REJECT would also
work without hassle, and the counters would be right. On the other hand, it
would not regard broken tcp packets as tcp packets, and that might trigger
other unwanted side-effects of some firewall out there.

| Right?  Does this make sense?  Anyone?

Yeah I agree something should be done about this :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCTFfqxyF48ZTvn+4RAoAQAJsFS5GoJquksvgLbsFkyWu+9SGJ0QCfaCLt
12pPh8tUEquLQV3bzOLmVK8=
=rdei
-----END PGP SIGNATURE-----
