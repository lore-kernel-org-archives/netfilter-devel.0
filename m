From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Fri, 05 Mar 2010 18:10:28 +0100
Message-ID: <4B913B04.6020701@netfilter.org>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org> <20100228180505.GD16135@piche.inl.fr> <4B90E7C2.6030208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49498 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab0CERKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:10:42 -0500
In-Reply-To: <4B90E7C2.6030208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pierre Chifflier wrote:
>> On Sun, Feb 28, 2010 at 05:28:38PM +0100, Pablo Neira Ayuso wrote:
>>>>>> +struct ulogd_unixsock_option_t  {
>>>>>> +	uint16_t option_id;
>>>>>> +	uint16_t option_length;
>>>>>> +	char     option_value[0];
>>>>>> +} __attribute__((packed));
>>>>>> +
>>>>>> +#define ALIGN_SIZE 8
>>>>> Minor question: why align this to 64 bits?
>>>> I originally used an alignment to 32 bits, but Jan noticed it would
>>>> break if using options/values on 64 bits (and a test confirmed that). I
>>>> took 64 bits as the biggest allowed value for integers.
>>> I would need to look into this in more detail, not sure where the
>>> problem is. I think that you can use something like `struct nlattr' (see
>>> include/linux/netlink.h) and then nla_put() to add attributes in the TLV
>>> format (see lib/nlattr.c). Those are align-safe. I'm using something
>>> similar for conntrackd for the synchronization messages (src/build.c and
>>> src/parse.c).
>>>
>> Yes, this is very similar though NLA_ALIGNTO is set to 4 which will
>> cause problems with 64 bits integers.
>> The other way to solve this would be to read integers byte per byte,
>> like in [1], but I found this not very elegant (and is likely to be slow
>> compared to aligned access).
>>
>> Or do you have any preferred solution ? Maybe using nlattr + one special
>> function for dealing with 64 bits variables ?
> 
> I'd suggest to add a function that reads the data in 4 byte
> quantities.

Would memcpy() be enough? If so, we can go back to the 4 bytes alignment.
