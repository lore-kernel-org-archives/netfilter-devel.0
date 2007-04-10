From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Removal of ip_conntrack headers
Date: Tue, 10 Apr 2007 17:36:01 +0900 (JST)
Message-ID: <200704100836.l3A8a3ob018294@toshiba.co.jp>
References: <200704100618.l3A6IPub003428@toshiba.co.jp>
	<461B4587.7050609@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461B4587.7050609@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 10 Apr 2007 10:06:31 +0200

> Yasuyuki KOZAKAI wrote:
> > Hi, Patrick,
> > 
> > Doesn't removal of all ip_conntrack headers in 2.6.22 cause build issues
> > with some applications ? We can change extensions in iptables, but I'm not
> > sure about others.
> 
> 
> IIRC only very few of the headers are really needed for tuples and NAT.
> In case of iptables I think I would prefer just including them. I'm
> not aware of anything else that uses them, are you?

I think that's all. For iptables, ip_conntrack.h(including just
only nf_conntrack_common.h), ip_conntrack_tuple.h and ip_nat_rule.h.
libnetfilter_conntrack has own headers.

-- Yasuyuki Kozakai
