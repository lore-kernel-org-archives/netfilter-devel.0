From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Wed, 29 Nov 2006 13:50:14 +0100
Message-ID: <456D8206.5030308@trash.net>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>	<20061112173312.GA2593@linuxace.com>	<cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>	<4560F02C.4040905@netfilter.org>
	<4565ABD6.5070909@trash.net>	<45660B13.5010906@netfilter.org>	<20061124055541.GA3707@linuxace.com>
	<4566B0B2.8070900@trash.net> <20061129044457.GA11381@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "Laurence J. Lane" <ljlane@debian.org>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20061129044457.GA11381@linuxace.com>
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

Phil Oester wrote:
> On Fri, Nov 24, 2006 at 09:43:30AM +0100, Patrick McHardy wrote:
> 
>>Thanks guys, please let me know when you want me to apply it.
>>I want to make another iptables release soon because of the
>>compilation errors with the endian annotations in 2.6.19.
> 
> 
> I've reviewed Pablo's patch and it looks good to me.  It handles
> the CIDR case nicely, as well as fixing up the breakage I 
> introduced in /etc/{networks,hosts} handling.  

Thanks everyone, I've applied Pablo's patch.
