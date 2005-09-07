From: Pablo Neira <pablo@eurodev.net>
Subject: Re: New target: can't delete rule
Date: Thu, 08 Sep 2005 01:58:59 +0200
Message-ID: <431F7EC3.7020902@eurodev.net>
References: <1126116594.3690.35.camel@Pentium> <431F6A0E.1090707@eurodev.net>
	<431F6B0C.7070303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gervasio Bernal <gervasiobernal@speedy.com.ar>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <431F6B0C.7070303@trash.net>
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

Patrick McHardy wrote:
> Thanks, I didn't know about this problem. We should really focus on
> a netlink interface to iptables once nf_conntrack is in, even without
> pkttables.

Should be really worthy the effort of implementing such netlink 
interface for iptables? I'm not too convinced. It'd be better if we 
spend our time implementing pkttables on top of netlink since it's meant 
to supersede all the functionalties provided by iptables. Anyway, I 
expect that there will be time to discuss this stuff during the workshop ;)

--
Pablo
