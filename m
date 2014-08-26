From: Alexey Perevalov <alexey.perevalov@hotmail.com>
Subject: Re: [[PATCH v3]] netfilter: nfnetlink_acct: add filter support to
 nfacct counter list/reset
Date: Tue, 26 Aug 2014 23:24:51 +0400
Message-ID: <BLU436-SMTP2576F24E6F9020C5D0851AA8DDC0@phx.gbl>
References: <20140820133401.GA7422@salvia> <1408557798-6455-1-git-send-email-a.perevalov@samsung.com> <20140824131537.GA8144@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mathieu.poirier@linaro.org, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu004-omc1s24.hotmail.com ([65.55.116.35]:55003 "EHLO
	BLU004-OMC1S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbaHZT1R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:27:17 -0400
In-Reply-To: <20140824131537.GA8144@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On 08/24/2014 05:15 PM, Pablo Neira Ayuso wrote:
> Hi,
>
> On Wed, Aug 20, 2014 at 10:03:18PM +0400, Alexey Perevalov wrote:
>> +static struct nfacct_filter *
>> +nfacct_filter_alloc(struct nlattr *attrs[NFACCT_FILTER_MAX + 1])
>> +{
>> +	struct nfacct_filter *filter = kzalloc(sizeof(struct nfacct_filter),
>> +					       GFP_KERNEL);
>> +	if (!filter)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	filter->mask = nla_get_be32(attrs[NFACCT_FILTER_MASK]);
>> +	filter->value = nla_get_be32(attrs[NFACCT_FILTER_VALUE]);
> We have to use ntohl() here, it's the convention for nfnetlink.
>
> I'm attaching a patch that resolves this plus some cleanups.
>
> Please, let me know if you're OK with it. Thanks.
Yes, I'm ok with it.

sorry for double braces )
and thanks  for correction.

BR,
Alexey
