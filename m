From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_tcpudp.c match unregistration bug
Date: Mon, 19 Jun 2006 17:00:03 +0200
Message-ID: <4496BBF3.2090209@trash.net>
References: <200606121035.07231.yuri@ecl-labs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yuri Gushin <yuri@ecl-labs.org>
In-Reply-To: <200606121035.07231.yuri@ecl-labs.org>
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

Yuri Gushin wrote:
> Hi all,
> 
> There is a match unregistration bug in the __init function of xt_tcpudp.c;
> 
> "xt_unregister_match(AF_INET, &tcp_matchstruct)" is called twice, 
> leaving "udp_matchstruct" registered, in case of a failure in the 
> registration of the udp6 structure.
> 
> Attached is a patch to resolve this issue.

Applied. thanks.
