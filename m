From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetFilter - Packet Filter - TCP Packet Mangling
Date: Wed, 11 Apr 2007 18:38:18 +0200
Message-ID: <461D0EFA.4020802@trash.net>
References: <b7e5e2640704110115x4d9b993bx5638260a2a522e06@mail.gmail.com>
	<461CFC47.6070302@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, krishna kumar <kris3984@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461CFC47.6070302@netfilter.org>
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

Pablo Neira Ayuso wrote:
> krishna kumar wrote:
> 
>>Hi all,
>>      I want to alter the IP Address of any outgoing TCP or HTTP Packet
>>from a windows server2000 system.Is it possible to do it with the NetFilter
>>and If so please suggest me where I can find the sample code .
> 
> 
> Netfilter can help but you'll have to install Linux in your system. We
> don't have any plan to port it to windows, probably we'll do it for Hurd
> once it gets stable.

:)

Actually I already had it running on windows using colinux, but to be
really useful I had to write a network driver that steals away packets
from windows and reinjects them once they passed through colinux (a
horrible experience). Don't have anything of that stuff anymore though.
