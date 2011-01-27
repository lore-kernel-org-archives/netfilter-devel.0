From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/13] bitmap:ip set type support
Date: Thu, 27 Jan 2011 10:08:28 +0100
Message-ID: <4D41360C.30403@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu> <4D3EE6B6.8090008@trash.net> <alpine.DEB.2.00.1101252229250.19648@blackhole.kfki.hu> <alpine.DEB.2.00.1101270959100.24591@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61497 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1A0JIh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:08:37 -0500
In-Reply-To: <alpine.DEB.2.00.1101270959100.24591@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.01.2011 10:06, Jozsef Kadlecsik wrote:
> On Tue, 25 Jan 2011, Jozsef Kadlecsik wrote:
> 
>>>> +			} else
>>>> +				goto nla_put_failure;
>>>> +		}
>>>> +		NLA_PUT_IPADDR4(skb, IPSET_ATTR_IP,
>>>> +				htonl(map->first_ip + id * map->hosts));
>>>> +		ipset_nest_end(skb, nested);
>>>> +	}
>>>> +	ipset_nest_end(skb, atd);
>>>> +	/* Set listing finished */
>>>> +	cb->args[2] = 0;
>>>> +	return 0;
>>>> +
>>>> +nla_put_failure:
>>>> +	nla_nest_cancel(skb, nested);
>>>> +	ipset_nest_end(skb, atd);
>>>> +	return 0;
>>>
>>> Doesn't this need to return an errno value to indicate that the
>>> dump is incomplete?
> 
> The success return code was there because in general we reach there when 
> the message gets full. However it does not mean an incomplete dump: the 
> last partially dumped element is cancelled, the outer nesting is finished 
> and we send the success code.
> 
> The nla_put_failure label name can be misleading but I cannot do much 
> about it: NLA_PUT_* relies on it.

Sure, my question was mainly related to whether the ip_set_core needs
to get an indication that the dump was incomplete and needs to be
continued on the next recvmsg() call. But I see now that cb->args[2]
is used to provide this indication, so everything should be fine.
