From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] patch-o-matic fixes
Date: 30 Apr 2003 22:57:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051736263.8201.177.camel@tux.rsn.bth.se>
References: <20030430085332.GA32392@alpha.home.local>
	 <20030430153222.GC685@sunbeam.de.gnumonks.org>
	 <1051717921.8200.151.camel@tux.rsn.bth.se>
	 <20030430202009.GK685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030430202009.GK685@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-30 at 22:20, Harald Welte wrote:
> On Wed, Apr 30, 2003 at 05:52:01PM +0200, Martin Josefsson wrote:
> 
> > It does apply IF you've applied pending/24_conntrack-nosysctl.patch
> > Which should have been done. We've had implicit dependencies on
> > submitted and pending stuff many times.
> > 
> > No need to make a cumulative -rc1 patch, I've managed to get it working
> > for .18 .19 .20 .21-rc1 and .21-bk
> 
> great, thanks for pointing this out.

I have a small script that tests p-o-m against .18 .19 .20
latest .21-{pre,rc} and .21-bk and reports any failures. It is still
missing some stuff and needs a good cleanup before I dare releasing it.

My plans are to implement compile-testing for both user and kernelspace
as well.

-- 
/Martin
