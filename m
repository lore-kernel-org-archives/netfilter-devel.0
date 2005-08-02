From: Mattia Dongili <malattia@gmail.com>
Subject: Re: BUG: atomic counter underflow at
	ip_conntrack_event_cache_init+0x91/0xb0 (with patch)
Date: Tue, 2 Aug 2005 12:44:49 +0200
Message-ID: <20050802104449.GA3702__11960.3169303902$1122994235$gmane$org@inferi.kami.home>
References: <20050801141327.GA3909@inferi.kami.home>
	<42EE3169.6070604@trash.net>
	<20050801160537.GA3850@inferi.kami.home>
	<42EE5721.1090509@trash.net> <42EEC2BB.3020105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42EEC2BB.3020105@trash.net>
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

On Tue, Aug 02, 2005 at 02:47:55AM +0200, Patrick McHardy wrote:
> Patrick McHardy wrote:
> > Mattia Dongili wrote:
[...]
> >>this doesn't fix it actually, see dmesg below:

blame me... It seems I forgot a damn --dry-run while applying your
first patch :P
And in fact your first fix solves the BUG I was seeing.

> > It looks like ip_ct_iterate_cleanup and ip_conntrack_event_cache_init
> > race against each other with assigning pointers and grabbing/putting the
> > refcounts if called from different contexts.
> 
> This should be a fist step towards fixing it. It's probably incomplete
> (I'm too tired to check it now), but it should fix the problem you're
> seeing. Could you give it a spin?

building right now

> BTW, ip_ct_iterate_cleanup can only be called from ipt_MASQUERADE when
> a device goes down. It seems a bit odd that this is happending on boot,
> is there anything special about your setup?

yes, ifplugd. This morning I noticed that booting without networking a
nd without loading ip_conntrack (no iptables rules) everything proceeded
smoothly. So rebooting normally I noticed that the BUG was triggered as
soon as ifplugd configured eth0 (with ip_conntrack already loaded).
I'll try to narrow the thing more and let you know.


-- 
mattia
:wq!
