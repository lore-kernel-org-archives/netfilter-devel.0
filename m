From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.3
Date: Sun, 7 Jul 2002 17:53:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707175339.N13116@oknodo.bof.de>
References: <20020707151703.M13116@oknodo.bof.de> <1026054628.1283.170.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1026054628.1283.170.camel@tux>; from gandalf@wlug.westbo.se on Sun, Jul 07, 2002 at 05:10:28PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The rt hash doesn't do well at all on your data. The winner on your data
> is crc32 which is very robust in all tests on all data it seems. It's
> just a shame that it's so cpu-consuming compared to the other hashes.

The abcd hash also fares very well, if we disregard the results for
the (avoidable) bad bucket counts. abcd plus prime bucket counts would
be as good as crc32, if I did not overlook some result.

On the other hand, I would not dismiss one or the other function right
now. We lack a thorough understanding for plausible attack vectors.

> No real diffrence between crc32 and crc32_bof, crc32_bof is slightly
> more cpu-consuming but that's it.

I'm not really worried about the relative CPU usage of the functions
we have now; they are all faster than a single random memory reference.

And the crc32 could be optimized more. I'll probably work on that
for a bit, now.
 
> Have you tested crc32 with initial seed as well?
> crc32 + seed that's randomly generated at conntrack init would probably
> work well.

For the abcd hash, random generation of the multipliers is also an option.
This, together with the possibility to chose the bucket count as the
"randomly Nth smaller prime" than the value given by the user, should give
a potential attacker a pretty hard time.

But I'll stay undecided on the issue for some more time. We are still lacking
any data from genuine web servers, and we only have a vague feeling about
what an attacker may do.

best regards
  Patrick
