From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking over-window handling
Date: Wed, 2 Feb 2005 10:46:01 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502021017590.24272@blackhole.kfki.hu>
References: <20050128234334.GA20713@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <20050128234334.GA20713@linuxace.com>
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

Hi Phil,

On Fri, 28 Jan 2005, Phil Oester wrote:

> This was a tough one to track down, and also tough to explain...
>
> In cases of packet loss, some broken TCP stacks will send data over the
> window of the receiver.  Then, on the next packet they will resend the
> missing packet, then move on.
>
> The current window tracking code 'ignores' this window overage by resetting
> the end of the packet to the theoretical maximum (corrects the math of the
> stupid sender).
>
> Unfortunately, the sender does receive this over-the-window packet, and does
> increment its ack seq.  So on the next ack after receiving the missing
> packet, the receiver acks with the ack seq it knows about, which is higher
> than that which the window tracking code thinks it has seen.  Consequently,
> it complains that the ACK is over the upper bound, and does not adjust
> the window.

That implies then that the receiver is broken as well, by accepting and
ack-ing out of window segments. But it is true, we anticipate the
behaviour of the receiver here, which we shouldn't.

> After this, communications cease, as each new packet from the sender is
> dropped by the window tracking code -- it thinks it is over the window
> of the sender.
>
> So, we have seen situations where large ftp transfers stop midstream, but
> smaller transfers complete fine (they got lucky).  I've attached a tcpdump
> log at the bottom of this message with some annotation and conntrack
> debugging inserted in appropriate locations for the interested.

Interesting indeed!

> The solution IMO is not to correct the math of the sender -- there is no
> benefit to doing so.  The attached patch does this (and also clarifies
> the language in some debugging code).

The current code follows closely TCP/IP Illustrated vol 2, p. 954: Trim
Segment so Data is Within Window.

Do you know the OS of the communicating parties? Weren't window scaling or
SACK negotiated?

With your proposed patch, we'd actually drop the oow segment. Could you
check that it won't cause problems (besides more logging generated :-)?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
