From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: 05 Apr 2003 14:28:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049545687.25167.177.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304041041450.18961-100000@blackhole.kfki.hu>
	 <1049541403.25169.167.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <1049541403.25169.167.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2003-04-05 at 13:16, Martin Josefsson wrote:
> On Fri, 2003-04-04 at 10:46, Jozsef Kadlecsik wrote:
> 
> > I have just updated the runme script in patch-o-matic:
> > 
> > - removed copying the source trees at patch testing (faster processing)
> 
> Gives a quite nice speedup :)

And makes dependencies fail :(

If patch A requires that patch B is applied before it can apply we are
screwed :) Nothing is applied during testing so even if patch B tests
fine, patch A won't apply since it depends on B which wasn't applied.

So we need to run the tests against a copy of the sourcetree _if_ we
have dependencies (really only if we have real dependencies and not
conflicting dependencies). And it's only the first patch that should
only be tested, the others can be applied directly onto the copy of the
sourcetree (the dependency checks are still performed)

I'll look at it more closely a little later today.

-- 
/Martin
