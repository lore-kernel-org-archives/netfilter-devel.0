From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: PATCH: extra conntrack stats
Date: Fri, 02 May 2003 18:57:31 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502090512.834482C085@lists.samba.org>
References: <20030502070651.GG15143@oknodo.bof.de>
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-reply-to: Your message of "Fri, 02 May 2003 09:06:51 +0200."
             <20030502070651.GG15143@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030502070651.GG15143@oknodo.bof.de> you write:
> On Fri, May 02, 2003 at 03:31:50PM +1000, Rusty Russell wrote:
> > Yes, you're both right, I'm stupid.  Scratch this "great idea".
> 
> Sorry, but you are not stupid.

Sorry, no, I am stupid.

> I do care for non-NAT workloads, and the
> approach would help greatly, there.
> 
> In the normal ip_conntrack, one tuple is left, which is normally used
> for both directions of a non-NAT connection. In addition, there's a
> pointer, ordinarily 0, which can point to a NAT-reverse-tuple.
> 
> When NAT starts to manipulate headers, it modifies ip_conntrack anyway;
> in that place, it can also allocate a suitable NAT-reverse-tuple, attach
> that to the conntrack, and put it into the hashes.

The initial reason I wanted to get rid of the duplicates is the
locking pain it produces.  If we go for RCU, then it's not a problem,
though.

We'll need to keep around the back-pointer inside the hash entry: if
we really only had one, we could use container_of().  We could cover
this up in some helper macro I guess...

> In fact, this setup gives a nice extra feature: for NATted connections,
> we now logically have four flows in our hashes (physically two, due
> to the key mirror property). Two of those four flows are INVALID, and
> this can easily be determined when initially looking for the conntrack
> of an incoming skb. Not that I know the area well, but I feel that this
> could make some NAT setup decisions a lot simpler.

Not sure this is correct.  But anyway, I think some nice helper
functions #ifdef CONFIG_IP_NF_NAT_NEEDED could make this workable: not
so sure about optimizing for the "we could NAT, but most connections
aren't NAT" case...

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
