From: James Chapman <jchapman@katalix.com>
Subject: Re: [PATCH v4] netfilter: introduce l2tp match extension
Date: Fri, 03 Jan 2014 10:04:46 +0000
Message-ID: <52C68B3E.30402@katalix.com>
References: <1386857622-17389-1-git-send-email-jchapman@katalix.com> <20140102205713.GA3758@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from katalix.com ([82.103.140.233]:46396 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaACKEv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 05:04:51 -0500
In-Reply-To: <20140102205713.GA3758@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/01/14 20:57, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Thu, Dec 12, 2013 at 02:13:42PM +0000, James Chapman wrote:

> I'm testing this with the last userspace iptables patch that you
> posted [1]. I'm using the example in the manpage:
> 
> # iptables -A INPUT -s 1.2.3.4 -m l2tp --tid 42
> iptables: Invalid argument. Run `dmesg' for more information.
> # dmesg
> ...
> [  490.827569] xt_l2tp: missing encapsulation

By bad. I made the encap type a required param to the kernel as a result
of previous comments and updated the iptables patch to enforce this, but
I didn't submit the updated iptables patch.

> Note that changing the info data area from the kernel side is
> problematic in iptables, eg.
> 
> # iptables -A INPUT -s 1.2.3.4/32 -m l2tp --tid 42 --pversion 2
> # iptables -D INPUT -s 1.2.3.4/32 -m l2tp --tid 42 --pversion 2
> iptables: Bad rule (does a matching rule exist in that chain?).
>
> Userspace needs to get exactly what it passes, no changes are allowed.
> I think you need explicit option passing to indicate the behaviour you
> want.
> 
>> +		}
>> +	}
>> +
>> +	/* Encap must be specified */
>> +	if (!(info->flags & XT_L2TP_ENCAP))
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
> 
> Please, review this logic in the _check() function and send me a v5,
> including a refreshed iptables version.

On reflection, having the kernel derive an encap_type if the version is
set 2 is unnecessary - it is better to have the iptables command parser
do this and just have the kernel reject the request if encap_type is not
specified, rather than trying to fake it as being set to udp itself when
version is 2.

> 
> It would be great if you can include a list of iptables commands using
> your l2tp match that you have used to validate this in the next round.
> Thanks.

Will do. Thanks.

> [1] http://patchwork.ozlabs.org/patch/288411/
> 

