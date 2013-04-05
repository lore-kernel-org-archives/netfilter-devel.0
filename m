From: Victor Julien <lists@inliniac.net>
Subject: Re: [Ulogd2 PATCH 2/3] Lower libnfnetlink requirement to 1.0.0
Date: Fri, 05 Apr 2013 18:08:05 +0200
Message-ID: <515EF6E5.6010506@inliniac.net>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net> <1365172437-15042-3-git-send-email-victor@inliniac.net> <20130405153940.GC32205@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39547 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161931Ab3DEQIQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:08:16 -0400
Received: from [192.168.1.3] (a80-101-90-58.adsl.xs4all.nl [80.101.90.58])
	(authenticated bits=0)
	by tulpe.vuurmuur.org (8.14.3/8.14.3/Debian-9.4) with ESMTP id r35FsZhV006439
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 5 Apr 2013 17:54:37 +0200
In-Reply-To: <20130405153940.GC32205@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/05/2013 05:39 PM, Pablo Neira Ayuso wrote:
> On Fri, Apr 05, 2013 at 04:33:56PM +0200, Victor Julien wrote:
>> Build and run tested against 1.0.0, worked fine for me.
>>
>> ---
>>  configure.ac |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index a439bee..5755cf5 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -48,7 +48,7 @@ regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
>>  AC_SUBST([regular_CFLAGS])
>>  
>>  dnl Check for the right nfnetlink version
>> -PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
>> +PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
> 
> Same thing here. There was also a reason to bump the version
> dependency.
> 
> There's a fix in libnfnetlink in the nlif interface.
> 
> commit 8b15e485c0d5f4a1e56b2148a34995ed1fa9e95b
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Mon Aug 13 19:49:58 2012 +0200
> 
>     iftable: fix incomplete list of interfaces via nlif_query
> 
> In systems with lots of NICs, nlif_query may fail without that patch
> in libnfnetlink.
> 
> Please, don't downgrade the dependencies.

Okay, got it. Would have been nice to be able to work with the versions
installed by recent distro's though.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

