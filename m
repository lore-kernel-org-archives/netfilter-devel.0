From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [NETFILTER] Kill lockhelp.h for rtsp-conntrack
Date: Tue, 30 Aug 2005 00:36:52 +0200
Message-ID: <m2k6i48j5n.fsf@cerbere.dyndns.info>
References: <m2u0h8vekb.fsf@cerbere.dyndns.info>
	<m2k6i4veb1.fsf@cerbere.dyndns.info> <431375BA.7080900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Samir Bellabes <sbellabes@mandriva.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <431375BA.7080900@trash.net> (Patrick McHardy's message of "Mon,
	29 Aug 2005 22:53:14 +0200")
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

Patrick McHardy <kaber@trash.net> writes:

> All applied, thanks. I've changed the raw spinlock/rwlock declarations
> to DEFINE_SPINLOCK/DECLARE_RWLOCK.
ok, thanks.

>> well, in fact, it should be applyed to a new 'linux-2.6.13' directory..
>
> Do you mean it needs to be applied to other directories than -p1 in the
> patchlets dir?

I mean that linux-2.6.11 don't need this patch at all.
As far a you push 'kill lockhelp.h patch' in 2.6.13, people who use
p-o-m with a kernel version < 2.6.13, should use lockhelp.h again.
But now, this 3 patches will apply to all versions.

But it's not a main problem. And yes, i know versionning in p-o-m is
always discussed.

thanks for applying,
Samir Bellabes
