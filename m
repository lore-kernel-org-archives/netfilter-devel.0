From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/3] nfnetlink: Check callbacks before using those in
 nfnetlink_rcv_msg
Date: Fri, 29 Jun 2012 21:03:40 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206292100210.20094@frira.zrqbmnf.qr>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1340888269-4926-2-git-send-email-tomasz.bursztyka@linux.intel.com> <20120629111505.GC15598@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static.206.24.9.5.clients.your-server.de ([5.9.24.206]:53249
	"EHLO seven.medozas.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2F2TNA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:13:00 -0400
In-Reply-To: <20120629111505.GC15598@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2012-06-29 13:15, Pablo Neira Ayuso wrote:
>On Thu, Jun 28, 2012 at 03:57:47PM +0300, Tomasz Bursztyka wrote:
>> nfnetlink_rcv_msg() might call a NULL callback which will cause NULL pointer
>> dereference.
>> 
>> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
>> ---
>> @@ -184,9 +184,11 @@ replay:
>>  					lockdep_is_held(&nfnl_mutex)) != ss ||
>>  			    nfnetlink_find_client(type, ss) != nc)
>>  				err = -EAGAIN;
>> -			else
>> +			else if (nc->call)
>>  				err = nc->call(net->nfnl, skb, nlh,
>>  						   (const struct nlattr **)cda);
>> +			else
>> +				err = -EINVAL;
>
>Hm, I think this is redundant. We got the ipset problem fixed with
>2/3. I think we can add some BUG_ON instead as all nc->call needs to
>be defined. Otherwise, spot a bug message so it is fixed.

Seriously, we have run into NULL dereferences at this place so often
that it should not be discarded as a PEBKAC issue. Yes, it is the
programmer's responsibility to fill in .call, but error handling is
anytime better than driving one's machine into the pit stop due to a
NULL deref or BUG_ON.
