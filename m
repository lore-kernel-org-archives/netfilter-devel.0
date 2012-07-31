From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/7] iptables-restore: warn about -t in rule lines
Date: Tue, 31 Jul 2012 14:13:14 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207311412190.15228@frira.zrqbmnf.qr>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de> <1343496069-5442-2-git-send-email-jengelh@inai.de> <20120731113920.GA4511@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:33071 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2GaMNQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:13:16 -0400
In-Reply-To: <20120731113920.GA4511@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-07-31 13:39, Pablo Neira Ayuso wrote:
>> @@ -417,8 +417,7 @@ int ip6tables_restore_main(int argc, char *argv[])
>>  					if (!strncmp(param_buffer, "-t", 2)
>>                                              || !strncmp(param_buffer, "--table", 8)) {
>>  						xtables_error(PARAMETER_PROBLEM,
>> -						   "Line %u seems to have a "
>> -						   "-t table option.\n", line);
>> +						   "The -t option (seen in line %u) cannot be used in ip6tables-restore.\n", line);
>
>Lines should break at 80 chars.
>
>I know we sometimes slightly violate this limit, but I don't want to
>have wrapping code in my 80-chars terminals.

I know; however, if there already are 5 levels *and* you have a text
string (people grep for that!), it is in principle nicer to have it
non-wrapped.
