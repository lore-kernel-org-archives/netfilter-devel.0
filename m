From: Victor Julien <lists@inliniac.net>
Subject: Re: [Ulogd2 PATCH 1/3] Remove configure check for libmnl, it is not
 used
Date: Fri, 05 Apr 2013 17:47:13 +0200
Message-ID: <515EF201.7030007@inliniac.net>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net> <1365172437-15042-2-git-send-email-victor@inliniac.net> <20130405153428.GA32205@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Victor Julien <victor@inliniac.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39546 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161724Ab3DEP4e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:56:34 -0400
In-Reply-To: <20130405153428.GA32205@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/05/2013 05:34 PM, Pablo Neira Ayuso wrote:
> On Fri, Apr 05, 2013 at 04:33:55PM +0200, Victor Julien wrote:
>> If libmnl is missing configure fails. However, the lib is not used nor
>> linked to.
>>
>> ---
>>  configure.ac |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index c94704b..a439bee 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -49,7 +49,6 @@ AC_SUBST([regular_CFLAGS])
>>  
>>  dnl Check for the right nfnetlink version
>>  PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
>> -PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
> 
> input/sum/ulogd_inpflow_NFACCT.c
> 
> needs this.

Shouldn't it be a conditional check then? Only if nfacct is enabled?

I'm testing with only nflog support and it builds and runs fine with my
patch.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

