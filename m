From: Pablo Neira <pablo@eurodev.net>
Subject: Re: REJECT using invalid data
Date: Wed, 08 Dec 2004 00:54:09 +0100
Message-ID: <41B642A1.9030807@eurodev.net>
References: <Pine.LNX.4.53.0412072347080.2736@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.53.0412072347080.2736@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:

>I'm not sure if changing "-j REJECT" to drop invalid tcp packets is good
>idea since we have -m unclean and we can drop such packets explicitly
>with this match.
>

unclean was removed from 2.6 series

> And what about other protocols (udp, etc) when REJECT
>generates ICMP port-unreachable?
>  
>

you are right, udp stuff is missing, checkings here are trivial to add 
anyway. I'll think about this issue more carefully in next days.

--
Pablo
