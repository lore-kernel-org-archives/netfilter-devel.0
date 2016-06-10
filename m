From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/2 libnftnl] Fix leak in nftnl_*_unset()
Date: Fri, 10 Jun 2016 13:21:39 +0200
Message-ID: <540743c1-d376-643d-1ba6-402ebb2ee140@riseup.net>
References: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
 <CAOkSjBh1f-psUnErLLbEifZm9_Af62gPeDFS89srVvVp3s9q_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:54633 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbcFJLVo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 07:21:44 -0400
In-Reply-To: <CAOkSjBh1f-psUnErLLbEifZm9_Af62gPeDFS89srVvVp3s9q_Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/10/2016 01:14 PM, Arturo Borrero Gonzalez wrote:
> On 10 June 2016 at 12:20, Carlos Falgueras Garc=C3=ADa <carlosfg@rise=
up.net> wrote:
>> Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
>> ---
>>  src/rule.c     | 1 +
>>  src/set_elem.c | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/src/rule.c b/src/rule.c
>> index 1e1a138..4c22436 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -112,6 +112,7 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint=
16_t attr)
>>         case NFTNL_RULE_POSITION:
>>         case NFTNL_RULE_FAMILY:
>>         case NFTNL_RULE_USERDATA:
>> +               xfree(r->user.data);
>>                 break;
>>         }
>>
>
> I think you need to isolate this NFTNL_RULE_USERDATA case from the
> others by avoiding the fall through.
>
> Example: an user calling nftnl_rule_unset() with NFTNL_RULE_FAMILY
> will free 'r->user.data'. That doesn't seem correct.

thank you! This is an embarrassing mistake >.<
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
