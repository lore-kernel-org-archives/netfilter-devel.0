From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] attr: avoid multiple definition of hidden variable
Date: Thu, 11 Nov 2010 18:47:40 +0100
Message-ID: <4CDC2C3C.5060708@netfilter.org>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-6-git-send-email-jengelh@medozas.de> <4CDBEAD6.9030505@netfilter.org> <alpine.LNX.2.01.1011111424370.22995@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58796 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0KKRrs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:47:48 -0500
In-Reply-To: <alpine.LNX.2.01.1011111424370.22995@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/11/10 14:25, Jan Engelhardt wrote:
> 
> On Thursday 2010-11-11 14:08, Pablo Neira Ayuso wrote:
>> On 11/11/10 00:08, Jan Engelhardt wrote:
>>> When nesting two mnl_attr_for_each loops, the __len__ variable will be
>>> declared twice, eliciting a warning when -Wshadow is turned on. There
>>> can also be warnings in pre-C99 because declarations and code are
>>> mixed. Do without any temporaries that are not explicitly specified as
>>> macro parameters.
>>
>> I like this spot, some question below:
>>
>>> -struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
>>> +struct nlattr *mnl_attr_next(const struct nlattr *attr)
>>>  {
>>> -	*len -= MNL_ALIGN(attr->nla_len);
>>>  	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
>>>  }
>>
>> If we remove the len parameter from mnl_attr_next(), we may access
>> memory that may be out of the message boundary in mnl_attr_ok().
> 
> Not that I can see; mnl_attr_ok tests for len >= sizeof(struct nlattr),
> and len is tail minus attr.

mnl_attr_for_each() in your patch is OK, sorry. But, here:

+#define mnl_attr_for_each_nested(attr, nest) \
+	for ((attr) = mnl_attr_get_payload(nest); \
+	     mnl_attr_ok((attr), mnl_attr_get_payload(attr) +
mnl_attr_get_payload_len(attr) - (void *)(attr)); \
+	     (attr) = mnl_attr_next(attr))

Once we iterate over the last attribute in the nest, we iterate again to
check if there's any next. Then, mnl_attr_get_payload may access
attr->len for an attribute that doesn't belong the nest or (if the nest
is in the end of the message) an out of bound message access.

I think that we can add mnl_attr_get_payload_tail to make tail minus
attr, like in mnl_attr_for_each().
