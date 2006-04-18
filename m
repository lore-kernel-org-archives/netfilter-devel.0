From: "James D. Nurmi" <jdnurmi@gmail.com>
Subject: Re: development with queues
Date: Tue, 18 Apr 2006 12:31:20 -0700
Message-ID: <a1f5b31e0604181231x69124db5qd6345d544cea9e44@mail.gmail.com>
References: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>
	<859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>
	<859616420604180346o2706c306wcf7703dc9b7f67e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David Vogt" <mail@davidvogt.de>
In-Reply-To: <859616420604180346o2706c306wcf7703dc9b7f67e9@mail.gmail.com>
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

It is indeed possible, as I've done it (but unfort cant release the
code),  but you have to remember a few things while doing it:

1) Performance, not a big deal w/ modern hardware and 100Mbps, but you
will see a huge hit at Gbit speeds
2) You're going to be munging TCP on the fly, which requires you to
change sequence numbers, as well as adjust the incoming ack's,
otherwise you'll end up with odd retransmits.
3) If you're going for an adequate solution, you can probably work on
single packets, and just delete what you need, but for a real
solution, you may not be able to make a full determination on the data
without queing up multiple packets, which in turn, requires a larger
queue for nfnetlink_queue;
4)  Read TCP spec, it's got a few niggling details that you might not
notice, like syn/fin getting incremented.

Anyhow, if you need some pointers, let me know off list, as it _is_
possible, incredibly interesting, but certainly non-trivial.

On 4/18/06, David Vogt <mail@davidvogt.de> wrote:
> ---------- Forwarded message ----------
> From: David Vogt <beunlovable@gmail.com>
> Date: 18.04.2006 12:31
> Subject: Re: development with queues
> To: miguel Angel Vazquez <mikinho21@gmail.com>
>
>
> Hi,
>
> you can receive the packets using libnetfilter_queue. IP packets to be
> precise, thus you can modify everything above layer 3 (IP), which
> includes HTTP.
>
> This
>   https://svn.netfilter.org/netfilter/trunk/libnetfilter_queue/utils/nfqn=
l_test.c
> might be a good start on how to use libnetfilter_queue. Adding a rule
> for the packets to be processed with target "-j NFQUEUE --queue-num 0"
> sends the packets to your application (that registers for the
> appropriate queue number)
>
> David
>
>
> 2006/4/18, miguel Angel Vazquez <mikinho21@gmail.com>:
> > Hi all.
> >
> > we are trying to develop an application which has to reduce some
> > headers from an intercepted packet (some HTTP headers in order to
> > optimize an UMTS uplink channel).
> >
> > I have read some howtos and I think it can be possible to do that.
> > As i Have understand, the packet remains queued and I can process it
> > in user-space or in kernel-space, but I'm not sure about what the
> > packet "status" is....it has all the IP and TCP headers?Can I modify
> > the HTTP packet??
> >
> > Thanks mates!
> > (sorry for my English)
> >
> >
>
>
