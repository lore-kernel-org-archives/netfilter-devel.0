From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/5] attr: avoid multiple definition of hidden variable
Date: Thu, 11 Nov 2010 14:25:54 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011111424370.22995@obet.zrqbmnf.qr>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-6-git-send-email-jengelh@medozas.de> <4CDBEAD6.9030505@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54320 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0KKNZz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:25:55 -0500
In-Reply-To: <4CDBEAD6.9030505@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-11-11 14:08, Pablo Neira Ayuso wrote:
>On 11/11/10 00:08, Jan Engelhardt wrote:
>> When nesting two mnl_attr_for_each loops, the __len__ variable will be
>> declared twice, eliciting a warning when -Wshadow is turned on. There
>> can also be warnings in pre-C99 because declarations and code are
>> mixed. Do without any temporaries that are not explicitly specified as
>> macro parameters.
>
>I like this spot, some question below:
>
>> -struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
>> +struct nlattr *mnl_attr_next(const struct nlattr *attr)
>>  {
>> -	*len -= MNL_ALIGN(attr->nla_len);
>>  	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
>>  }
>
>If we remove the len parameter from mnl_attr_next(), we may access
>memory that may be out of the message boundary in mnl_attr_ok().

Not that I can see; mnl_attr_ok tests for len >= sizeof(struct nlattr),
and len is tail minus attr.
