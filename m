From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 11:08:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se>
References: <20030725085731.GA5776@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20030725085731.GA5776@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jul 2003, Balazs Scheidler wrote:

> Hi,

Hi

> I've stumbled into a similar oops in replace_in_hashes  that somebody else
> has already reported. It was suggested to move to 2.4.21 but it still
> Oopses. It was also suggested to use the latest netfilter patches from
> patch-o-matic, because a refcounting bug was introduced in 2.4.21.
>
> I checked out those patches and it seemed to me that they are only relevant
> if conntrack and/or nat helpers are in use.

Yes the refcounting stuff is just when helpers are used.

> In our situation we do not have _any_ helpers loaded, only TPROXY generates
> dynamic NAT mappings as they are needed. Is it possible that the reference
> counting problem affects us?

Shouldn't be. This problem exists in 2.4.19 and 2.4.21 with
submitted/pending patches from pom.

And it shouldn't be the TPROXY stuff either since it's seen without that
stuff as well.

I'm a bit short on time but I hope I'll be able to look at it next week.
Maybe someone else feels like going on a bughunt during the weekend?

/Martin
