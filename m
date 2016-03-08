From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/3 v2] libnftnl: Implement new buffer of TLV objects.
Date: Tue, 8 Mar 2016 10:57:50 +0100
Message-ID: <56DEA21E.4000603@riseup.net>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
 <20160302183207.GA1351@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:58439 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256AbcCHJ5y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 04:57:54 -0500
In-Reply-To: <20160302183207.GA1351@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/03/16 19:32, Pablo Neira Ayuso wrote:
> On Mon, Feb 29, 2016 at 05:25:38PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>> diff --git a/include/attr.h b/include/attr.h
>> new file mode 100644
>> index 0000000..2a29fa0
>> --- /dev/null
>> +++ b/include/attr.h
>> @@ -0,0 +1,40 @@
>> +#ifndef _LIBNFTNL_ATTR_INTERNAL_H_
>> +#define _LIBNFTNL_ATTR_INTERNAL_H_
>> +
>> +#include <stdint.h>
>> +#include <stddef.h>
>> +
>> +/*
>> + * TLV structures:
>> + * nftnl_attr
>> + *  <-------- HEADER --------> <------ PAYLOAD ------>
>> + * +------------+-------------+- - - - - - - - - - - -+
>> + * |    type    |     len     |         value         |
>> + * |  (1 byte)  |   (1 byte)  |                       |
>> + * +--------------------------+- - - - - - - - - - - -+
>> + *  <-- sizeof(nftnl_attr) --> <-- nftnl_attr->len -->
>> + */
>> +struct __attribute__((__packed__)) nftnl_attr {
>> +	uint8_t type;
>> +	uint8_t len;
>> +	unsigned char value[];
>> +};
>
> struct nftnl_attr {
>        ...
> } __attribute__((__packed__));
>

I forgot these, sorry. I'll send a new versi=F3n now.

>> diff --git a/src/libnftnl.map b/src/libnftnl.map
>> index 2e193b7..65bd37e 100644
>> --- a/src/libnftnl.map
>> +++ b/src/libnftnl.map
>> @@ -336,6 +336,22 @@ global:
>>     nftnl_set_snprintf;
>>     nftnl_set_fprintf;
>>
>> +  nftnl_attrbuf_alloc;
>> +  nftnl_attrbuf_free;
>> +  nftnl_attrbuf_get_len;
>> +  nftnl_attrbuf_get_size;
>> +  nftnl_attrbuf_get_data;
>> +  nftnl_attrbuf_copy_data;
>> +  nftnl_attrbuf_get_start;
>> +  nftnl_attrbuf_get_end;
>> +  nftnl_attr_get_type;
>> +  nftnl_attr_get_len;
>> +  nftnl_attr_get_value;
>> +  nftnl_attr_put;
>> +  nftnl_attr_put_check;
>> +  nftnl_attr_next;
>> +  nftnl_attr_parse;
>
> Are you sure we need to export all these? Please only export those
> functions that we really need at this stage for nft.

The only function that is not being used now is "nftnl_udata_size". But=
=20
I left it because "size" is an attribute of the object and I think it i=
s=20
right to allow the access to it. I must remove it anyway?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
