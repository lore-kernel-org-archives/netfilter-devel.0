From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Fri, 19 Mar 2004 23:03:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403192301220.13339-100000@filer.marasystems.com>
References: <405B439C.7090009@nk.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <405B439C.7090009@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 19 Mar 2004, Victor Julien wrote:

> > Then you must use incremental commands, keepint the accounting rule 
> > untouched.
> 
> Hmmm, that i don't want.

Then your other option is to dump the existing rule, parse the counter and
include this in the input.

> So i have to read the current counters first by parsing 
> 'iptables-save'-output. And i can then recreate the rules and set the 
> counters to their old values?

Yes.

> Using 'iptables-restore' can i flush one chain, but leave another 
> untouched?

Yes, by using disabling the implicit flush (--noflush option) and then 
use the flush command explicitly.

> If so, i can create an accounting chain which will not be 
> flushed...

True. Probably much better approach than what is discussed above.

Regards
Regards
Henrik
