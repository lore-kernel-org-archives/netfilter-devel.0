From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][libnetfilter_conntrack] add support for explicit helper
 assignment
Date: Thu, 09 Oct 2008 18:59:22 +0200
Message-ID: <48EE386A.1010602@netfilter.org>
References: <48EDDE81.9070606@netfilter.org> <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48258 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753693AbYJIRCt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:02:49 -0400
In-Reply-To: <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>> diff --git a/src/conntrack/build.c b/src/conntrack/build.c
>> index 1bc87f9..8c7cb7f 100644
>> --- a/src/conntrack/build.c
>> +++ b/src/conntrack/build.c
>> @@ -308,6 +308,38 @@ void __build_secmark(struct nfnlhdr *req,
>>      nfnl_addattr32(&req->nlh, size, CTA_SECMARK, htonl(ct->secmark));
>>  }
>>
>> +const char *helper_id_to_name[] = {
>> +    [NFCT_HELPER_UNSPEC]        = "unknown-helper",
>> +    [NFCT_HELPER_AMANDA]         = "amanda",
>> +    [NFCT_HELPER_FTP]         = "ftp",
>> +    [NFCT_HELPER_H323]        = "h323",
>> +    [NFCT_HELPER_IRC]        = "irc",
>> +    [NFCT_HELPER_NETBIOS_NS]    = "netbios_ns",
>> +    [NFCT_HELPER_PPTP]        = "pptp",
>> +    [NFCT_HELPER_SANE]        = "sane",
>> +    [NFCT_HELPER_SIP]        = "sip",
>> +    [NFCT_HELPER_TFTP]        = "tftp",
>> +};
>> +
> 
> Any chances to make it more frendly to new helpers and compatible with
> out-of-tree helpers by registering a name directly from a helper and
> using it? We may for example introduce something like /proc/net/nf_helpers.

We may directly set the name of the helper using the string that
identifies it instead of this id. However, this means more memory
consumption but more flexibility. I have another patch here that uses
strings to do so. The problem is that helpers doesn't have a limitation
in the name length and I don't like the idea of having a field
"helper_name" with variable length inside the nf_conntrack object. We
could make some reasonable assumptions, like considering that the helper
name would not be larger than 32 bytes.

Using this patch, the new helpers would need a new version of the
library as you have said. However, the argument of supporting
out-of-tree helpers doesn't convince me, what out-of-tree helpers are
you refering to?

BTW, the patch is not yet applied anyway.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
