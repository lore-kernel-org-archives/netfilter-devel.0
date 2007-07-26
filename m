From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Thu, 26 Jul 2007 11:50:31 +0200
Message-ID: <46A86E67.2050501@trash.net>
References: <35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
	<Pine.LNX.4.62.0707251912150.31124@wlug.westbo.se>
	<36349.81.207.0.53.1185385305.squirrel@secure.samage.net>
	<200707260127.l6Q1RPP6019173@toshiba.co.jp>
	<60467.81.207.0.53.1185443160.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Indan Zupancic <indan@nul.nu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <60467.81.207.0.53.1185443160.squirrel@secure.samage.net>
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

Indan Zupancic wrote:
> On Thu, July 26, 2007 03:27, Yasuyuki KOZAKAI wrote:
> 
>>I have one more question. Does that node receive ICMP error including
>>fragmented packet in its body ? I made ICMP error handling call
>>ipv4_get_l4proto in 2.6.23 tree.


Good point, I initially missed that this affects the current -rc.

> I don't know, how can I check that?


iptables -t raw -I PREROUTING \
	-m icmp --icmp-type destination-unreachable -j LOG

should log the packets.
