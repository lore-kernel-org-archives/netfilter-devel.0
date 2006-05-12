From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Fri, 12 May 2006 13:51:21 +0200
Message-ID: <446476B9.7060505@netfilter.org>
References: <4451BA40.4050207@trash.net> <445388B9.2010308@netfilter.org>
	<4457677D.7060607@trash.net> <44578E0C.5070705@netfilter.org>
	<4457926D.5010209@trash.net> <4457EBF9.3080606@netfilter.org>
	<44641FFC.8030500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44641FFC.8030500@trash.net>
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

Hi,

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>>Patrick McHardy wrote:
>>
>>>Pablo Neira Ayuso wrote:
>>>
>>>>>I don't know. I would prefer to just remove it. Since the library
>>>>>takes all parameters as arguments to a single function (one more
>>>>>thing I definitely don't like), compatibility of the library will
>>>>>break anyway when we add support for multiple manips. Do you really
>>>>>think its worth keeping around?
>>>>
>>>>Not really, if it's trash better remove this sooner than later. Now that
>>>>we are going to break backward compatibility, please let me know if you
>>>>don't like anything else that we could change at this point.
>>>
>>>One thing that would make a lot of sense is to change or introduce a new
>>>interface in libnetfilter_conntrack that allows to add netfilter
>>>attributes to a conntrack "object" one at a time, so we don't have to
>>>change function prototypes each time we're introducing something new.
>>
>>
>>what do you think about the incomplete patch attached? Still missing the
>>getters and the expectations.
>>
>>I think that with the setters/getters we can make private nfct_conntrack
>>and friends.
> 
> 
> I talked to Harald about this and we decided how to proceed. Harald
> made some changes to libnfnetlink which break libnetfilter_conntrack
> and others, so he wants to fix them and do a new release of all the
> libraries first.

BTW: @Harald, do you plan to include part of this patch in the changes?
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3315

> After that your patch should go in, but we decided
> not to change the existing create_conntrack prototype, but add a few
> new functions instead for allocating and sending the conntrack message.
> This way old code will at least compile, and everything besides
> setting up NAT mappings will keep working.

OK, I'll finish the patch then. I'm thinking about hiding the definition
of nfct_conntrack/nfct_tuple/... and provide the getters to access the
attributes of the object. Since this structure could evolve in time, we
wouldn't have any problems to introduce new changes in future. But that
would definitely break code that initialize the structure by setting up
the structure fields. Ideas?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
