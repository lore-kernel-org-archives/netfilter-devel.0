From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: Floods
Date: Wed, 17 Mar 2004 05:25:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <874qsoqhno.fsf@aka.i.naked.iki.fi>
References: <200403141930.29602.alchemyx@uznam.net.pl> <877jxmuopm.fsf@aka.i.naked.iki.fi>
 <200403152031.27399.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
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

Micha wrote:
> Dnia pon 15. marca 2004 16:14, Nuutti Kotivuori napisa³:
>> Micha wrote:
>>> What do you recommend? Unfortunately connlimit does not work with
>>> UDP packets (no wonder - UDP is conection less). What should I do? 
>>> I even thought about switch to FreeBSD (sic! :<).
>>
>> See if the 'dstlimit' would help in your case. It is in
>> patch-o-matic.
>
> But it does not support '--mode srcip' and I failed trying to adpot
> patch from before few months that tried to add that option.

The patch-o-matic help is outdated, this is what it supports now:

,----
| --dstlimit-mode <mode>         mode
|                                        dstip
|                                        dstip-dstport
|                                        srcip-dstip
|                                        srcip-dstip-dstport
`----

There is no srcip mode, but srcip-dstip might be enough for you.

-- Naked
