From: "Peter Olsson" <aa@tbh.se>
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in __unexpect_related
Date: Wed, 16 Jun 2004 17:57:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002201c453ba$af6ec070$7c01a8c0@std.visionutv.se>
References: <Pine.LNX.4.44.0406160001480.15456-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developers List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, I know. But I just don't have the time for the moment...

I've applied the orphaned_expect patch now, hopefully it will help! :)

Thanks for all help,

Peter Olsson

----- Original Message ----- 
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Peter Olsson" <aa@tbh.se>
Cc: "Netfilter Developers List" <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, June 16, 2004 12:07 AM
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in
__unexpect_related


> On Tue, 15 Jun 2004, Peter Olsson wrote:
>
> > I looked through all applied patches from pom, and it's the list below.
>
> You really ought to be using pom-ng these days..
>
> Maybe updates/05_linux-2.4.26-orphaned_expect.patch is relevant to your
> problem?
>
> Regards
> Henrik
>
>
