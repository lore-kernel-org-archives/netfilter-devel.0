From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] patch-o-matic fixes
Date: 30 Apr 2003 17:52:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051717921.8200.151.camel@tux.rsn.bth.se>
References: <20030430085332.GA32392@alpha.home.local>
	 <20030430153222.GC685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030430153222.GC685@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-30 at 17:32, Harald Welte wrote:

> > 2) extra/tcp_window_tracking doesn't apply to 2.4.21-rc1 anymore because
> >    of a small context change.
> 
> I don't want to change this before we have a cumulative 2.4.21.patch.
> This is the only way in order to have patch-o-matic compatible with
> old and new kernel versions.
> 
> Martin, can you please make a cumulative 2.4.21-rc1.patch, including all
> netfilter changes that have been included up to rc1? 

It does apply IF you've applied pending/24_conntrack-nosysctl.patch
Which should have been done. We've had implicit dependencies on
submitted and pending stuff many times.

No need to make a cumulative -rc1 patch, I've managed to get it working
for .18 .19 .20 .21-rc1 and .21-bk

When .21 comes out we'll make a cumulative patch.

-- 
/Martin
