From: Cory Visi <merlin@gentoo.org>
Subject: Re: [ANNOUNCE] ipset 2.2.3 released
Date: Thu, 15 Sep 2005 03:58:20 +0000
Message-ID: <20050915035820.GA19885@toucan.gentoo.org>
References: <Pine.LNX.4.58.0509141241230.23538@blackhole.kfki.hu>
	<200509141002.40185.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200509141002.40185.teastep@shorewall.net>
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

My patch (posted to this list with subject line: patchlets patch 
submission) may be helpful here.

-Cory

On Wed, Sep 14, 2005 at 10:02:30AM -0700, Tom Eastep wrote:
> On Wednesday 14 September 2005 03:46, Jozsef Kadlecsik wrote:
> > Hi,
> >
> > I'm happy to announce ipset 2.2.3. The changes compared to the previous
> > release are:
> 
> ...
> 
> > - lockhelp.h was removed from the 2.6.13 kernel tree, ip_set.c is
> >   updated accordingly (Cardoso Didier, Samir Bellabes)
> 
> This patch doesn't seem to be in svn or in the snapshot tarball linked from your site.
> 
> CC [M]  net/ipv4/netfilter/ip_set.o
> net/ipv4/netfilter/ip_set.c:35: warning: type defaults to ???int??? in declaration of ???DECLARE_RWLOCK???
> net/ipv4/netfilter/ip_set.c:35: warning: parameter names (without types) in function declaration
> net/ipv4/netfilter/ip_set.c: In function ???ip_set_find_in_hash???:
> net/ipv4/netfilter/ip_set.c:86: warning: implicit declaration of function ???MUST_BE_READ_LOCKED???
> net/ipv4/netfilter/ip_set.c:86: error: ???ip_set_lock??? undeclared (first use in this function)
> net/ipv4/netfilter/ip_set.c:86: error: (Each undeclared identifier is reported only once
> net/ipv4/netfilter/ip_set.c:86: error: for each function it appears in.)
> net/ipv4/netfilter/ip_set.c: In function ???__set_hash_del???:
> net/ipv4/netfilter/ip_set.c:103: warning: implicit declaration of function ???MUST_BE_WRITE_LOCKED???
> net/ipv4/netfilter/ip_set.c:103: error: ???ip_set_lock??? undeclared (first use in this function)
> net/ipv4/netfilter/ip_set.c: In function ???ip_set_hash_del???:
> net/ipv4/netfilter/ip_set.c:120: warning: implicit declaration of function ???WRITE_LOCK???
> net/ipv4/netfilter/ip_set.c:120: error: ???ip_set_lock??? undeclared (first use in this function)
> net/ipv4/netfilter/ip_set.c:129: warning: implicit declaration of function ???WRITE_UNLOCK???
> net/ipv4/netfilter/ip_set.c: In function ???ip_set_hash_add???:
