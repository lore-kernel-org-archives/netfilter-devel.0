From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 28 Feb 2010 18:29:51 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002281825360.4060@obet.zrqbmnf.qr>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54760 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030514Ab0B1R3x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 12:29:53 -0500
In-Reply-To: <4B8A99B6.5080708@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-02-28 17:28, Pablo Neira Ayuso wrote:
>>>> +
>>>> +struct ulogd_unixsock_option_t  {
>>>> +	uint16_t option_id;
>>>> +	uint16_t option_length;
>>>> +	char     option_value[0];
>>>> +} __attribute__((packed));
>>>> +
>>>> +#define ALIGN_SIZE 8
>>> Minor question: why align this to 64 bits?
>> 
>> I originally used an alignment to 32 bits, but Jan noticed it would
>> break if using options/values on 64 bits (and a test confirmed that). I
>> took 64 bits as the biggest allowed value for integers.
>
>I would need to look into this in more detail, not sure where the
>problem is.

The problem is that *(uint64_t *)x as used in unixsock.c
would otherwise cause an unaligned access. Copying from
an odd address is thus more costly.

