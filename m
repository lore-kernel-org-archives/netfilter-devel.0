From: "Ferry Huberts" <ferry@Hupie.com>
Subject: Re: PATCH: new match: userindex
Date: Wed, 8 Dec 2004 16:02:51 +0100 (CET)
Message-ID: <21880.217.169.232.210.1102518171.squirrel@hupie.xs4all.nl>
References: <3801.217.169.232.210.1102511374.squirrel@hupie.xs4all.nl><20041208131834.GA20371@oknodo.bof.de><12701.217.169.232.210.1102514649.squirrel@hupie.xs4all.nl>
	<20041208141230.GB20371@oknodo.bof.de>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20041208141230.GB20371@oknodo.bof.de>
To: netfilter-devel@lists.netfilter.org
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


> On Wed, Dec 08, 2004 at 03:04:09PM +0100, Ferry Huberts wrote:
>> >> Kernel module for attaching a user specified index to a rule.
>> >> It matches every packet in order to have no influence on packet
>> >> matching,
>> >> the only effect is to add a user index to a rule
>> >
>> > I think this is already covered - in extended form, i.e. arbitrary
>> string
>> > instead of an integer - by the comment match, found in patch-o-matic.
>>
>> I know, but I needed a leaner module
>
> Did you have performance / memory consumption issues with comment,
> that you won't have with your new module?
>
>> Also, using a number is much simpler, at least for me :-)
>
> There's nothing stopping you from putting a number (ASCII formatted)
> into the comment string. Per match, this will waste roughly NR_CPU*252
> byte.

ok. good point.
however, currently I can have up to 200 rules (with a big question for
more rules in future developments)
This currently means

comment:   252 * 200 = 50400 bytes
userindex:   4 * 200 =   800 bytes
ratio c/u:  63

and yes, main memory is rather limited on the target

I also think that this userindex is a much simpler solution and therefore
more elegant.

I implemented it in order to have functionality I think iptables should
have by default: unique rule numbers that do not change once a rule is
configured (primary keys to spreak in relational database terms).
You can now list rule numbers but they change when rules are inserted or
deleted.

This match allows me to be stateless w.r.t. peer information (which save
memory, rather important for me)

>
> How many annotations do you need? Is your main memory really that
> constrained?
>
> best regards
>   Patrick
>



--
Ferry Huberts
