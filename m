From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: netfilter on solaris?
Date: Fri, 14 Jun 2002 12:47:07 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020614104707.GA6827@balabit.hu>
References: <20020614100540.GA6399@balabit.hu> <Pine.LNX.4.33.0206141216360.17029-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206141216360.17029-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 14, 2002 at 12:32:55PM +0200, Jozsef Kadlecsik wrote:
> On Fri, 14 Jun 2002, Balazs Scheidler wrote:
> 
> > It is a strange idea I know, but I'd be interested in what the opinion of
> > the core netfilter developers is on porting the whole netfilter subsystem to
> > Solaris?
> 
> You must have plenty of time. I envy you! :-)

I don't. I simply need to run Zorp on Solaris.

btw: I've found some proxy functionality in the Solaris core kernel while
looking at the source. Should I turn to DaveM now pointing at this? :) (he
was the one who said: I don't care about transparent proxying as long as it
does _NOT_ touch the TCP core)

> 
> > Apart from the technical issues, would there be any problems? Does the GPL
> > allow this kind of usage? (it would be implemented as a module)
> 
> If the module is GPLed, then I don't see problems here but I'm not a
> layer.

I assume you meant an s/layer/lawyer/ here. As I know it is allowed to write
GPLd modules for Photoshop (the gimp plugin issue), so it must be allowed to
use GPLd modules in a propriately kernel.

> 
> But how do you imagine the porting so that the maintenance would not
> become a nightmare?

Of course I'd want to provide system independency using some headers which
would make it work on both Linux/Solaris, so it could be incorporated into
standard Netfilter as well. 

So including headers would be changed from:

#include <linux/version.h>
#include <linux/module.h>
#include <linux/types.h>
....

#include <linux/netfilter_ipv4/ip_nat.h>
#include <linux/netfilter_ipv4/ip_nat_protocol.h>
#include <linux/netfilter_ipv4/ip_nat_core.h>
#include <linux/netfilter_ipv4/ip_nat_helper.h>
#include <linux/netfilter_ipv4/listhelp.h>
...

To:

#include "os.h"
#include <netfilter_ipv4/ip_nat.h> 

etc.

And maybe references to sk_buff * and skb related functions would be changed
to inline functions or macros. It's a huge work I assume, but ipfilter's
code is _very_ disappointing.

> 
> > Technically, the most difficult tasks are to remove the dependency on Linux
> > like sk_buff (Solaris has a chain of mblk_t's), locking (it's more or less
> > done using macros), routing differences and I suppose many things I don't
> > see right now.
> 
> Challenging. But wouldn't it be more straightforward to run Linux on that
> SPARC machine? And there are still plenty to do on 32/64bit issues in
> netfilter...

The bad thing is that it's not a single computer I want to use. I want to
create a product that runs on Suns, and it's generally not a good practice
to dump Solaris and use Linux instead.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
