From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LIBNFNETLINK] Introduce nfnl_listen_for_msecs
Date: Tue, 07 Feb 2006 20:55:45 +0100
Message-ID: <43E8FB41.2000905@trash.net>
References: <43E7FC3A.4050209@eurodev.net> <43E8A810.6010108@trash.net>
	<43E8AFCF.5040604@eurodev.net> <43E8B107.8040301@trash.net>
	<43E8CCBD.6050807@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43E8CCBD.6050807@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>I got that :) What I actually wanted to know is what kind of program
>>would need this, and if its not likely that most programs need their
>>own select-loop for dealing with other fds anyway. Or in other words,
>>I'm not convinced this feature belongs inside libnfnetlink.
> 
> 
> But if I want to poll events, I'll have to work with the netfilter
> netlink socket from, say libnetfilter_conntrack or a normal program. So
> it will have to know about the netlink details.

Not the details, just the fd.

> AFAICS that would be a layer violation since libnfnetlink contains all
> the low level communication system with the netlink socket.

>From a poll/select perspective, the fd itself has nothing to do with
nfnetlink, its just a fd. I don't think this belongs inside
libnfnetlink, it has no direct relationship to nfnetlink. Even
nfnl_listen is questionable, the only reason it exists is probably
that it got copied from iproute's libnetlink.
