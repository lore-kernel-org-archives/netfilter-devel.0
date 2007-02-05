From: =?UTF-8?B?QXJ0xatyYXMgxaBsYWp1cw==?= <x11@arturaz.net>
Subject: Re: Need an iptables module for hiding NAT.
Date: Mon, 05 Feb 2007 23:35:53 +0200
Message-ID: <45C7A339.9030008@arturaz.net>
References: <45C75479.3090605@arturaz.net>
	<1170709441.23065.27.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1170709441.23065.27.camel@henriknordstrom.net>
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
> mån 2007-02-05 klockan 17:59 +0200 skrev Artūras Šlajus:
> 
>> I need iptables module which would hide NAT. It means that all traffic 
>> being routed through the machine which is running netfilter and doing 
>> routing should be seen as originating from that host.
> 
> The easiest is to proxy instead of natting..

proxying doesn't work, i need full nat with conntrack and traffic shaping =)
