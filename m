From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec and/or netfilter problem
Date: Thu, 29 Jul 2004 02:29:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <410844F2.3030503@trash.net>
References: <20040728212823.GA19345@mortadelo.pirispons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiko Piris <kernel@pirispons.net>
In-Reply-To: <20040728212823.GA19345@mortadelo.pirispons.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Kiko Piris wrote:
> Hi,
> 
> I've set up ipsec in my home LAN, it works like a charm except for a
> little problem.
> 
> The problem is that the server sends the data to Internet without doing
> SNAT (checked with tcpdump) (the packets do not traverse the POSTROUTING
> chain in nat table, checked watching the pkts counters).
> 
> Anyone has any hint?

You could try the netfilter+ipsec patches in netfilter patch-o-matic-ng,
they should solve this problem, The current patches only apply to 2.6.6,
but I will update them next week

> 
> If this is not the right list to post this kind of things, where should
> I ask?

netfilter-devel@lists.netfilter.org

Regards
Patrick
