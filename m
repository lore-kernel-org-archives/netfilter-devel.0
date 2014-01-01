From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH nf] netfilter: nf_nat: fix buffer overflow in IRC NAT
 helper
Date: Wed, 01 Jan 2014 05:13:08 +0100
Message-ID: <52C395D4.5020501@redhat.com>
References: <1388503719-17766-1-git-send-email-dborkman@redhat.com> <20131231172952.GA3857@localhost> <20131231173545.GA4004@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Harald Welte <laforge@gnumonks.org>,
	Noel Butler <noel.butler@ausics.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaAAENd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:13:33 -0500
In-Reply-To: <20131231173545.GA4004@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/31/2013 06:35 PM, Pablo Neira Ayuso wrote:
> On Tue, Dec 31, 2013 at 06:29:52PM +0100, Pablo Neira Ayuso wrote:
>> On Tue, Dec 31, 2013 at 04:28:39PM +0100, Daniel Borkmann wrote:
>>> Commit 5901b6be885e attempted to introduce IPv6 support into
>>> IRC NAT helper. By doing so, the following code seemed to be removed
>>> by accident:
>>>
>>>    ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
>>>    sprintf(buffer, "%u %u", ip, port);
>>>    pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n", buffer, &ip, port);
>>>
>>> This leads to the fact that buffer[] was left uninitialized and
>>> contained some stack value. When we call nf_nat_mangle_tcp_packet(),
>>> we call strlen(buffer) on excatly this uninitialized buffer. If we
>>> are unlucky and the skb has enough tailroom, we overwrite resp. leak
>>> contents with values that sit on our stack into the packet and send
>>> that out to the receiver.
>>>
>>> Since the rather informal DCC spec [1] does not seem to specify
>>> IPv6 support right now, we log such occurences so that admins can
>>> act accordingly, and drop the packet. I've looked into XChat source,
>>> and IPv6 is not supported there: addresses are in u32 and print
>>> via %u format string.
>>>
>>> Therefore, restore old behaviour as in IPv4, use snprintf(), and
>>> log IPv6 packets for now (maybe if there's consensus one day, we
>>> can still add support here). By this, we can safely use strlen(buffer)
>>> in nf_nat_mangle_tcp_packet() and prevent a buffer overflow. Also
>>> simplify some code as we now have ct variable anyway.
>>>
>>>    [1] http://www.irchelp.org/irchelp/rfc/ctcpspec.html
>>
>> Thanks Daniel.
>>
>> No need for red blinking light on...
>
> Oh well, this also affects IPv4. Will pass this to master. Thanks.

Indeed, it affects IPv4 as the current code seems to be not working.
I think for now fixing this should be fine and later on there can be
follow-ups for full support for IPv6; probably that's a completely
different topic / discussion.

Thanks and happy new year,

Daniel
