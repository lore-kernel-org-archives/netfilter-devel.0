From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ip_conntrack_hash() problem
Date: Thu, 05 Sep 2002 21:15:07 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905115208.4D0A02C064@lists.samba.org>
References: <1031210342.9785.159.camel@biker.pdb.fsc.net>
Cc: Andi Kleen <ak@suse.de>, Harald Welte <laforge@gnumonks.org>,
	Netfilter Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Wilck <Martin.Wilck@Fujitsu-Siemens.com>
In-Reply-To: Your message of "05 Sep 2002 09:19:01 +0200."
             <1031210342.9785.159.camel@biker.pdb.fsc.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <1031210342.9785.159.camel@biker.pdb.fsc.net> you write:
> Am Don, 2002-09-05 um 02.39 schrieb Rusty Russell:
> 
> > This work is already done:
> > http://www.kernel.org/pub/linux/kernel/people/rusty/patches/Netfilter/connt
rack_hashing.patch.gz
> 
> Well, beautiful.
> Will this go into the main line kernel any time soon?
> (I'd be for that).
> 
> If there's still need for discussion regarding this patch, as the thread
> suggests, I'd propose to go for an intermediate, less intrusive fix like
> mine first.

I'll feed this through 2.5, once it's had some more testing (hint
hint!).  Then Harald will make a call on 2.4.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
