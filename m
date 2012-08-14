From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] mnl_attr_get_str: document that the result is not NUL-terminated
Date: Tue, 14 Aug 2012 13:28:40 +0200
Message-ID: <502A3668.5010404@redhat.com>
References: <502A2624.6050701@redhat.com> <20120814111008.GA25235@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab2HNL2v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:28:51 -0400
In-Reply-To: <20120814111008.GA25235@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/14/2012 01:10 PM, Pablo Neira Ayuso wrote:
> On Tue, Aug 14, 2012 at 12:19:16PM +0200, Florian Weimer wrote:
>> Hi,
>>
>> while reviewing from libmnl-using code, I discovered that the result
>> of mnl_attr_get_str was used as a NUL-terminated string, although in
>> reality the string wasn't.  I think this should be mentioned in the
>> documentation.
>
> Looking at the kernel:
>
> static inline int nla_put_string(struct sk_buff *skb, int attrtype,
>                                   const char *str)
> {
>          return nla_put(skb, attrtype, strlen(str) + 1, str);
> }
>
> It seems it always returns the string plus one byte (that is assumed
> to be NULL).
>
> Are you looking at any netlink subsystem in particular? What are you
> noticing?

Here is what happens: The kernel sends an attribute of type 
NLA_NUL_STRING.  The application checks it with mnl_attr_validate(attr, 
MNL_TYPE_STRING).  The application then proceeds to call 
mnl_attr_get_str(attr) and uses the result as if it were NUL-terminated. 
  So if the Netlink packet actually comes from the kernel, the 
application code is correct in the sense that it works with current 
libmnl. If the packet does not come from the kernel, the application is 
incorrect.

Based on your comments, I think the application should use 
mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) instead.  In this light, 
the documentation for mnl_attr_get_str should probably suggest to 
validate with MNL_TYPE_NUL_STRING before calling mnl_attr_get_str, and 
my original patch is wrong.

-- 
Florian Weimer / Red Hat Product Security Team
