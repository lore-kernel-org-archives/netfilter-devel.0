From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 02/32]: nf_conntrack: fix NF_CT_TUPLE_DUMP for IPv4
Date: Tue, 25 Mar 2008 16:31:05 +0100
Message-ID: <47E91AB9.7060507@trash.net>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain> <20080325141453.10539.53690.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0803251626000.9368@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:44410 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755507AbYCYPbM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:31:12 -0400
Received: from edge02.upc.biz ([192.168.13.237]) by viefep16-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080325153109.CIZW8097.viefep16-int.chello.at@edge02.upc.biz>
          for <netfilter-devel@vger.kernel.org>;
          Tue, 25 Mar 2008 16:31:09 +0100
In-Reply-To: <alpine.LNX.1.10.0803251626000.9368@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Tuesday 2008-03-25 15:14, Patrick McHardy wrote:
>> +
>> +static inline void nf_ct_dump_tuple(const struct nf_conntrack_tuple *t)
>> +{
>> +    switch (t->src.l3num) {
>> +    case AF_INET:
>> +        nf_ct_dump_tuple_ip(t);
>> +        break;
>> +    case AF_INET6:
>> +        nf_ct_dump_tuple_ipv6(t);
>> +        break;
>> +    }
>> +}
>> +
>> +#define NF_CT_DUMP_TUPLE(tp)    nf_ct_dump_tuple(tp)
> 
> I think it would be wiser just to remove this macro and
> convert all kernel users to lowercase -- there are only
> kernel users I guess, since include/net/ is not exported
> to userspace AFAICS.
> 

Sure, please go ahead :)
