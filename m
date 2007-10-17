From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 17 Oct 2007 22:13:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710172210380.8216@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <47047DF3.5030305@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1770811100-1192652025=:8216"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:39900 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbXJQUOA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:14:00 -0400
In-Reply-To: <47047DF3.5030305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1770811100-1192652025=:8216
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 4 Oct 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> [NETFILTER]: Trivial fix for "nf_ct_tcp: invalid SYN"
>>
>> This nf_log_packet needs a space char. Trivial fix
>>
>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>
> Applied, thanks.

With latest fixes from Jozsef this patch should be dropped as this code=20
was removed and now there is nothing to fix. ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1770811100-1192652025=:8216--
