From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU (Patrick McHardy)
Date: Mon, 17 Feb 2003 10:14:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0302170954580.5567-100000@blackhole.kfki.hu>
References: <20030216200158.GB29764@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Don Cohen <don-netf@isis.cs3-inc.com>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030216200158.GB29764@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 16 Feb 2003, Harald Welte wrote:

> On Sat, Feb 15, 2003 at 05:43:55PM -0800, Don Cohen wrote:
> > I'm also more than a little confused.
> > My understanding is that the UDP user can't receive fragments, just a
> > defragmented "datagram", from which he can't tell whether or how it
> > was fragmented.  Is this correct?
>
> yes, at least as long as we are talking about a user using the standard
> socket API and the UDP/IP stack - not talking about raw socktets.

We may re-fragment the packets as we wish if we don't break PMTU.
I don't think the actual fragments have importance even for the users
listening to a raw socket.

> >  > What about storing the biggest fragment size of a packet at
> >  > defragmentation and refragmenting the packet with that size at
> >  > POST_ROUTING if MTU is not smaller.
> > So at this point I gather the goal is the other side of the
> > robustness principle - trying to make something work that probably
> > shouldn't have been tried to begin with.  Are there lots of other
> > things out there that play the same (questionable?) tricks?
>
> if you want to do stateful IP filtering with _transparent_ fragment
> behaviour, I see two possible options:
>
> 1) hold back all individual fragments, once you receive them. once you
> have all fragments, defragment to an internal buffer, but keep the
> fragments.  using the defragmented copy you can consult your ruleset and
> then forward all fragments in case the packet is allowed to pass.
>
> 2) do what I have been proposing: defragment, save the fragment
> sizes/offsets and re-fragment in exactly the same way.

Maybe I'm blind but why should we re-fragment exaclty with the same way?
The receiver doesn't care about it. What we should ensure is that if a
fragment is bigger than the MTU we may send and it's flagged with DF,
then the whole defragmented packet should be discarded and an ICMP error
should be sent back.

The ICMP error sent back is tricky. What should we send back: the
offending fragment? Or header of the defragmented packet with the
size of the too big fragment as packet length would be just fine?

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
