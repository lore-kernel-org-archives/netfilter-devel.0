From: justin joseph <justin.cok@gmail.com>
Subject: Re: bug in iptables
Date: Fri, 22 Feb 2008 12:56:15 +0530
Message-ID: <47BE7917.1030301@gmail.com>
References: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com> <47B53643.9000107@gmail.com> <47BACB6C.4090000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail19i.g19.rapidsite.net ([204.202.242.121]:46817 "HELO
	mail19i.g19.rapidsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752851AbYBVH0b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:26:31 -0500
Received: from mx70.stngva01.us.mxservers.net (204.202.242.141)
	by mail19i.g19.rapidsite.net (RS ver 1.0.95vs) with SMTP id 3-0424845188
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Feb 2008 02:26:29 -0500 (EST)
In-Reply-To: <47BACB6C.4090000@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Patrick McHardy wrote:
> justin joseph wrote:
>>
>>
>> justin joseph wrote:
>>> Hi,
>>
>>
>>> It seems to be there in iptables as well.
>>
>> To be specific I am able to add a rule thus:
>>
>> iptables -t mangle -A tcpost -i lan1 -s 192.168.10.10 -o wan1 -p tcp 
>> --dport 22 -j CLASSIFY --set-class 1:11
> 
> Your example doesn't contain the rule jumping to "tcpost", so
> its not clear whether this really is a bug. Please post all
> four rules (tcpost and -j tcpost) and the kernel version you're
> using.
> 



Chain POSTROUTING (policy ACCEPT 2263 packets, 528K bytes)
  pkts bytes target     prot opt in     out     source               destination
  2227  523K MARK       all  --  any    any     anywhere             anywhere            MARK and 0xff
  2227  523K tcpost     all  --  any    any     anywhere             anywhere

Chain tcfor (1 references)
  pkts bytes target     prot opt in     out     source               destination

Chain tcout (1 references)
  pkts bytes target     prot opt in     out     source               destination

Chain tcpost (1 references)
  pkts bytes target     prot opt in     out     source               destination
     0     0 CLASSIFY   tcp  --  lan1   wan1    anywhere             anywhere            tcp dpt:ssh 
CLASSIFY set 1:11
     0     0 CLASSIFY   all  --  any    wan1    anywhere             anywhere            MARK match 
0x1/0xff CLASSIFY set 1:11
     0     0 CLASSIFY   all  --  any    wan1    anywhere             anywhere            MARK match 
0xfe/0xff CLASSIFY set 1:1254


root@hq.enpaq:~# uname -r
2.6.15-29-386
root@hq.enpaq:~#

