From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Sat, 1 Feb 2003 00:37:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030201003750.A27624@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <20030131115512.GW9073@naboo.cybercafe42>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anders Fugmann <afu@fugmann.dhs.org>, Thomas Heinz <creatix@hipac.org>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20030131115512.GW9073@naboo.cybercafe42>; from laforge@gnumonks.org on Fri, Jan 31, 2003 at 12:55:12PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald!

On Fri, Jan 31, 2003 at 12:55:12PM +0100, Harald Welte wrote:
> On Sun, Jan 26, 2003 at 03:22:27PM +0100, Laszlo Valko wrote:
> > Currently, I see two ways:
> > 1) make a translation function for all currently existing netfilter structures
> >    that use longs or pointers (difficult, as modules can be added
> >    independently), like those in arch/sparc64/sys_sparc32.c, and its
> >    friends,
> 
> it's a hack, but it would work.

Well, we will definitely need it if people want to use netfilter on 2.4,
as that is a stable series, and we don't want to introduce incompatibilities
I guess.
When I arrive to the state of having a little spare time, I might convince
myself to sketch a first version up... It does not look too difficult at least.

> > 2) introduce a new way of passing structures, with new structures, probably
> >    with new setsockopt/getsockopt numbers, essentially creating an API
> >    incompatible with the existing one (there are a few other bleeding wounds
> >    waiting to be solved in the existing interface as I saw).
> 
> please don't go for solution #2.  There is already one new interface
> between kernel an userspace in development... we don't need more
> interfaces than we already have.  

Wow! May I see it? :)

> And yes, the new interface still has the matchinfo of all matches
> concatenated in one memory area.  Everything else has linked lists,
> though (e.g. every rule is a seperately allocated memory chunk).

That's all right, as long as the interface structures != kernel internal
structures. In fact kernel internal structure should be >= interface structure.
Otherwise you cannot solve the problem of using unsigned longs in
interface structures (eg jiffies is always unsigned long unfortunately).

Do we expect to change the modules as well? I mean struct ipt_anything et al.
are expected to change, is that so?


Regards,
Laszlo

> 
> -- 
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> ============================================================================
> GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
> V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
