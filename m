From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: nft compat layer
Date: Wed, 20 Jan 2016 15:47:40 +0100
Message-ID: <569F9E0C.20609@tpip.net>
References: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
 <569CA968.9010702@tpip.net> <20160119190456.GA24910@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:60231 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933933AbcATOrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 09:47:46 -0500
In-Reply-To: <20160119190456.GA24910@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 01/19/2016 08:04 PM, Pablo Neira Ayuso wrote:
> Hi Andreas,
>
> On Mon, Jan 18, 2016 at 09:59:20AM +0100, Andreas Schultz wrote:
>> Hi Arturo,
>>
>> On 01/15/2016 09:06 PM, Arturo Borrero Gonzalez wrote:
>>> Hi,
>>>
>>> I'm giving a spin to the nft compat layer, since it can be of certain
>>> importance for distributions.
>>>
>>> I just want to be clear on what I recommends to end users about
>>> migrating from iptables (and friends) to nftables.
>>>
>>> Could you please remind me in which state was the discussion about
>>> that patch to show x_tables extensions in nftables rulesets [0]?
>>> I remember Patrick mentioned several concerns back then about this approach.
>>
>> I have an updated version of this patch and also fixed some of
>> the problems I encountered along the way (see attached patches).
>> The nft patch is based on nftables-0.5 and the kernel change
>> should apply cleanly to linux-4.4.
>
> Thanks for posting your patches.
>
>> With the update patch I can load a fairly complex iptables
>> firewall with iptables-compat, dump it with nft and reload
>> the dump with nft.
>
> BTW, looking at the kernel patches, my first question is why you
> disable the chain/table validation code? Do you remember what problem
> you found in it?

The compat layer works fine when invoked through iptables-compat.
But I wanted to use the XT extensions from NFT.

For example, when load a firewall through iptables-compat and dumping it
with patch nft tool, I would get a rule like this:

     ip protocol tcp counter packets 0 bytes 0 xt "REJECT" [ " --reject-with tcp-reset" ]

With validation enable this rule can not be loaded through NFT.

Lets ignore the fact the rewriting this rule to native nft would make
much more sense. The goal was to load iptables through the compat
layer, dump the nft rules and reload them unmodified.

For the above rule, the REJECT code check that a TCP protocol check
was done before. The iptables-compat would arrange the internal
structure so that this check can be found.

When loading through nft, those compatibility structures are not
there and the check in the REJECT code fails.

Since this was mostly an experiment, I took the easy way out and disabled
all checks.

Andreas


>
>> diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
>> index 87907d4..2f8f76c 100644
>> --- a/net/ipv4/netfilter/ipt_REJECT.c
>> +++ b/net/ipv4/netfilter/ipt_REJECT.c
>> @@ -76,6 +76,8 @@ static int reject_tg_check(const struct xt_tgchk_param *par)
>>   	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
>>   		pr_info("ECHOREPLY no longer supported.\n");
>>   		return -EINVAL;
>> +	} else if (par->nft_compat) {
>> +		return 0;
>
> The ipt_entry is emulated from the compat layer, do you remember what
> command needs this?
>
> Same thing in SYNPROXY and the one for the x_tables code.
>
> If you can provide a way to reproduce the problem, I would like to
> resolve the issues in master, if any.
>
> Thanks.
>
