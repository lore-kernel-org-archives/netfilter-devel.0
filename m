From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: It is possible to route the bridge packet?
Date: Fri, 20 Aug 2004 13:04:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408201302290.24377@filer.marasystems.com>
References: <20040819121547.15140.70414.Mailman@vishnu.netfilter.org>
 <001801c48681$cd08ddb0$a06464c0@kesineni>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kesineni sai pratap <kesineni@woojininc.net>
In-Reply-To: <001801c48681$cd08ddb0$a06464c0@kesineni>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Aug 2004, kesineni sai pratap wrote:

> I configured bridge in between two interfaces eth1 , eth2. when
> packet arrives at eth1 , pass through the bridge reaches the eth2. My
> requirement is  send this packets to routing  module, route the packet.

Then you need to tell the bridge to divert the packet to the local host as 
if it hat a destination MAC of the bridge interface.

> I change linux source code making a way for packet to go another 
> interface. iam getting problem in ip_route_input_slow because of 
> fib_lookup.because of that reason my system hangs.

>From my understanding of the bridge no changes should be needed, just a 
matter of configuration.

Regards
Henrik
