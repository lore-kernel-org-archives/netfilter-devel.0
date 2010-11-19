From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/6] build: tag function headers rather than decls as
 exported
Date: Fri, 19 Nov 2010 12:43:24 +0100
Message-ID: <4CE662DC.401@netfilter.org>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de> <1289907814-32706-5-git-send-email-jengelh@medozas.de> <4CE65AF9.9090904@netfilter.org> <alpine.LNX.2.01.1011191225260.31107@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0KSLn2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:43:28 -0500
In-Reply-To: <alpine.LNX.2.01.1011191225260.31107@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19/11/10 12:26, Jan Engelhardt wrote:
> 
> On Friday 2010-11-19 12:09, Pablo Neira Ayuso wrote:
>>
>> I like this patchset. Some minor glitch:
>>
>> On 16/11/10 12:43, Jan Engelhardt wrote:
>>> @@ -49,31 +43,31 @@ MNL_API int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *b
>>> -MNL_API size_t mnl_nlmsg_size(size_t len);
>>> -MNL_API size_t mnl_nlmsg_total_size(size_t len);
>>> -MNL_API size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
>>> +extern size_t mnl_nlmsg_size(size_t len);
>>> +extern size_t mnl_nlmsg_total_size(size_t len);
>>> +extern size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
>>
>> In patch 1/6 mnl_nlmsg_next looks like:
>>
>> -struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
>> +struct nlattr *mnl_attr_next(const struct nlattr *attr)
>>
>> but here the old API seems to come back:
>>
>> extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int
>> *len);
> 
> I only changed the attr iteration interface so far, but not yet
> that of nlmsg iteration.

Oh, I didn't notice that this refers to nlmsg, not to attr. I'll apply
the remaining patches then. Thanks.
