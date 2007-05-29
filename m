From: Philip Craig <philipc@snapgear.com>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Tue, 29 May 2007 10:24:32 +1000
Message-ID: <465B72C0.5000907@snapgear.com>
References: <465528CB.4020108@snapgear.com>	<200705250044.l4P0i3f8007580@toshiba.co.jp>	<4656342A.5040202@snapgear.com>
	<4657FBD4.80506@trash.net>
	<1180381991.6505.46.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1180381991.6505.46.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:
> But I am a little curious.. how much difference would it yield if simply
> the loop was instead changed to terminate on string end instead of
> always iterating over the max interface name length..
> 
>         for (i = 0, ret = 0; ((const unsigned long *)ipinfo->outiface_mask)[i] && i < IFNAMSIZ/sizeof(unsigned long); i++) {
> 		...
>         }
> 
> instead of
> 
>         for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
> 		...
> 	}
> 
> plus a small change to the userspace to zero the mask after the first \0
> in the interface name on exact matches.
> 
> The userspace only allow exact or prefix matching, so it should be ok to
> restrict the compare function to this I think..

I'll try that, but that will also prevent loop unrolling if you're
using -funroll-loops.  Not sure if any builds use this, but the
comment in the code implies some do.
