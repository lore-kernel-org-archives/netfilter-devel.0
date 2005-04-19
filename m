From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nfnetlink/ctnetlink - OOPS&panic
Date: Tue, 19 Apr 2005 14:04:06 +0200
Message-ID: <4264F3B6.9010408@eurodev.net>
References: <Pine.LNX.4.62.0504191220390.27543@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0504191220390.27543@bizon.gios.gov.pl>
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
> Hello,
> 
> I have just compiled 2.6.11.7 kernel with nfnetlink/ctnetlink support 
> (from pom-ng-20050418). Unfortunately, during system startup, kernel 
> panics:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 
> 000000b3
>  printing eip:
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in: bonding

You've catch a race condition.

Since you've compiled nfnetlink and ctnetlink in kernel, not as module, 
it seems that ctnetlink registers the subsystem via 
nfnetlink_subsys_register before nfnetlink has created the netlink 
socket. Then you've received an event that has been sent to a 
non-existing netlink socket. I can cook an oops with that.

I'll fix it as soon as I get some spare time.

--
Pablo
