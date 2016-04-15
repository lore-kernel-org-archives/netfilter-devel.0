From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH 1/2] NFQUEUE: Fix bug with order of fanout and bypass
Date: Fri, 15 Apr 2016 16:15:07 +0530
Message-ID: <CAKHNQQHU--Jt+8mrZcrhfBD3eJTvsX47VoOkJB2Jp_YBd0bp1w@mail.gmail.com>
References: <20160414152557.GA5338@shivani> <20160415104405.GA10807@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36298 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbcDOKpw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:45:52 -0400
Received: by mail-oi0-f67.google.com with SMTP id v126so13257557oia.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 03:45:51 -0700 (PDT)
In-Reply-To: <20160415104405.GA10807@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 15, 2016 at 4:14 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 14, 2016 at 08:55:58PM +0530, Shivani Bhardwaj wrote:
>> NFQUEUE had a bug with the ordering of fanout and bypass options which
>> was arising due to same and odd values for flags and bypass when used
>> together. Because of this, during bitwise ANDing of flags and
>> NFQ_FLAG_CPU_FANOUT, the value always evaluated to false (since
>> NFQ_FLAG_CPU_FANOUT=0x02) and led to skipping of fanout option
>> whenever it was used before bypass because then flags would be 1.
>>
>> Before this patch,
>>
>> $ sudo iptables -A FORWARD -j NFQUEUE -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout --queue-bypass
>>
>> Chain FORWARD (policy ACCEPT)
>> target     prot opt source               destination
>> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass
>>
>> After this patch,
>>
>> Chain FORWARD (policy ACCEPT)
>> target     prot opt source               destination
>> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass cpu-fanout
>>
>> Closes bugzilla entry: http://bugzilla.netfilter.org/show_bug.cgi?id=939
>
> Shivani, thanks for following up on this.
>
> Would you also update extensions/libxt_NFQUEUE.t to add a test so we
> make sure this regression doesn't happen ever again?
>
I just did that! :) Testing and sending out the patch.
Thanks.

> Thanks.
