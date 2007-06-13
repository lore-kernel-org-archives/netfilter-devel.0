From: "Samuel Jean" <jix@bugmachine.ca>
Subject: Re: Follow packets in rules
Date: Wed, 13 Jun 2007 16:28:59 -0000
Message-ID: <twig.1181752139.4605@bugmachine.ca>
References: <466FB176.7040306@netfilter.org>
Reply-To: jix@bugmachine.ca
To: "Juan León" <debjuanca@gmail.com>,
        "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>,
        <netfilter-devel@lists.netfilter.org>, <pablo@netfilter.org>,
        <kaber@trash.net>, <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <6bb85d880706130843n31d8c1a6i19a4b119c85131a1@mail.gmail.com>
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

On Wed, Jun 13, 2007, Juan León <debjuanca@gmail.com> said:

> Hi Fabrice,
> 
> 
> 2007/6/13, Pablo Neira Ayuso <pablo@netfilter.org>:
>> Fabrice Rafart wrote:
>> > I look for a tool to follow a packets into rules of netfilter.
>> >
>> > For example :
>> >
>> > # iptables-test -s 192.168.1.1 -d 192.168.2.1 -p tcp --dport 25
>> > --> FORWARD line 1  : -p tcp --dport 25 -j SMTP
>> > --> SMTP line 3     : -s 192.168.1.0/24 -j DROP
>> >
>> > This show me which rules matches the packet until the end.
>> >
>> > Does this exist ?

There was the TRACE target born for this purpose a couple years ago.

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branches/patch-o-matic-ng/linux-2.6.11/TRACE/?rev=3680

It sure will require a bit of hacking for recent kernels.

Pablo, Patrick --

Is this an interesting feature that worths merging in mainline, or
patch-o-matic at least ?

Best regards,
Samuel 
