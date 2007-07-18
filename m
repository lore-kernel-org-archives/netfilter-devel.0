From: "=?ISO-8859-2?Q?Stanis=B3aw_Pitucha?=" <viraptor@gmail.com>
Subject: Re: ENOBUFS in nfq under heavy load
Date: Wed, 18 Jul 2007 10:47:55 +0100
Message-ID: <717e7cba0707180247q26c868f4i2c70631f6920119b@mail.gmail.com>
References: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
	<469CE69A.9010509@trash.net>
	<717e7cba0707170913t39a335beod068a9670e55808f@mail.gmail.com>
	<469CEADE.9080104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469CEADE.9080104@trash.net>
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

On 7/17/07, Patrick McHardy <kaber@trash.net> wrote:
> Stanis=B3aw Pitucha wrote:
> > By stops I mean that it hangs on nfq_destroy_queue() if there was
> > ENOBUFS before.
>
> Please try to find out what the kernel is doing using sysrq.

Right... not the kernel really :) - libnfnetlink stops at
libnfnetlink-0.0.25/src/libnfnetlink.c:659 (in nfnl_talk()). It's just
waiting for a datagram from netfilter - recvmsg(nfnlh->fd, &msg, 0).
So kernel as far as I can tell... forgot about that socket completely
- so nothing happens. I can't see any calls to NF happening after
that. If there's any possibility to get NF in debug mode, I can
recompile and post it - is there?
But I don't know if that's recoverable at all - should I be trying to
close queue after ENOBUFS? Maybe the socket is closed by design.

> ENODEV can happen when sending a verdict for or unbinding a non-existant
> queue.

http://pastebin.ca/624472
here I get ENOBUFS on read on line 4, so it breaks out of loop and
tries to clean up.

Additionally - I tried to force opening new queue after receiving
ENOBUFS. It does one or two successful reads and throws another
ENOBUFS.

Anyone knows how to solve this? Or should I just write own module?...
