From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Mon, 16 Feb 2004 04:22:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87ptcfahm4.fsf@iki.fi>
References: <87bro9fiqq.fsf@iki.fi> <20040214201444.GS7756@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Sun, Feb 08, 2004 at 09:56:13PM +0200, Nuutti Kotivuori wrote:

[...]

> since it is 2.6.x, please put it in patch-o-matic-ng.

Okay.

> all the wholefiles go in as files themselves.
> i.e. patch-o-matic-ng/connrate/linux/include/linux/netfilter_ipv4/ip_conntrack_rate.h
>
> The rest is a bit more tricky, and I have to admit that there is no
> way but to look at the dozens of examples in order to figure it out.

Right. I think I can manage. So I guess the next version of the patch
that I send should be a diff against the patch-o-matic-ng directory.

> As long as you only add a libipt_connrate.c file (together with a
> .libipt_connrate-test), this will usually be applied without any
> problems.

Yup.

>> +	/* jiffies of previous received packet */
>> +	unsigned long prev;
>> +	/* average rate of tokens per jiffy */
>> +	u_int32_t avgrate;
>
> be careful.  I didn't review your algorithms, but on 64bit
> architectures, unsigned long tend to be 64bit and you forced
> 'avgrate' to be 32 bits.

This is intentional. 'prev' is used to store a jiffies value, as by
the comment - which is an unsigned long on all platforms I
believe. 'avgrate' is again something calculated internally in the
algorithm, and it should be 32 bits to keep the assumptions I make
valid.

However, I haven't tested the code on 64bit architectures, so there
may be some other mistakes in there - and also, I am not sure what to
do about jiffies wrapping, I need to revisit that.


[...]

> instead of adding it here, please include a .connrate-test file

Actually I did - but at some testing phase and due to the contorted
way debian builds the iptables package, I couldn't get it to
automatically detect connrate - so I went the easy way on the first
time. I also wasn't sure if just adding the -test file would be
enough, but I guess it is.

Thank you for the review - I'll get a second version of the patch with
the changes done when I find the time.

-- Naked
