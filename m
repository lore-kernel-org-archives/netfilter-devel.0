From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: ip_conntrack_tcp_be_liberal vs. large downloads?
Date: Tue, 20 Sep 2005 11:46:41 +0200
Message-ID: <20050920094641.GB18821@merlin.emma.line.org>
References: <20050920080825.GA6536@merlin.emma.line.org>
	<Pine.LNX.4.58.0509201127490.745@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Andree <matthias.andree@gmx.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0509201127490.745@blackhole.kfki.hu>
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

On Tue, 20 Sep 2005, Jozsef Kadlecsik wrote:

> > I can also test newer kernels if needed - only if there'd been some bug,
> > I might have assumed that SUSE rolled a patch into one of their update
> > kernels.
> 
> Please try newer kernels - I smell SACKing lost packets and ACKing out of
> window segments here, which is fixed (i.e. supported) in recent kernels.

Maybe, although turning SACK of didn't help (of course if the other side
is doing it, my turning it off cannot help :)

OK, so we'll put this on hold and I'll try 2.6.13-ckN (whichever is
current) or 2.6.14.rc2 first and report back. No-one waste time now
until I've confirmed the problem fixed.

Thank you.

-- 
Matthias Andree
