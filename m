From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 05 Mar 2004 02:47:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4047DC4E.8020309@trash.net>
References: <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040703000102090302040606"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>, Tom Eastep <teastep@shorewall.net>,
 Michal Ludvig <mludvig@suse.cz>,
  alex@samad.com.au,  guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040304231141.GA1782@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040703000102090302040606
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Willy,

Willy Tarreau wrote:
> This is excellent. So if I understand it right, a packet now passes this way
> (please excuse the ascii-art, it seems I'll never take the time to start xfig)
> 
>             [incoming packet]
>                     |<-----------------. 
>                     v                  |
>                PREROUTING              |
>     dest!=local?  /  \  dest==local?   |
>                 /      \               |
>          FORWARD        LOCAL_IN       |
>              |            |            |
>              |      (ipsec?decrypt:nop)|
>              |            |   \        / dest!=local ? nf_postxfrm_nonlocal()
>              |            |    `------'
>              v            v  dest==local ? ip_local_deliver_finish()
> 
> 
> So if it behaves like this (which is what seems the best solution to me), is
> there a risk that a carefully crafted packet loops many times on the right
> side (multiple encapsulation with local DIP) ? And if so, is it risky or not,
> wrt resource leak, multiple locks, etc... ?

Not exactly. the ipsec transformers are ip protocol handlers,
their input handler (xfrm4_input) is called from
ip_local_deliver_finish. After decrypting the payload the packets
are either reposted into the network stack (in case of a tunnel-mode
SA) or again delivered to the ip-protocol contained in the next
header. packets reposted into the stack may be in some intermediate
state in case of a transport mode encapsulation following a tunnel
mode encapsulation. The difficulty is to know when the packet
is "done". So nf_postxfrm_nonlocal is called directly after input
routing if the destination is non-local, but only for packets which
were reposted into the stack. The fact that they have a non-local
destination means ipsec must be done with them. For packet with
local destination, we look at what the ipprotocol handler does
in ip_local_deliver_finish (xfrm_prot or not) and if the packet
was handled by ipsec before and the protocol handler is no xfrm_prot,
ipsec is done, so the packets are passed through nf_postxfrm_input.

I attached a xfig file with a little picture of how it works, I hope
it's understandable. The blue lines represent the flow as it happens
without my patches, the red lines represent whats new. While drawing
it, I noticed a bug, packets with their destination changed
in nf_postxfrm_nonlocal may need to be delivered locally afterwards.

Regarding loop-danger, I'm not totally sure yet, but I don't think
that it would be triggerable by crafted packets but only by
adventurous configurations. Multiple encapsulations are no error
and they are limited to 4.

>>The only problem with this approach I'm currently aware of is that
>>one of the ip-protocol handlers marked with xfrm_prot
>>(xfrm4_tunnel.c) is also responsible for dispatching packets to
>>ipip.c; the encapsulated packets heading for a ipip-tunnel won't
>>traverse the netfilter hooks on input.
> 
> 
> I don't know well the internals of IPSEC (bought the book but didn't read it
> yet). Are IPIP tunnels often used ? or are they simply used according to a
> negociation, in which case the ipsec implementation on the netfilter side
> could refuse them ?

It's not IPIP with IPSEC that misbehaves but plaintext-IPIP tunnels.
xfrm4_tunnel.c is the registered handler for IPIP, it used to be ipip.c.
ipip.c now registers itself with xfrm4_tunnel, but xfrm4_tunnel is
marked as a xfrm_prot which is not true for ipip.c. Right now I'm not
even sure that it is a problem and under what exact circumstances, I
need to think about this some more (tomorrow).

>>- new match "policy" for matching the policy that was used during
>>decapsulation (well, the used SAs, policy checks come later), and the
>>policy that will be used for encapsulation.
> 
> 
> Even more interesting... Now we can for sure check that packets coming from
> a tunnel have not been spoofed by another tunnel.

That should also be handled by the policy checks, although at a
later time (at socket-delivery/forwarding). I'm unsure if the
policy checks should happen before packets are looked at by
netfilter, after all it manipulates it's state from information
in these untrusted packets.

> 
> Thanks a lot Patrick.
> My main goal is to use this on 2.4 with davem/herbert xu's ipsec backport.
> I will soon check if your patches apply on top of their implementation.

Thanks for your comments, I'm looking forward to your testing.

Best regards
Patrick


> 
> Cheers,
> Willy
> 


--------------040703000102090302040606
Content-Type: image/x-xfig;
 name="nf+ipsec.xfig.fig"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="nf+ipsec.xfig.fig"

I0ZJRyAzLjIKTGFuZHNjYXBlCkNlbnRlcgpNZXRyaWMKQTQgICAgICAKMTAwLjAwClNpbmds
ZQotMgoxMjAwIDIKMiAxIDAgMiAxIDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAgMCAzCgkg
MzQ2NSA0MDUwIDQyMzAgNDU5MCA0MjMwIDQ1OTAKMiAxIDAgMiA0IDcgNTAgLTEgLTEgMC4w
MDAgMCAwIC0xIDAgMCAyCgkgNDMyMCA0ODYwIDYzMDAgNDk1MAoyIDEgMCAyIDQgNyA1MCAt
MSAtMSAwLjAwMCAwIDAgLTEgMCAwIDIKCSA2MzQ1IDUxNzUgNjM0NSA1MzU1CjIgMSAwIDIg
MSA3IDUwIC0xIC0xIDAuMDAwIDAgMCAtMSAwIDAgMgoJIDQzNjUgNDg2MCA1MTMwIDYwNzUK
MiAxIDAgMiA0IDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAgMCAyCgkgNjM5MCA1NjcwIDUx
MzAgNjA3NQoyIDEgMCAyIDQgNyA1MCAtMSAtMSAwLjAwMCAwIDAgLTEgMCAwIDIKCSA0MjMw
IDMwMTUgNDIzMCA0NTkwCjIgMSAwIDIgMSA3IDUwIC0xIC0xIDAuMDAwIDAgMCAtMSAwIDAg
MgoJIDQyMzAgMzAxNSAzNDY1IDM2OTAKMiAxIDAgMiAxIDcgNTAgLTEgLTEgMC4wMDAgMCAw
IC0xIDAgMCAyCgkgNDI3NSA0ODYwIDM0NjUgNjA3NQoyIDEgMCAyIDEgNyA1MCAtMSAtMSAw
LjAwMCAwIDAgLTEgMCAwIDIKCSA1NDAwIDY0MzUgNTcxNSA2OTMwCjIgMSAwIDIgNCA3IDUw
IC0xIC0xIDAuMDAwIDAgMCAtMSAwIDAgMgoJIDMzNzUgNjM5MCAzMzc1IDc1MTUKMiAxIDAg
MiAxIDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAgMCAyCgkgMjY1NSA3MTEwIDMzNzUgNzUx
NQoyIDEgMCAyIDEgNyA1MCAtMSAtMSAwLjAwMCAwIDAgLTEgMCAwIDIKCSAzNDIwIDc4MzAg
MzQyMCA4MTAwCjIgMSAwIDIgMSA3IDUwIC0xIC0xIDAuMDAwIDAgMCAtMSAwIDAgMgoJIDM0
MjAgODMyNSAyOTcwIDkyMjUKMiAxIDAgMiAxIDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAg
MCAyCgkgMzQ2NSA4MzI1IDQwMDUgOTIyNQoyIDEgMCAyIDEgNyA1MCAtMSAtMSAwLjAwMCAw
IDAgLTEgMCAwIDUKCSAyMTYwIDEwMDM1IDEzNTAgMTAwMzUgMTM1MCAyMzQwIDQyMzAgMjM0
MCA0MjMwIDI3MDAKMiAxIDAgMiAxIDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAgMCA1Cgkg
Mjk3MCA5NTg1IDI5NzAgMTAwMzUgMjE2MCAxMDAzNSAyMTYwIDgwNTUgMzQyMCA4MDU1CjIg
MSAwIDIgNCA3IDUwIC0xIC0xIDAuMDAwIDAgMCAtMSAwIDAgMgoJIDM0NjUgODMyNSA2MDc1
IDgzNzAKMiAxIDAgMiA0IDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAgMCAyCgkgNjA3NSA4
NTk1IDYwNzUgODc3NQoyIDEgMCAyIDQgNyA1MCAtMSAtMSAwLjAwMCAwIDAgLTEgMCAwIDIK
CSA2MDc1IDkwOTAgNjA3NSA5NDk1CjIgMSAwIDIgNCA3IDUwIC0xIC0xIDAuMDAwIDAgMCAt
MSAwIDAgNgoJIDYwNzUgOTgxMCA2MDc1IDk5NDUgNTMxMCA5OTQ1IDUzMTAgODkxMCA0MjMw
IDg5MTAgMzk2MCA5MjI1CjIgMSAwIDIgNCA3IDUwIC0xIC0xIDAuMDAwIDAgMCAtMSAwIDAg
NQoJIDYwNzUgOTA5MCA2MDc1IDkyMjUgNzg3NSA5MjI1IDc4NzUgNTg1MCA1MTMwIDYwNzUK
MiAxIDAgMiAxIDcgNTAgLTEgLTEgMC4wMDAgMCAwIC0xIDAgMCAyCgkgMzM3NSA2MzkwIDI2
NTUgNjg0MAo0IDAgMCA1MCAtMSAwIDEyIDAuMDAwMCA0IDE4MCAxMjYwIDI3MDAgMzk2MCBQ
UkVfUk9VVElOR1wwMDEKNCAwIDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgMTA5NSAzNjkw
IDQ3NzAgW2lwX3Jjdl9maW5pc2hdXDAwMQo0IDAgMCA1MCAtMSAwIDEyIDAuMDAwMCA0IDE4
MCA1ODUgMzkxNSAyOTI1IFtpcF9yY3ZdXDAwMQo0IDAgMCA1MCAtMSAwIDEyIDAuMDAwMCA0
IDE4MCAxNzU1IDU0OTAgNTEzMCBbbmZfcG9zdHhmcm1fbm9ubG9jYWxdXDAwMQo0IDAgMCA1
MCAtMSAwIDEyIDAuMDAwMCA0IDE4MCAxMjYwIDU3NjAgNTU4MCBQUkVfUk9VVElOR1wwMDEK
NCAwIDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgOTMwIDQ2ODAgNjMwMCBbaXBfZm9yd2Fy
ZF1cMDAxCjQgMCAwIDUwIC0xIDAgMTIgMC4wMDAwIDQgMTgwIDEzMDUgMjgzNSA2MzAwIFtp
cF9sb2NhbF9kZWxpdmVyXVwwMDEKNCAwIDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgODg1
IDIxNjAgNzA2NSBMT0NBTF9JTlwwMDEKNCAwIDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAg
MTgxNSAyNTY1IDc3ODUgW2lwX2xvY2FsX2RlbGl2ZXJfZmluaXNoXVwwMDEKNCAwIDAgNTAg
LTEgMCAxMiAwLjAwMDAgNCAxMzUgOTMwIDUyNjUgNzE1NSBGT1JXQVJEXDAwMQo0IDAgMCA1
MCAtMSAwIDEyIDAuMDAwMCA0IDEzNSA3MDUgMzA2MCA4MjgwIHJlc3VibWl0OlwwMDEKNCAw
IDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgMTIxNSAzNjQ1IDk0NTAgcHJvdG9jb2wgaGFu
ZGxlclwwMDEKNCAwIDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgMTAyMCAyMzg1IDk0NTAg
W3hmcm00X2lucHV0XVwwMDEKNCAwIDAgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgMTUwMCA1
MzEwIDg1NTAgW25mX3Bvc3R4ZnJtX2lucHV0XVwwMDEKNCAwIDAgNTAgLTEgMCAxMiAwLjAw
MDAgNCAxODAgODg1IDU2NzAgOTcyMCBMT0NBTF9JTlwwMDEKNCAwIDAgNTAgLTEgMCAxMiAw
LjAwMDAgNCAxODAgMTI2MCA1NTgwIDkwMDAgUFJFX1JPVVRJTkdcMDAxCjQgMCAxNSA1MCAt
MSAwIDEyIDAuMDAwMCA0IDE4MCAxMTQwIDE2MjAgOTcyMCB0cmFuc3BvcnQgbW9kZVwwMDEK
NCAwIDE1IDUwIC0xIDAgMTIgMC4wMDAwIDQgMTM1IDkxNSA4NTUgOTI3MCB0dW5uZWwgbW9k
ZVwwMDEKNCAwIDE1IDUwIC0xIDAgMTIgMC4wMDAwIDQgMTM1IDE5OTUgNzAyMCA5NDUwIERO
QVRlZCB0byBub24tbG9jYWwgZGVzdFwwMDEKNCAwIDE1IDUwIC0xIDAgMTIgMC4wMDAwIDQg
MTgwIDEzMzUgNDIzMCA4MjM1IG5vbi14ZnJtIHByb3RvY29sXDAwMQo0IDAgMTUgNTAgLTEg
MCAxMiAwLjAwMDAgNCAxODAgMTIxNSA0MzIwIDM5MTUgcmVwb3N0ZWQgcGFja2V0XDAwMQo0
IDAgMTUgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgMTIxNSA0OTUwIDQ3MjUgcmVwb3N0ZWQg
cGFja2V0XDAwMQo0IDAgMTUgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAgMTIxNSAzNTEwIDcw
MjAgcmVwb3N0ZWQgcGFja2V0XDAwMQo0IDAgMTUgNTAgLTEgMCAxMiAwLjAwMDAgNCAxODAg
MTIxNSA0Mjc1IDgwMTAgcmVwb3N0ZWQgcGFja2V0XDAwMQo=
--------------040703000102090302040606--
