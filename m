From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Mon, 03 Sep 2007 13:11:36 +0800
Message-ID: <46DB9788.6070901@nj.cpsecure.com>
References: <46CE8C05.5060202@nj.cpsecure.com>	<200708290914.l7T9E934019648@toshiba.co.jp>	<46D5BFB5.6000206@trash.net>
	<46D61A10.6010405@nj.cpsecure.com>	<46D66874.1050405@trash.net>
	<46D6927F.1010406@nj.cpsecure.com>	<Pine.LNX.4.64.0708311044490.32663@x2>	<46D7E687.7060404@nj.cpsecure.com>	<Pine.LNX.4.64.0708311708590.9444@bizon.gios.gov.pl>
	<46DB80D3.5050402@nj.cpsecure.com> <46DB8782.1080207@snapgear.com>
Reply-To: Dong_Wei@nj.cpsecure.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DB8782.1080207@snapgear.com>
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


> Dong_Wei wrote:
>> what kind of rules should I take? It's seemed that there is no rule to 
>> deal with this special case on 2.4 :(
> 
> $IPTABLES -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
Thanks a lot Philip :)
