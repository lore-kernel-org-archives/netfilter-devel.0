From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Thu, 24 Jun 2004 13:26:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40DABA52.9070700@trash.net>
References: <200406240404.NAA01264@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,  laforge@netfilter.org,
 kisza@securityaudit.hu,  usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200406240404.NAA01264@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yasuyuki Kozakai wrote:
> Hi, folks,
> 
> In the current kernel, skb is linearized by skb_linearize() in ip6_tables.c.
> I suggest removing this, and this patch is the 1st step to do it.
> 
> To remove skb_linearize(), this patch changes the API of match() like
> ip_tables.h

I'm not sure the way iptables does it is really the right way. We call
skb_copy_bits for anything that needs to be matched after the ip_header.
Think of 100 rules matching "-p tcp --dport X". We copy the tcp header
100 times, for a total of 2000 bytes. One call to skb_linearize would
most likely be less expensive. I'm thinking about putting the copied
protocol header in the control buffer, this would reduce this extensive
copying a lot. We could also do some common preprocessing steps in one
place, like converting things to host byte order.

Comments anyone ?

Regards
Patrick
