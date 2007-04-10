From: Patrick McHardy <kaber@trash.net>
Subject: Re: Removal of ip_conntrack headers
Date: Tue, 10 Apr 2007 10:06:31 +0200
Message-ID: <461B4587.7050609@trash.net>
References: <200704100618.l3A6IPub003428@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200704100618.l3A6IPub003428@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi, Patrick,
> 
> Doesn't removal of all ip_conntrack headers in 2.6.22 cause build issues
> with some applications ? We can change extensions in iptables, but I'm not
> sure about others.


IIRC only very few of the headers are really needed for tuples and NAT.
In case of iptables I think I would prefer just including them. I'm
not aware of anything else that uses them, are you?
