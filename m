From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: SNAT multicast traffic
Date: Wed, 9 Feb 2005 09:18:54 -0500
Message-ID: <20050209141854.GB6245@ti64.telemetry-investments.com>
References: <420882B9.3050108@inwind.it>
	<20050208144638.GQ6878@sunbeam.de.gnumonks.org>
	<4208C405.9020907@inwind.it>
	<26663.142.169.215.10.1107957343.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paolo Rossi <paolo_76@inwind.it>, netfilter-devel@lists.netfilter.org
To: Samuel Jean <sj-netfilter@cookinglinux.org>
Content-Disposition: inline
In-Reply-To: <26663.142.169.215.10.1107957343.squirrel@142.169.215.10>
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

On Wed, Feb 09, 2005 at 08:55:43AM -0500, Samuel Jean wrote:
> On Tue, February 8, 2005 8:52 am, Paolo Rossi said:
> 
> > Is it possible to perform stateless nat in Linux ?
> 
> No, the NAT subsystem works on the behalf of conntrack subsystem.
> There's no NAT without conntrack.
> 
> Also, once the conntrack knows the NAT action for a particular
> tuple; the packet doesn't hit PREROUTING of nat table anymore.

Well, there is "route nat" in 2.4 (see iproute documentation).  However,
it was broken by the IPsec changes to 2.6, and subsequently removed
from the 2.6 kernel.

Alternatives with 2.6 include queuing to userspace (slow), some form
of low-level packet mangling using the new tc pedit action interface
(obscure, as with everything tc ;-p), or convincing someone to fix and
readd route nat.

Regards,

	Bill Rugolsky
