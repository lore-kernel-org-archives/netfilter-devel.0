From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] ipt_owner.c improvements
Date: Sat, 05 Mar 2005 00:35:57 +0100
Message-ID: <4228F0DD.7030307@trash.net>
References: <4227B908.4070900@evtek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Juha Heljoranta <juha.heljoranta@evtek.fi>
In-Reply-To: <4227B908.4070900@evtek.fi>
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

Juha Heljoranta wrote:
> I'd like to make few improvements to ipt_owner.c or perhaps to create 
> something new that is like owner match.
> 
> First I'd like to improve performance for incoming packet matches. The 
> next thing is to reliably identify sending/receiving process. Last 
> proposal is to improve performance when matching is done several times 
> per packet.

As Dave Miller pointed out, the only sensible thing to do is add new
hooks to the protocols themselves, anything else is racy. The main
challenges are making sure incoming connections using protocols that
support sockets aren't confirmed before they survived the socket
hooks, with all possible module combinations, and possibly hooks for
outgoing packets, I haven't thought about that very much.

Regards
Patrick
