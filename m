From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 22:08:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725200837.GC7814@balabit.hu>
References: <20030725085731.GA5776@balabit.hu> <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se> <20030725135020.GA6433@balabit.hu> <20030725173555.GA7458@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <20030725173555.GA7458@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 25, 2003 at 07:35:56PM +0200, Balazs Scheidler wrote:
> > As I see it is quite unlikely that the same memory area is used for
> > different purposes when a kmem_cache is used, as kmem_cache tries to reuse
> > blocks. I therefore think that we face a use-after-free conntrack scenario.
> > 
> > Any other thoughts, hints?
> 
> One little addition, which might prove to be important, is that the bogus
> next pointer which is tried to be dereferenced contains the IP address of the
> last SNAT mapping that was being made. The manips array of the ip_nat_info
> structure is only a couple of bytes away, hm... 

I think I've found something, but I am afraid it is tproxy specific, so it
might not be the same.

my tproxy patch does not verify whether the NAT manip associated with the
current hook has already been set up, or not. E.g. this code is missing:

                if (!(info->initialized & (1 << maniptype))) {
			ip_nat_setup_info()
		}

Looking at the comments in the code, it might happen that the same packet
traverses the hooks several times, and this might mean that the array
holding NAT manips is overflowed.

My question is: how and which packets might be retransmitted like this? Are
those taken as NEW or ESTABLISHED?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
