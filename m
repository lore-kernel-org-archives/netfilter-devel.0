From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 20 Apr 2005 11:25:05 -0700
Message-ID: <20050420182505.GA7612@linuxace.com>
References: <4250FA72.3020502@trash.net> <20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
	<20050419005847.GA591@linuxace.com> <42666F4C.5080706@trash.net>
	<20050420155308.GA7057@linuxace.com> <42667E51.3060005@trash.net>
	<20050420172406.GB7057@linuxace.com> <42669674.3020905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42669674.3020905@trash.net>
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

On Wed, Apr 20, 2005 at 07:50:44PM +0200, Patrick McHardy wrote:
> >I'm aware of that, but again I claim that it is irrelevant in this case
> >because the PORT commands will not be processed out of order (even if the
> >data packets are), and thus the adjustments will occur sequentially.
> 
> Why wouldn't they be processed out of order by nat?

Because a second transfer will not be started until the first completes
in my experience.  Thus, there will not be two 'PORT' packets floating 
around to potentially arrive out of order

> I agree that the problem should be fixed ASAP. I'll do a proper fix
> now - either by moving seq adjustment after NAT helpers or by adding
> a flag to the skb.

Doesn't sound like a -stable fix, but whatever you think is best.

Phil
