From: Daniel Hartmeier <daniel@benzedrine.cx>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 6 Jul 2005 13:15:46 +0200
Message-ID: <20050706111546.GI6024@insomnia.benzedrine.cx>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
	<Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
	<20050629145545.GO26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0506300903350.16566@blackhole.kfki.hu>
	<20050630111344.GP26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0507011150500.19392@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0507011150500.19392@blackhole.kfki.hu>
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

On Fri, Jul 01, 2005 at 01:58:45PM +0200, Jozsef Kadlecsik wrote:

> Attached is the anonymized txt version of a traffic dump. If the last
> packet is blocked by the firewall, the session hangs on the client side.
> By using the rightmost edge of the SACK blocks as ACK in calculating the
> acceptable window, the connection finishes all right. (There were multiple
> independent reports - this was unique being easily reproducible anytime.)
> 
> But it's as interesting for me as SACK handling that you use the original
> conditions from Guido's article. However I strongly believe the boundaries
> for valid data stated there are not RFC compliant: data is not required to
> fit into the window, it must just overlap. Receiver even may hold segments
> with higher sequence numbers for later processing. What's your opinion?

Looking at the beginning and end of your example dump:

> 15:27:27.315245 IP (tos 0x0, ttl  64, id 35783, offset 0, flags [DF], length: 60) 1.1.1.1.4632 > 2.2.2.2.80: S [tcp sum ok] 72431051:72431051(0) win 5840 <mss 1460,sackOK,timestamp 2766486 0,nop,wscale 0>
> 15:27:27.322134 IP (tos 0x0, ttl 124, id 22926, offset 0, flags [DF], length: 64) 2.2.2.2.80 > 1.1.1.1.4632: S [tcp sum ok] 2187509889:2187509889(0) ack 72431052 win 65535 <mss 1460,nop,wscale 0,nop,nop,timestamp 0 0,nop,nop,sackOK>

Both peers handshake and enable SACK and window scaling (both using
factor 2^0 == 1).

It looks like a typical HTTP connection, where the server is pushing
data to the client.

> [...]

> 15:27:29.447452 IP (tos 0x0, ttl  64, id 32944, offset 0, flags [DF], length: 72) 1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0) ack 2187544201 win 56424 <nop,nop,timestamp 2766700 69058124,nop,nop,sack sack 2 {2187568937:2187599522}{2187545649:2187548545} >

The client fully acknowledges up to 2187544201 and advertises its window
as 56424 bytes (wscale 0).

This means the server may send data up to 2187544201 + 56424 ==
2187600625. If it sends higher segments, it's violating the advertised
window. SACK does not affect this rule, i.e. selectively acknowledged
segments are NOT exempt from this window restriction. If I should be
wrong on this, please quote an RFC.

> 15:27:29.463411 IP (tos 0x0, ttl 124, id 23463, offset 0, flags [DF], length: 1500) 2.2.2.2.80 > 1.1.1.1.4632: . [tcp sum ok] 2187599522:2187600970(1448) ack 72436105 win 65535 <nop,nop,timestamp 69058128 2766696>

With this packet, the server is already violating the window, as
2187600970 > 2187600625.

> 15:27:29.463440 IP (tos 0x0, ttl  64, id 59492, offset 0, flags [DF], length: 72) 1.1.1.1.4632 > 2.2.2.2.80: . [tcp sum ok] 72436105:72436105(0) ack 2187544201 win 56424 <nop,nop,timestamp 2766701 69058124,nop,nop,sack sack 2 {2187568937:2187600970}{2187545649:2187548545} >

The client seems not to care, and accepts the segment, extending one
selectively acknowledged section.

> 15:27:29.478945 IP (tos 0x0, ttl 124, id 23464, offset 0, flags [DF], length: 1500) 2.2.2.2.80 > 1.1.1.1.4632: . [tcp sum ok] 2187600970:2187602418(1448) ack 72436105 win 65535 <nop,nop,timestamp 69058128 2766698>

Which encourages the server to further violate the window, 2187602418 >
2187600625.

I don't know why both client and server seem to think that selectively
acknowledged sections should not be counted as occupying the advertised
window. This is clearly wrong. A recipient stack that allocates a
specific number of bytes for one socket's receive buffer cannot pass
selectively acknowledged sections to userland (when, like in this case,
there's a hole). Hence, the selectively acknowledged sections do use up
kernel buffer memory. Maybe if an implementation uses separate buffers
for SACK sections and tcp receive buffers, it will allow this on
reception.

But it's a violation of the TCP RFC, and any sender doing this can't
expect the receiver to not drop the segments past the window. In fact, a
receipient might have a problem with such violations, and we expect the
packet filter to protect it from exploitation.

What stacks do generate (and accept) this? Do they do this on purpose?
If so, how well do they react if they get sent malicious SACK sections,
trying to use up as much buffer space as possible? Sounds like a DoS
waiting to happen.

Daniel
