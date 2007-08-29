From: Patrick McHardy <kaber@trash.net>
Subject: Re: The "value" of "-m dscp -dscp" for iptables command
Date: Wed, 29 Aug 2007 20:52:27 +0200
Message-ID: <46D5C06B.4020304@trash.net>
References: <029301c7e544$daf47860$3f8da70a@zhangxiliang>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: zhangxiliang <zhangxiliang@cn.fujitsu.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <029301c7e544$daf47860$3f8da70a@zhangxiliang>
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

zhangxiliang wrote:
> Hello,
> 
>     I find a bug in the manpage of iptables:
>     The description for the value in option "-m dscp -dscp" should be
> modified to 0~63.


Applied, thanks.
