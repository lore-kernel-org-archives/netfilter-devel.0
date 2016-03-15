From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/4 v4] libnftnl: Implement new buffer of TLV objects
Date: Tue, 15 Mar 2016 21:29:13 +0100
Message-ID: <56E87099.2070003@riseup.net>
References: <1457645836-10996-1-git-send-email-carlosfg@riseup.net>
 <20160312110947.GA1764@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:53808 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934941AbcCOU3R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 16:29:17 -0400
In-Reply-To: <20160312110947.GA1764@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you Pablo for the feedback. I will send now the version 5 with all 
changes you have asked me.

On 12/03/16 12:09, Pablo Neira Ayuso wrote:
>> diff --git a/src/libnftnl.map b/src/libnftnl.map
>> index 2e193b7..d6cd2a7 100644
>> --- a/src/libnftnl.map
>> +++ b/src/libnftnl.map
>> @@ -336,6 +336,22 @@ global:
>>     nftnl_set_snprintf;
>>     nftnl_set_fprintf;
>>
>> +  nftnl_udata_alloc;
>> +  nftnl_udata_free;
>> +  nftnl_udata_len;
>> +  nftnl_udata_size;
>> +  nftnl_udata_data;
>> +  nftnl_udata_copy_data;
>> +  nftnl_udata_start;
>> +  nftnl_udata_end;
>> +  nftnl_udata_put;
>> +  nftnl_udata_put_strz;
>> +  nftnl_udata_attr_type;
>> +  nftnl_udata_attr_len;
>> +  nftnl_udata_attr_value;
>> +  nftnl_udata_attr_next;
>> +  nftnl_udata_parse;
>
> Please, add these new symbols to LIBNFTNL_4.1.
Done

>> diff --git a/src/udata.c b/src/udata.c
>> new file mode 100644
>> index 0000000..0503ca3
>> --- /dev/null
>> +++ b/src/udata.c
>> @@ -0,0 +1,134 @@
>> +#include <libnftnl/udata.h>
>> +#include <udata.h>
>> +#include <utils.h>
>> +
>> +#include <stdlib.h>
>> +#include <stdint.h>
>> +#include <string.h>
>> +
>> +struct nftnl_udata_buf *nftnl_udata_alloc(size_t data_size)
>> +{
>> +	struct nftnl_udata_buf *buf;
>> +
>> +	buf = (struct nftnl_udata_buf *)
>> +		malloc(sizeof(struct nftnl_udata_buf) + data_size);
>
> No need for casting, ie.
>
> 	buf = malloc(sizeof(struct nftnl_udata_buf) + data_size);
>
>> +	if (!buf)
>> +		return NULL;
>> +	buf->size = data_size;
>> +	buf->end = buf->data;
>> +
>> +	return buf;
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_alloc);
>> +
>> +void nftnl_udata_free(struct nftnl_udata_buf *buf)
>> +{
>> +	buf->size = 0;
>> +	buf->end = NULL;
>> +	free((void *)buf);
>               ^^^^^^^^
> No need for cast this either here.
>

I have changed this everywere.

>> +}
>> +EXPORT_SYMBOL(nftnl_udata_free);
>> +
>> +size_t nftnl_udata_len(const struct nftnl_udata_buf *buf)
>
> Better use uint32_t instead of size_t. This type depends on the arch
> so in 32 bit will be u32 and in 64 bit will be u64.
>
> And uint32_t should be sufficient for this, same thing here and
> everywhere else.
>
>> +{
>> +	return (size_t)(buf->end - buf->data);
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_len);
>> +
>> +size_t nftnl_udata_size(const struct nftnl_udata_buf *buf)
>
> Same thing here.

Done.

>
>> +{
>> +	return buf->size;
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_size);
>> +
>> +void *nftnl_udata_data(const struct nftnl_udata_buf *buf)
>> +{
>> +	return (void *)buf->data;
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_data);
>> +
>> +void nftnl_udata_copy_data(struct nftnl_udata_buf *buf,
>> +			   const void *data, size_t len)
>> +{
>> +	memcpy(buf->data, data, len <= buf->size ? len : buf->size);
>> +	buf->end = buf->data + len;
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_copy_data);
>> +
>> +struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *buf)
>> +{
>> +	return (struct nftnl_udata *)buf->data;
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_start);
>> +
>> +struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *buf)
>> +{
>> +	return (struct nftnl_udata *)buf->end;
>> +}
>> +EXPORT_SYMBOL(nftnl_udata_end);
>> +
>> +struct nftnl_udata *nftnl_udata_put(struct nftnl_udata_buf *buf,
>> +				    uint8_t type, size_t len, const void *value)
>> +{
>> +	struct nftnl_udata *attr = NULL;
>> +
>> +	/* Check if there is enough space */
>
> Remove this comment.

Done.

>
>> +	if (buf->size >= len + sizeof(struct nftnl_udata)) {
>> +		attr = (struct nftnl_udata *)buf->end;
>> +		attr->len  = len;
>> +		attr->type = type;
>> +		memcpy(attr->value, value, len);
>> +
>> +		buf->end = (char *)nftnl_udata_attr_next(attr);
>> +	}
>> +
>> +	return attr;
>
> Why return the nftnl_udata? You can just return a boolean instead.
> Same thing in nftnl_udata_put_strz().

I thought it would be useful, actually it is not. I deleted it.
