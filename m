From: =?UTF-8?Q?Roberto_Garc=c3=ada?= <rodanber@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_ecn: Add translation to nft
Date: Wed, 29 Jun 2016 10:50:54 +0200
Message-ID: <001bc6b7-7d4f-5cea-5761-00143d4accdd@gmail.com>
References: <1467143937-19755-1-git-send-email-rodanber@gmail.com>
 <CAOkSjBg9y-NoqyHV38-SeG_LUjg2UbjozJ=-PXDWgcMDSDT45Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35764 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbcF2IvO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2016 04:51:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id a66so12521150wme.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2016 01:51:14 -0700 (PDT)
In-Reply-To: <CAOkSjBg9y-NoqyHV38-SeG_LUjg2UbjozJ=-PXDWgcMDSDT45Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok, gonna fix that ASAP.

On 29/06/16 10:29, Arturo Borrero Gonzalez wrote:
> On 28 June 2016 at 21:58,  <rodanber@gmail.com> wrote:
>> diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
>> index 286782a..8e0c35b 100644
>> --- a/extensions/libxt_ecn.c
>> +++ b/extensions/libxt_ecn.c
>> @@ -118,6 +118,50 @@ static void ecn_save(const void *ip, const struct xt_entry_match *match)
>>         }
>>  }
>>
>> +static int ecn_xlate(const void *ip, const struct xt_entry_match *match,
>> +                    struct xt_xlate *xl, int numeric)
>> +{
>> +       const struct xt_ecn_info *einfo =
>> +               (const struct xt_ecn_info *)match->data;
>> +
>> +       if (einfo->operation & XT_ECN_OP_MATCH_IP) {
>
> You could also do an early return here, given the case of this if ()
> failing we have nothing to translate.
>
