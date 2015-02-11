From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] Add MARK target for arptables
Date: Wed, 11 Feb 2015 16:58:20 +0800
Message-ID: <54DB19AC.6010107@cn.fujitsu.com>
References: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com> <1423207590-13423-2-git-send-email-gaofeng@cn.fujitsu.com> <20150210231852.GA3715@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60376 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751166AbbBKI6R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 03:58:17 -0500
In-Reply-To: <20150210231852.GA3715@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/11/2015 07:18 AM, Pablo Neira Ayuso wrote:
> On Fri, Feb 06, 2015 at 03:26:29PM +0800, Gao feng wrote:
>> We can use MARK target to set make value for
>> arp packet.
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  extensions/Makefile    |   2 +-
>>  extensions/arpt_MARK.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 120 insertions(+), 1 deletion(-)
>>  create mode 100644 extensions/arpt_MARK.c
>>
>> diff --git a/extensions/Makefile b/extensions/Makefile
>> index 09b244e..0189cc9 100644
>> --- a/extensions/Makefile
>> +++ b/extensions/Makefile
>> @@ -1,6 +1,6 @@
>>  #! /usr/bin/make
>>  
>> -EXT_FUNC+=standard mangle CLASSIFY
>> +EXT_FUNC+=standard mangle CLASSIFY MARK
>>  EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/arpt_$(T).o)
>>  
>>  extensions/ebt_%.o: extensions/arpt_%.c include/arptables.h include/arptables_common.h
>> diff --git a/extensions/arpt_MARK.c b/extensions/arpt_MARK.c
>> new file mode 100644
>> index 0000000..ce24bdb
>> --- /dev/null
>> +++ b/extensions/arpt_MARK.c
>> @@ -0,0 +1,119 @@
>> +/*
>> + * (C) 2015 by Gao feng <gaofeng@cn.fujitsu.com>
>> + *
>> + * arpt_MARK.c -- arptables extension to set mark for arp packet
>> + *
>> + *	This program is free software; you can redistribute it and/or modify
>> + *	it under the terms of the GNU General Public License as published by
>> + *	the Free Software Foundation; either version 2 of the License, or
>> + *	(at your option) any later version.
>> + *
>> + *	This program is distributed in the hope that it will be useful,
>> + *	but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *	GNU General Public License for more details.
>> + *
>> + *	You should have received a copy of the GNU General Public License
>> + *	along with this program; if not, write to the Free Software
>> + *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +#include <stdio.h>
>> +#include <getopt.h>
>> +#include <arptables.h>
>> +#include <linux/netfilter/xt_mark.h>
>> +#include <linux/netfilter/x_tables.h>
>> +
>> +static void
>> +help(void)
>> +{
>> +	printf(
>> +"MARK target v%s options:\n"
>> +"--set-mark mark : set the mark value\n",
>> +	ARPTABLES_VERSION);
>> +}
>> +
>> +#define MARK_OPT 1
>> +
>> +static struct option opts[] = {
>> +	{ "set-mark"   , required_argument, 0, MARK_OPT },
>> +	{0}
> 
> Please, add all options that MARK support according to man
> iptables-extensions.

Get, will do. thanks!

