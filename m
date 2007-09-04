From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Tue, 04 Sep 2007 12:12:15 +1000
Message-ID: <46DCBEFF.5070509@snapgear.com>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<20070903100943.GH18480@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070903100943.GH18480@postel.suug.ch>
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

Thomas Graf wrote:
> * Philip Craig <philipc@snapgear.com> 2007-09-03 15:11
>> Index: libnl/lib/attr.c
>> ===================================================================
>> --- libnl.orig/lib/attr.c	2007-09-03 14:24:29.000000000 +1000
>> +++ libnl/lib/attr.c	2007-09-03 14:24:45.000000000 +1000
>> @@ -261,7 +261,8 @@ int nla_parse(struct nlattr *tb[], int m
>>  	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
>>  
>>  	nla_for_each_attr(nla, head, len, rem) {
>> -		uint16_t type = nla->nla_type;
>> +		/* Ignore NFNL_NFA_NEST bit, hope nothing else uses it */
>> +		uint16_t type = nla->nla_type & 0x7fff;
> 
> I wonder if it is useful to make this behaviour conditional so that
> the netfilter subsystem could enable this for backwards compatibility
> while other subsystems won't be affected.
> 
> It will offend a few people but it's still pre 1.0 and we can break
> the API. I'd rather get this right now than having to life with
> side effects for a long time.

Yes it would be nice to only do it for subsystems that need it.
The only place I can see in the existing arguments for nla_parse()
is to overload the meaning of the unused policy[0]. The other options
are to change nla_parse() or add nla_parse_masked(). Any preference?
