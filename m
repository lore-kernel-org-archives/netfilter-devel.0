From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnfnetlink/libctnetlink  ctrace
Date: Wed, 22 Feb 2006 07:42:29 +0100
Message-ID: <43FC07D5.4060703@trash.net>
References: <20030602222644.6397.85967.Mailman@kashyyyk>
	<019201c32c2c$b66b89f0$010f430a@elitecore7>
	<3EE09AAE.8040902@trash.net>
	<20030611124109.GO32593@sunbeam.de.gnumonks.org>
	<3EE72C6C.7050400@trash.net> <43FC05D1.2020703@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sumit <sumit@elitecore.com>
In-Reply-To: <43FC05D1.2020703@elitecore.com>
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

Sumit wrote:
> Hi Patrick,
>    Its been very nice of using nfnetlink work
>    I feel to extend it with procfs and/or module load parameter
>    to Include support of enable/disable events notification.
>    Example:
>     A user only interested into new conntrack creattion
>    Any comments?

We already have seperate groups for different event types in the
current kernel. I hope you're using that version and not the
almost three year old patch you replied too :)
