From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ip_conntrack performance issues - also semantic issues
Date: 31 Jan 2003 23:58:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1044053917.30435.12.camel@tux.rsn.bth.se>
References: <20030118232752.26497.32589.Mailman@kashyyyk>
	 <15914.20503.476455.344137@isis.cs3-inc.com>
	 <20030119075102.GF12401@oknodo.bof.de>
	 <15914.25470.189261.168220@isis.cs3-inc.com>
	 <20030119091656.GG12401@oknodo.bof.de>
	 <1042969247.28675.57.camel@tux.rsn.bth.se>
	 <20030131113516.GR9073@naboo.cybercafe42>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>,
	Don Cohen <don-netf@isis.cs3-inc.com>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030131113516.GR9073@naboo.cybercafe42>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-01-31 at 12:35, Harald Welte wrote:

> > My small unscientific tests (performed quite some time ago) say that the
> > allocation isn't the most costly operation performed.
> 
> It would also surprise me if allocation cost was _that_ high. Remember,
> we are already using the slab cache for this.

I'll ask Robert Olsson (of NAPI fame) to run a few tests with conntrack
to see where we spend most time in the case of a single (or two) udp
stream(s) on both UP and SMP. I think we should start optimizing for the
already_in_conntrack case first and then move on to fixing the
new_conntrack problem (the global lock is probably the worst problem for
SMP, on UP I have no idea as of now)

> yup.  Why don't we have a 'raw' or 'prestate' table in patch-o-matic
> yet?  This is a very easy job, can't anybody please add this missing
> feature?

We do have such a table in patch-o-matic/userspace, raw.patch and
raw.patch.ipv6, it was Jozsef that made those patches. They contain the
raw table, TRACE (every further match is printk'd) and NOTRACK (assign a
dummy conntrack to the skb) targets.

I've used the raw table to block a few DDoS's (some were >140kpps)
without any problems. I've also tested the TRACE and NOTRACK targets
(only in a testmachine, not in production) and they also worked fine.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.
