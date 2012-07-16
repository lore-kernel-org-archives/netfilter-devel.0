From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 13:52:38 +0100
Message-ID: <50040E96.5050005@googlemail.com>
References: <50002CEF.508@googlemail.com> <1342194935.11019.12.camel@tiger.regit.org> <50016D84.5080207@googlemail.com> <1342300959.6098.8.camel@tiger.regit.org> <5002B688.4070907@googlemail.com> <1342385528.8476.2.camel@tiger.regit.org> <500345F1.3050407@googlemail.com> <20120716080013.GA522@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41417 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2GPMwl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:52:41 -0400
Received: by eekc13 with SMTP id c13so163960eek.19
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jul 2012 05:52:40 -0700 (PDT)
In-Reply-To: <20120716080013.GA522@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> The specific reason I raised this issue is because on the main
>> firewall we have here, if I deploy ulogd2 and use NFCT at its
>> present form, I will get the logs from all 7 interfaces, and it
>> would make it an absolutely huge task to sift through all these logs
>> and "match" the various entries (OK, doing it through the database
>> will help up a bit, but not a lot).
>>     
>
> Try something like
> iptables -t raw -A PREROUTING (thingsyoudontwant) -j CT --ctevents related
>   
What do you mean by "(thingsyoudontwant)"? How would that affect 
tracking (sorry, I probably need to brush-up on the CT a bit)?

