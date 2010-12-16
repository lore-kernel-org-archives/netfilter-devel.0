From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 16 Dec 2010 15:22:07 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012161514360.20048@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org> <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr> <4D08C892.3080704@netfilter.org>
 <20101216140537.GA23297@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20101216140537.GA23297@canuck.infradead.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 2010-12-16 15:05, Thomas Graf wrote:

>On Wed, Dec 15, 2010 at 02:54:26PM +0100, Pablo Neira Ayuso wrote:
>> > BTW, can response messages - all those leading up to NLMSG_DONE -
>> > have different nlmsg_type, or not?
>> 
>> They all have the same type.
>
>This is not a MUST. It is perfectly legal to f.e.:
>
> -> FOO_GET (seq=1, NLM_F_REQUEST)
> <- FOO_DEL (seq=1, NLM_F_MULTI)
> <- FOO_ADD (seq=1, NLM_F_MULTI)
> <- NLMSG_DONE (seq=1)

Oh great, now the confusion is complete. One person says this, another 
says something else. Best of all, the Netlink RFC leaves it unspecified, 
so it's all hearsay, beliefs and Perl5-style ("Source acts as normative 
reference") referencing. I guess we are doomed until the original 
Netlink3549 authors step up and tell us their intentions.

As I see it, we need a discussion to specify what is to be done with 
unspecified parts, with 3549 as an origin.
