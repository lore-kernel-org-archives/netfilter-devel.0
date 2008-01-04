From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 12/27] xt_hashlimit match, revision 1
Date: Fri, 4 Jan 2008 16:07:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041606060.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128370.14900@fbirervta.pbzchgretzou.qr>
 <477E49DA.40207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39439 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYADPHg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:07:36 -0500
In-Reply-To: <477E49DA.40207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 15:59, Patrick McHardy wrote:
>> -#define XT_HASHLIMIT_HASH_DIP	0x0001
>> -#define XT_HASHLIMIT_HASH_DPT	0x0002
>> -#define XT_HASHLIMIT_HASH_SIP	0x0004
>> -#define XT_HASHLIMIT_HASH_SPT	0x0008
>> +enum {
>> +	XT_HASHLIMIT_HASH_DIP = 1 << 0,
>> +	XT_HASHLIMIT_HASH_DPT = 1 << 1,
>> +	XT_HASHLIMIT_HASH_SIP = 1 << 2,
>> +	XT_HASHLIMIT_HASH_SPT = 1 << 3,
>> +	XT_HASHLIMIT_INVERT   = 1 << 4,
>> +};
>
>
> Do we really need a full new revision for this? It seems simply adding
> the inversion flag would work fine, old userspace code will always
> have it set to zero.
>
Yes we need a new revision, inversion is not the only thing.

The extra fields "uint8_t srcmask, dstmask" have been added to
struct hashlimit_cfg1, which is embedded in xt_hashlimit_mtinfo1.
So we have an actual struct size change to take care of.
(Yes, before I had the srcmask/dstmask idea, I did inversion-only
using revision 0.)
