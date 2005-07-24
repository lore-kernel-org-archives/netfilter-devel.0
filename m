From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: SACK out of window segments?
Date: Sun, 24 Jul 2005 18:28:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0507241824420.31208@blackhole.kfki.hu>
References: <20050720.122652.28782810.davem@davemloft.net>
	<Pine.LNX.4.58.0507202219360.26391@blackhole.kfki.hu>
	<1121928338.15942.3.camel@nienna.balabit>
	<20050721.010634.92583580.davem@davemloft.net>
	<1121933987.15942.9.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-527177333-1122222499=:31208"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1121933987.15942.9.camel@nienna.balabit>
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
  Send mail to mime@docserver.cac.washington.edu for more info.

--110391808-527177333-1122222499=:31208
Content-Type: TEXT/PLAIN; charset=US-ASCII

[Resent for the sake of the list: my original mail was over the message
size limit.]

On Thu, 21 Jul 2005, KOVACS Krisztian wrote:

> > That means the trace doesn't necessarily show exactly what the client
> > sees, nor what the server sees....
>
>   The proxy _is_ the client, so the dump should be accurate wrt the
> client's packets, shouldn't it? (The TCP connection was established
> between the public IP of the proxy and the web server.) Of course we
> don't know anything about the server and the firewalls between the
> endpoints...

Let me rephrase again the problem by commenting the traffic dump. Somehow
I managed not to fully explain it and probably what I wrote was confuse .

15:27:27.315245 IP (tos 0x0, ttl  64, id 35783, offset 0, flags [DF], length: 60)
	1.1.1.1.4632 > 2.2.2.2.80: S [tcp sum ok] 72431051:72431051(0)
	win 5840 <mss 1460,sackOK,timestamp 2766486 0,nop,wscale 0>
15:27:27.322134 IP (tos 0x0, ttl 124, id 22926, offset 0, flags [DF], length: 64)
	2.2.2.2.80 > 1.1.1.1.4632: S [tcp sum ok] 2187509889:2187509889(0)
	ack 72431052 win 65535 <mss 1460,nop,wscale 0,nop,nop,timestamp 0 0,
	nop,nop,sackOK>

The first two packets of the handshake: both window scaling and SACK are
enabled. The zero window scale factor at "both" parties looks suspicious.

[...]
15:27:29.447452 IP (tos 0x0, ttl  64, id 32944, offset 0, flags [DF], length: 72)
	1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0)
	ack 2187544201 win 56424 <nop,nop,timestamp 2766700 69058124,nop,nop,
	sack sack 2 {2187568937:2187599522}{2187545649:2187548545} >

Client acknowledges up to 2187544201 and advertises its window size as
56424. There are holes in the received packets above 2187544201 about
which the server is notified by the sack options.

15:27:29.463411 IP (tos 0x0, ttl 124, id 23463, offset 0, flags [DF], length: 1500)
	2.2.2.2.80 > 1.1.1.1.4632: . [tcp sum ok] 2187599522:2187600970(1448)
	ack 72436105 win 65535 <nop,nop,timestamp 69058128 2766696>

Server sends a packet which overlaps with the window: octets at the end of
the packet are out of window. This is our critical packet.

15:27:29.463440 IP (tos 0x0, ttl  64, id 59492, offset 0, flags [DF], length: 72)
	1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0)
	ack 2187544201 win 56424 <nop,nop,timestamp 2766701 69058124,nop,nop,
	sack sack 2 {2187568937:2187600970}{2187545649:2187548545} >

>From the sack option it looks like if the client accepted and "acknowledged" the
whole packet, including the octets out of the window.

15:27:29.478945 IP (tos 0x0, ttl 124, id 23464, offset 0, flags [DF], length: 1500)
	2.2.2.2.80 > 1.1.1.1.4632: . [tcp sum ok] 2187600970:2187602418(1448)
	ack 72436105 win 65535 <nop,nop,timestamp 69058128 2766698>

Sender sends packets further, this time fully out of window. From our
point of view, it's misleading: clean out of window packet, can be
dropped by TCP connection tracking.

15:27:29.565920 IP (tos 0x0, ttl 124, id 23492, offset 0, flags [DF], length: 1500)
	2.2.2.2.80 > 1.1.1.1.4632: . [tcp sum ok] 2187544201:2187545649(1448)
	ack 72436105 win 65535 <nop,nop,timestamp 69058130 2766701>

Sender re-sends the lost packet missing between ack 2187544201 and
sack 2187545649:2187548545.

15:27:29.565981 IP (tos 0x0, ttl  64, id 35141, offset 0, flags [DF], length: 72)
	1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0)
	ack 2187548629 win 51996 <nop,nop,timestamp 2766711 69058130,nop,nop,
	sack sack 2 {2187568937:2187600970}{2187561697:2187566041} >

Client ack the re-sent packet and advances forward. (The excess 2980 octets
were sack-ed earlier).

[...]

15:27:29.969344 IP (tos 0x0, ttl  64, id 47888, offset 0, flags [DF], length: 64)
	1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0)
	ack 2187567501 win 33124 <nop,nop,timestamp 2766752 69058133,nop,nop,
	sack sack 1 {2187568937:2187600970} >

Client still sees the sack block with 2187600970 at the right edge.

15:27:29.983937 IP (tos 0x0, ttl 124, id 23647, offset 0, flags [DF], length: 1500)
	2.2.2.2.80 > 1.1.1.1.4632: . [tcp sum ok] 2187567501:2187568949(1448)
	ack 72436105 win 65535 <nop,nop,timestamp 69058133 2766744>

Server fills the hole.

15:27:29.984137 IP (tos 0x0, ttl  64, id 33883, offset 0, flags [DF], length: 64)
	1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0)
	ack 2187600970 win 8688 <nop,nop,timestamp 2766753 69058133,nop,nop,
	sack sack 1 {2187568937:2187568949} >

Client acks 2187600970!

Here comes our problem. As I see 2187600970 is an out of window segment of
an overlapping packet, still it's ack-ed. If we drop the critical packet
above, somehow the connection can get stuck. If we trim (in the recording
of conntrack) the packet to fit into the window, at this point the client
would ack an "unseen" octet. If we does not trim, we have to keep track
SACK options to detect wether the receiver SACKs the excess octets or not.

The client - Linux 2.4.25 - does not violate RFC793 (p70):

        In the following it is assumed that the segment is the idealized
        segment that begins at RCV.NXT and does not exceed the window.
        One could tailor actual segments to fit this assumption by
        trimming off any portions that lie outside the window (including
        SYN and FIN), and only processing further if the segment then
        begins at RCV.NXT.  Segments with higher begining sequence
        numbers may be held for later processing.

Here the higher sequence number has been kept for later processing.

Is that correct? Do I miss something?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-527177333-1122222499=:31208
Content-Type: APPLICATION/octet-stream; name="full_dump.txt.bz2"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0507241828190.31208@blackhole.kfki.hu>
Content-Description: full_dump.txt.bz2
Content-Disposition: attachment; filename="full_dump.txt.bz2"

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
q8jpd4n/8XckU4UJA6teJPA=

--110391808-527177333-1122222499=:31208--
