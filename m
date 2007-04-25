From: Phil Oester <kernel@linuxace.com>
Subject: Re: rmmod ip_conntrack hangs.....
Date: Wed, 25 Apr 2007 07:18:25 -0700
Message-ID: <20070425141825.GA17638@linuxace.com>
References: <075601c78707$5d19c800$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <075601c78707$5d19c800$4c01a8c0@elitecore26>
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

On Wed, Apr 25, 2007 at 12:30:09PM +0530, Nishit Shah wrote:
> Hi,
>         when I do rmmod ip_conntrack, rmmod hangs. It is not the case
> everytime but sometimes "rmmod ip_conntrack" hangs.
>         After that I have tried to debug the problem and got following
> observations..
> 
>     1.) in net/ipv4/netfilter/ip_conntrack_core.c, following code of
> function ip_conntrack_cleanup is stuck in infinite loop...

Which kernel version?

Phil
