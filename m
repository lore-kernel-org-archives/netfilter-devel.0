From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Sat, 23 Mar 2013 12:12:29 +0000
Message-ID: <514D9C2D.7030801@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost> <512D0BA4.7060809@googlemail.com> <20130226214707.GA3555@localhost> <512E7331.10304@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:64188 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWMNE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:13:04 -0400
Received: by mail-la0-f42.google.com with SMTP id fe20so8887624lab.1
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2013 05:13:02 -0700 (PDT)
In-Reply-To: <512E7331.10304@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo and all,


> Pablo Neira Ayuso wrote:
>> Would that fit into your needs?
> Short answer: no, not really.
In connection with this subject, I wanted to let you know that I have made quite a lot of changes, which I would try to describe below.

We have had internal team gathering almost 3 weeks ago and started planning for the changes to nfacct in order to make it more useful and more functional. This was also done with a view of a presentation to all major stakeholders of the company, which was previously planned and finally concluded 2 days ago (Thursday). During that we demonstrated our new and improved capability (utilizing the new and improved nfacct was part of that, of course!).

I am glad to let you know that everything was very well received and, after fine-tuning my work I am going to submit 3 patches to this community very shortly, with the changes I've made to the nfacct system. They are quite extensive and nfacct executable in particular was almost completely re-written. I also found a few bugs, which I fixed.

The new changes follow (I will also include a printouts to be more clear). The only changes I have made to the kernel code since my last posting was the introduction of another property called 'bytes threshold' (64-bit number). Its main purpose was to enable us to register 'an expectation' of the traffic passing through a given accounting object and if this threshold is exceeded (in other words if bytes count > threshold), then this is visually displayed with the 'list' and 'get' commands. In other words:

[root@27_13 ~]# nfacct list
[ pkts =    7.260GiB  bytes =   6.817TiB+ ] = "ALL 27 net"
[ pkts = 296,615,264  bytes =  21.750GiB  ] = " IN web;streaming"
[ pkts = 533,035,424  bytes = 721.382GiB  ] = "OUT web;streaming"
[ pkts = 263,548,272  bytes = 236.012GiB+ ] = "ALL misc"
[ pkts =  12,852,909  bytes =  11.510GiB  ] = "ALL private"
[ pkts =     942,885  bytes = 864.635MiB  ] = "ALL sec;audit"


As we see above, the plus sign (+) next to the bytes count indicates that the registered threshold for this accounting object has been exceeded (enabling such threshold is, of course, entirely optional). The actual threshold value can be shown with a new option of the 'list' and 'get' commands (called 'show') in which I can specify what columns to view. In other words:

[root@27_13 shorewall]# nfacct list show bytes
[ bytes =   6.817TiB+ ] = "ALL 27 net"
[ bytes =  21.750GiB  ] = " IN web;streaming"
[ bytes = 721.382GiB  ] = "OUT web;streaming"
[ bytes = 236.012GiB+ ] = "ALL misc"
[ bytes =  11.510GiB  ] = "ALL private"
[ bytes = 864.635MiB  ] = "ALL sec;audit"

As we can see, with the above I am shown only the name and bytes columns.

[root@27_13 ~]# nfacct list show extended
[ pkts =    7.260GiB  bytes =   6.817TiB+ thr =   6.000TiB ] = "ALL 27 net"
[ pkts = 296,615,264  bytes =  21.750GiB  thr =          - ] = " IN web;streaming"
[ pkts = 533,035,424  bytes = 721.382GiB  thr =          - ] = "OUT web;streaming"
[ pkts = 263,548,272  bytes = 236.012GiB+ thr = 200.000GiB ] = "ALL misc"
[ pkts =  12,852,909  bytes =  11.510GiB  thr =  50.000GiB ] = "ALL private"
[ pkts =     942,885  bytes = 864.635MiB  thr =          - ] = "ALL sec;audit"

As we can see now, by selecting a different 'show' option ('extended' in this case), different properties are shown (I am now shown all properties - packets and byte counters, as well as the threshold values and threshold exceeded indicator, plus account object names).

Another good feature is that all column widths are now adjusted 'automatically' by nfacct (libnetfilter_acct plays a major part in this) so that we don't get excessive amount of space shown on the user screen or numbers displayed like 00000000000000001234, which was a bit ugly to say the least.

Coming back to the 'bytes threshold', from the last example above we can see that for "ALL 27 net" and "ALL misc" accounting objects, the threshold of 6TiB and 200GiB respectively, has been exceeded and that is indicated by the "+" sign next to the bytes counter. 

