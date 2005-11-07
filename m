From: Horms <horms@debian.org>
Subject: Bug#337713: [netfilter-core] [PATCH] Null pointer access in nf_queue()
Date: Mon, 7 Nov 2005 18:11:55 +0900
Message-ID: <20051107091154.GB9906@verge.net.au>
References: <E1EYW7S-0000uH-00@master.debian.org> <20051107083953.GA8420@verge.net.au> <20051107085555.GF26843@sunbeam.de.gnumonks.org>
Reply-To: Horms <horms@debian.org>, 337713@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.337713.B337713.113142090326201@bugs.debian.org>
To: Harald Welte <laforge@netfilter.org>,
	Torok Edwin <edwintorok@gmail.com>, 337713@bugs.debian.org,
	coreteam@netfilter.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@coreworks.de>
Content-Disposition: inline
In-Reply-To: <20051107085555.GF26843@sunbeam.de.gnumonks.org>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 07, 2005 at 09:55:56AM +0100, Harald Welte wrote:
> On Mon, Nov 07, 2005 at 05:39:53PM +0900, Horms wrote:
> 
> > I did some disasembling fun and games, and I'm pretty sure the patch
> > below will fix your problem. I'll fire of a build, I'd be greateful if
> > you could test it.
> 
> Sorry, Horms, you must have missed my previos fix (that does exactly the
> same).  I've already posted it to netdev, and IIRC, Arnaldo has merged
> it for net-2.6.15.
> 
> Sorry for not Cc'ing you with the fix, it seems like I only reported
> back to bugzilla :(

No problem, it would have saved me some hunting, but actually it was
quite fun. Glad to hear the problem is fixed.

-- 
Horms
