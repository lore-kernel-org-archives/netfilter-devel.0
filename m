From: Phil Oester <kernel@linuxace.com>
Subject: Re: Fw: Re: network/performance problem
Date: Fri, 12 Mar 2004 08:09:00 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040312160900.GA7504@linuxace.com>
References: <20040311155036.7da85ab4.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Ron Peterson <rpeterso@mtholyoke.edu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20040311155036.7da85ab4.akpm@osdl.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 2/23 I moved a couple of heavily used firewalls from 2.4.19 -> 2.4.25
and they suddenly started dying with no indication at all why in the logs.

Then I moved them to 2.6.3+, and they continued to die.  Yesterday I got
this in the logs on one:

Mar 11 16:22:17 fw01 kernel: ip_conntrack: table full, dropping packet.

which is difficult to fathom given I've got max at 65K.  Also, the day prior:

Mar 10 02:10:32 fw01 kernel: dst cache overflow

which doesn't necessarily indicate netfilter per se, but does point to
networking.

Just adding my 2 cents for now.  I enabled profiling on a box yesterday,
so hopefully it will come up with something useful.

Phil


On Thu, Mar 11, 2004 at 03:50:36PM -0800, Andrew Morton wrote:
> 
> Guys, we do seem to have a netfilter problem.  Could someone please help
> out with this thread on linux-kernel?
