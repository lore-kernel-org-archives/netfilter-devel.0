From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Tue, 21 Oct 2008 23:13:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810212308460.30799@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu> <alpine.LNX.1.10.0810212240190.30799@bizon.gios.gov.pl> <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-658514175-1224623630=:30799"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:53046 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYJUVNz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:13:55 -0400
In-Reply-To: <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-658514175-1224623630=:30799
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 21 Oct 2008, Jozsef Kadlecsik wrote:

> On Tue, 21 Oct 2008, Krzysztof Oledzki wrote:
>
>> # element separator token changed to ',' in anticipating IPv6 addresses, old
>> separator tokens are still supported
>>
>> # cat  aqq
>> -N aqq macipmap --from 1.2.3.1 --to 1.2.3.10
>> -A aqq 1.2.3.10,11:22:33:44:55:66
>> COMMIT
>>
>> # cat aqq|ipset -R
>> Warning: please replace old separator character ':22:33:44:55:66.1' with ','.
>> Next release won't support it.
>>
>> OK, so what we are deprecating here? The recently introduced '%' separator or
>> also the ':' mac address separator?
>
> No, the separator between the different kind of elements, i.e. between IP
> address and port or between IP address and MAC address. The token
> separators inside IPv4(/IPv6) and MAC addresses remain the usual ones.

Great!

> That message is just misleading and I'm going to fix it.

OK, thanks. BTW, is it possible to print this warning only once as 
restoring a ipset with 2K entries generates 2K warnings.

> Sorry for the mess created by introducing earlier the '%' as a separator,
> that was a bad choice. :-(

That's the smallest problem here, simple sed can handle it. ;)

Best regards,

 				Krzysztof Olêdzki
---1144830174-658514175-1224623630=:30799--
