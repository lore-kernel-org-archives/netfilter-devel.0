From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH][libnetfilter_conntrack] add support for explicit helper
 assignment
Date: Thu, 9 Oct 2008 19:15:47 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810091911240.26944@bizon.gios.gov.pl>
References: <48EDDE81.9070606@netfilter.org> <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl> <48EE386A.1010602@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1392779265-1223572548=:26944"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:50117 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYJIRPz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:15:55 -0400
In-Reply-To: <48EE386A.1010602@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1392779265-1223572548=:26944
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Thu, 9 Oct 2008, Pablo Neira Ayuso wrote:

> Krzysztof Oledzki wrote:
>>> diff --git a/src/conntrack/build.c b/src/conntrack/build.c
>>> index 1bc87f9..8c7cb7f 100644
>>> --- a/src/conntrack/build.c
>>> +++ b/src/conntrack/build.c
>>> @@ -308,6 +308,38 @@ void __build_secmark(struct nfnlhdr *req,
>>>      nfnl_addattr32(&req->nlh, size, CTA_SECMARK, htonl(ct->secmark));
>>>  }
>>>
>>> +const char *helper_id_to_name[] = {
>>> +    [NFCT_HELPER_UNSPEC]        = "unknown-helper",
>>> +    [NFCT_HELPER_AMANDA]         = "amanda",
>>> +    [NFCT_HELPER_FTP]         = "ftp",
>>> +    [NFCT_HELPER_H323]        = "h323",
>>> +    [NFCT_HELPER_IRC]        = "irc",
>>> +    [NFCT_HELPER_NETBIOS_NS]    = "netbios_ns",
>>> +    [NFCT_HELPER_PPTP]        = "pptp",
>>> +    [NFCT_HELPER_SANE]        = "sane",
>>> +    [NFCT_HELPER_SIP]        = "sip",
>>> +    [NFCT_HELPER_TFTP]        = "tftp",
>>> +};
>>> +
>>
>> Any chances to make it more frendly to new helpers and compatible with
>> out-of-tree helpers by registering a name directly from a helper and
>> using it? We may for example introduce something like /proc/net/nf_helpers.
>
> We may directly set the name of the helper using the string that
> identifies it instead of this id. However, this means more memory
> consumption but more flexibility. I have another patch here that uses
> strings to do so. The problem is that helpers doesn't have a limitation
> in the name length and I don't like the idea of having a field
> "helper_name" with variable length inside the nf_conntrack object. We
> could make some reasonable assumptions, like considering that the helper
> name would not be larger than 32 bytes.

Yep, 32 bytes seems to be a good compromise.

> Using this patch, the new helpers would need a new version of the
> library as you have said. However, the argument of supporting
> out-of-tree helpers doesn't convince me, what out-of-tree helpers are
> you refering to?

nf_conntrack_rtsp for example

Best regards,

 				Krzysztof Olêdzki
---1144830174-1392779265-1223572548=:26944--
