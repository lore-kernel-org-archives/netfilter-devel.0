From: "Michael Ransburg" <michael.ransburg@gmail.com>
Subject: Userspace packet queuing with libipq: ip_conntrack does not
	defragment?
Date: Wed, 9 May 2007 20:12:05 +0200
Message-ID: <22b256140705091112i75f9677ep8aabd4ae33e7844f@mail.gmail.com>
References: <22b256140705090832v556bee45ne5119d529a7e310e@mail.gmail.com>
	<4641F80E.8050103@rtij.nl>
	<22b256140705091014i1d3d7578nf8ed6b20cc1aa1fa@mail.gmail.com>
	<46420398.7060101@rtij.nl>
	<22b256140705091043m3ff01e3djc45390edbf84293c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <22b256140705091043m3ff01e3djc45390edbf84293c@mail.gmail.com>
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

> > This was indeed my misconception. I thought that conntrack would
> > reassemble IP datagrams into the original (single) TCP/IP datagram. I
> > would like to access and inspect the reassembled TCP/IP datagram on my
> > firewall/router. Can netfilter provide me with this, i.e., can it take
> > care of reassembling and fragmentation of (e.g.) TCP/IP datagrams?
> >
>
> Mu! Tcp uses streams. There is nothing to reassemble. Udp uses
> datagrams, but netfilter cannot (and should not) reassemble those.
>
> What are you trying to achieve in the first place?

Sorry for using the wrong terminology. Let's say I'm downloading a
video from a website (over HTTP/TCP/IP). What I see is that each
picture of the video is send as a single TCP/IP packet (?) - usually
with a size of around 10 KB. This TCP/IP packet is fragmented
according to the MTU and therefore I see the following fragments on
the wire:
Fragment 1: <Ethernet header><IP header><TCP header>application data
Fragment 2: <Ethernet header><IP header>application data
Fragment 3: <Ethernet header><IP header>application data
=85

On my router/firewall I would like to inspect the video picture as a
whole. In my current (windows) application I have to reassemble the
fragments manually into the original TCP/IP packet. I hoped that
netfilter would make my life easier by performing the reassembling for
me (and potentially also the recalculation of the checksum(s) if the
video picture is changed).

Is there support in netfilter for this kind of stuff? I've googled
quite a bit and there seem to be discussions indicating that NAT is
doing that (http://lists.netfilter.org/pipermail/netfilter/2001-January/006=
915.html)...?

Many thanks again for your help,
Michael
--
icq: 71772353 | skype: daneel1409 | msn: mike@unfolded.com
