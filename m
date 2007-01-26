From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH */3] several messages
Date: Fri, 26 Jan 2007 17:18:18 +0100
Message-ID: <45BA29CA.9040305@trash.net>
References: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701252314580.17844@yvahk01.tjqt.qr>
	<45BA0E79.3070307@trash.net>
	<Pine.LNX.4.61.0701261701520.22295@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0701261701520.22295@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Did you pick up this question:
> 
> BTW, ip_nat_rule.c <-> nf_nat_rule.c seems to be an almost identical
> copy. Schedule one for removal?

ip_nat and all related code will be removed in 2.6.22.

> There is yet more to xt-ify, like (just look at all the #defines ip xt 
> in linux/netfilter_ipv4/ip_tables.h and ip6_tables.h). However, I was 
> not sure if some of the macros actually do get used by userspace code. 
> Mind filling me in?

Basically anything outside of #ifdef __KERNEL__ needs to stay around
for userspace, at least for now. Long term I would prefer to make
userspace not use any headers from the kernel tree directly.
