From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 13:08:13 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201256200.9468-100000@filer.marasystems.com>
References: <3FBCAAF7.3040704@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3FBCAAF7.3040704@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, Patrick McHardy wrote:

> It's a relative uncritical error, ip_nat_helper_register races with
> ip_conntrack_helper_unregister. The attached patch should
> fix it.

The same change needs to be done in both functions I presume.. the warning 
is given on both register and unregister.

I will give it a try. 

Hmm.. to be correct doesn't the lock need to be held until the module
counter have been increased in ip_nat_helper_register? And does this lock
really solve the race in the first place? What prevents
ip_conntrack_helper_unregister from unregistering the conntrack helper
when the lock is released? The module use count check has already been
long passed at that time..

But as you say it is a relatively uncritical error. The chance for 
concurrent ip_conntrack_helper_unregister and ip_nat_helper_register is 
close to nil (of not non-existent)

Regards
Henrik
