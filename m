From: Sumit <sumit@elitecore.com>
Subject: Re: libnfnetlink/libctnetlink  ctrace
Date: Wed, 22 Feb 2006 12:03:53 +0530
Message-ID: <43FC05D1.2020703@elitecore.com>
References: <20030602222644.6397.85967.Mailman@kashyyyk>
	<019201c32c2c$b66b89f0$010f430a@elitecore7>
	<3EE09AAE.8040902@trash.net>
	<20030611124109.GO32593@sunbeam.de.gnumonks.org>
	<3EE72C6C.7050400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 Harald Welte <laforge@netfilter.org>
In-Reply-To: <3EE72C6C.7050400@trash.net>
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

Hi Patrick,
    Its been very nice of using nfnetlink work
    I feel to extend it with procfs and/or module load parameter
    to Include support of enable/disable events notification.
    Example:
	A user only interested into new conntrack creattion
    Any comments?

-- Sumit
----- Original Message -----
From: "Patrick McHardy" <kaber@trash.net>
To: "Harald Welte" <laforge@netfilter.org>
Cc: "Sumit Pandya" <sumit@elitecore.com>;
<netfilter-devel@lists.netfilter.org>
Sent: Wednesday, June 11, 2003 6:49 PM
Subject: Re: libnfnetlink/libctnetlink ctrace


> Hi Harald, i delayed it because i continued to hack on it, but
> if you want to review i'm going to put everything out as-is
> on trash.net/~kaber/ctnetlink in 1-2 hours.
>
> Best regards,
> Patrick
>
> Harald Welte wrote:
>
> >I feel like this evening I'll finally have time to dig into testing of
> >your latest modifications.
> >
> >
> >
>
>
