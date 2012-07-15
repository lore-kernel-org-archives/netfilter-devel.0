From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Sun, 15 Jul 2012 13:24:40 +0100
Message-ID: <5002B688.4070907@googlemail.com>
References: <50002CEF.508@googlemail.com>	 <1342194935.11019.12.camel@tiger.regit.org>	 <50016D84.5080207@googlemail.com> <1342300959.6098.8.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40834 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GOMYv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:24:51 -0400
Received: by wgbdr13 with SMTP id dr13so160930wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 05:24:49 -0700 (PDT)
In-Reply-To: <1342300959.6098.8.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> For NFCT, you simply need to have nfnetlink_conntrack loaded.
>   
I did, but I also made the mistake of including a few filters in that 
stack, which were incompatible and that was the reason I did not get any 
NFCT logs. Once that was corrected I started seeing connection tracking 
logged.

I have another question with regards to this: Is it possible to limit 
(by a separate filter or otherwise) the reporting and restrict it, to 
say, a specific set of interfaces or specific source/destination IP 
addresses/subnets?

Currently, NFCT reports absolutely everything, which is not what I 
really want as I have to sift through thousands of logs, not to mention 
that by reporting everything the system load is much higher.

So, is there a way for me to do that, somehow?

> Things are more complicated for NFACCT and I've just wrote a page
> dedicated to this point:
> https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd2/
>   
Very helpful, thanks! I don't see it as complicated at all, certainly no 
more complicated than the existing accounting techniques.

>> Is there a description on the purpose of these and their configuration 
>> parameters, if any?
>>     
>
> To now which keys are used and whch config var are available, you can
> use the -i option of ulogd:
>
> ulogd -i libexec/ulogd/ulogd_filter_MARK.so 
> Name: MARK
> Config options:
>         Var: mark (Integer, Default: 0)
>         Var: mask (Integer, Default: -1)
> Input keys:
>         Key: ct.mark (unsigned int 32, optional)
>         Key: oob.mark (unsigned int 32, optional)
> Output keys:
>         No statically defined keys
>   
Or look at the source code, which is what I did at the end.

>> I will dig much more deeper into this once I know how ulogd works as my 
>> knowledge of ulogd2 is not that great (yet!). My initial instinct is 
>> that I may have to alter this script slightly, because from what I 
>> gather ulogd2 is "sensing" the structure of the logging table by reading 
>> the "description" of it in PostgreSQL. That particular operation usually 
>> requires higher-than-needed privileges and in order to avoid that I 
>> might need to find other ways to impose the "insert-only" restriction, 
>> which, lets be clear, is what ulogd needs. Again, I might be wrong with 
>> this, but that is what my initial observations with the script and ulogd 
>> suggest.
>>     
>
> Yes, there's a discovery system that may require some tuning. But it can
> be made on a separate table use for the only purpose of describing the
> variables.
>   
Yep, the pgsql plugin makes extensive use of pg_namespace, pg_class and 
pg_attribute which are system tables. These contain definitions of every 
single object registered on that database server and is a major security 
risk (as I pointed out, if that ulogd connection to the database server 
is hijacked, then the attacker could find out what is on that database 
without any problems, which is not good).

I had in mind exactly what you've suggested above - use a separate, 
manually-registered table containing the table columns and their mapping 
to ulogd2 parameters - much less risk and everything is configurable, 
though the downside is that the two tables need to be synchronised if 
the structure of the main ulogd table changes (columns renamed or added).