We will also notice that all account object names, if they contain 'odd' symbols are now encoded and shown with quotations. This was one of many bugs I found during the improvements I've made to nfacct - if that name contained any of these characters, restore fails. With the current improvements, this is all now gone.

Also as a result of that, not all data was properly encoded when the 'xml' output parameter was used - characters were shown when they were non-conformant to the xml specification (like '>' or '&' for example), but enough about bad bugs...

The formatting of objects can now be overwritten by the 'list' and 'get' commands too. The formatting of the numbers of all accounting objects in the above example is 'natural' to the accounting objects themselves, but this can be changed. In other words:

[root@27_13 ~]# nfacct list show extended format raw
[ pkts = 7795058176  bytes = 7495370670080+ thr = 6597069766656 ] = "ALL 27 net"
[ pkts =  296615264  bytes =   23353884672  thr =             - ] = " IN web;streaming"
[ pkts =  533035424  bytes =  774578044928  thr =             - ] = "OUT web;streaming"
[ pkts =  263548272  bytes =  253415948288+ thr =  214748364800 ] = "ALL misc"
[ pkts =   12852909  bytes =   12358768640  thr =   53687091200 ] = "ALL private"
[ pkts =     942885  bytes =     906635520  thr =             - ] = "ALL sec;audit"


With the above, I asked the 'list' command to show me un-formatted values ('raw' was the format used, but I can select any formatting option I chose - I have now a complete freedom).

Maybe the major issue resolved in terms of administration is the new 'save' and 'restore' commands.

The previous 'restore' command wasn't working, and it was capturing input from the 'list' command. This was ugly (a bit like trying to do iptables-restore from 'iptables -L'). The new 'save' command now produces output to stdout in a form completely suitable for the new 'restore' command. In other words:

[root@27_13 ~]# nfacct save
"ALL 27 net" iec,tib 7795057933 7495370766549 6597069766656
" IN web;streaming" 3pl,gib 296615255 23353884672 0
"OUT web;streaming" 3pl,gib 533035414 774578024481 0
"ALL misc" 3pl,gib 263548277 253415955366 214748364800
"ALL private" 3pl,gib 12852909 12358768394 53687091200
"ALL sec;audit" 3pl,mib 942885 906635509 0

As we can see, this can be safely directed to a file and then used with the new 'nfacct restore'.

The 'restore' command also had a lot of changes: The best improvement in this is that it now allows all accounting objects to be restored regardless of whether they are used by iptables or not. This was not possible before. 

The two additional parameters to the 'restore' command - 'flush' and 'replace' make sure that the accounting table can be flushed (though objects used by iptables are still not deleted) and the second option - 'replace' - makes sure that accounting object properties are replaced if they exist in the accounting table. The latter option can modify object properties even if these are in use/locked by iptables. The 'add' and 'get' commands have similar options allowing accounting object properties to be modified at will. That was not possible before.

So, with the new 'save' and 'restore' nfacct commands it is now possible for full and complete restoration of all account objects to be done. I will list the detailed changes I've made for each nfacct component (kernel, libnetfilter_acct and nfacct) in the patches I will submit shortly.

For full information about the new and improved features, there is alsomst completely re-written man page, but I am listing the output of the 'help' command which shows very briefly all the options currently available. The nfacct executable now has the following options (from the improved 'nfacct help' command):

nfacct v1.0.1: utility for the Netfilter extended accounting infrastructure
Usage: nfacct command [parameters]...

Commands:
  list LST_PARAMS	List the accounting object table
  add NAME ADD_PARAMS	Add new accounting object NAME to table
  delete NAME		Delete existing accounting object NAME
  get NAME GET_PARAMS	Get and list existing accounting object NAME
  flush			Flush accounting object table
  save			Dump current accounting object table to stdout
  restore RST_PARAMS	Restore accounting object table from stdin
  version		Display version and disclaimer
  help			Display this help message

Parameters:
  LST_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ] [ xml ]
  ADD_PARAMS := [ replace ] [ format FMT_SPEC ] [ threshold NUMBER ]
  GET_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ] [ xml ]
  RST_PARAMS := [ flush ] [ replace ]
  SHOW_SPEC := { bytes | extended }
  FMT_SPEC := { [FMT] | [,] | [FMT] ... }
  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib | eib |
  	   si | kb | mb | gb | tb | pb | eb }

After all this, I do have a question: in what circumstances can the kernel part be unable to update the account object counters - is this possible and if so in what circumstances and how likely is this to happen?

It is important for us to know and that is one question I was asked and I didn't really knew the answer, though by looking in the kernel code I couldn't find anything which could prevent that from happening, but thought to ask here anyway.


MZ
