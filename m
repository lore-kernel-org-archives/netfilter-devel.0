From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 04 Apr 2005 03:04:30 +0300
Message-ID: <4250848E.5040207@outerspace.dyndns.org>
References: <42464598.9040707@outerspace.dyndns.org>	<425032D5.2010302@trash.net>
	<878113493.20050403233059@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <878113493.20050403233059@dns.toxicfilms.tv>
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

Maciej Soltysiak wrote:

|>I can see that it would be useful, given all the half-working ACK
|>matching rules for shaping floating around, but we already a tcp
|>match, so it should be done in there, and, if possible, kept a little
|>bit more generic. Perhaps a data-len match option.
|
| Hmm. I'm no guru, but isn't it possible to do that using the u32 filter
| with tc? Which propably is faster than doing it in iptables anyway.

Yeah it's possible, but no one seems to be doing it right..

What needs to be done is to compare the tcp header length with the total
packet length to ensure there are no data bytes. However, tc can only match
specific data bytes, and since there are at least 8 different tcp header
lengths that can occur during normal traffic in an established connection,
it means at least 8 filter rules to match the ack packets..

I've mostly seen solutions where the test is to see if the total length is
less than 64 bytes, and if, it means it's a packet that should be
prioritized. Unfortunately, since linux likes both the timestamp and the
sack options of tcp, the tcp header tends to expand beyond 63 bytes every
now and then. When this happens, the packets exceeding 63 bytes will
probably go off to another qdisc, which might keep them on a queue for a bit
too long, possibly resulting in the data transfer getting stalled
temporarily, and possibly unnecessary resends.

I aim to fix this all with one simple netfilter match which can give an
answer with simple arithmetics in one go instead of matching against a
preconfigured list of possible values one by one.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCUISKxyF48ZTvn+4RAjSlAKDWorgIpKW8vDf0q+lk2hDsP/uhCwCdGrkl
Er4Rr5Hgw68jZEqeqeH2FtY=
=QPJY
-----END PGP SIGNATURE-----
