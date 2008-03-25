From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Tue, 25 Mar 2008 13:57:24 +0100
Message-ID: <47E8F6B4.4030800@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep25-int.chello.at ([62.179.121.45]:22173 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYCYM5d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:57:33 -0400
Received: from edge02.upc.biz ([192.168.13.237]) by viefep25-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080325125730.SGIQ12469.viefep25-int.chello.at@edge02.upc.biz>
          for <netfilter-devel@vger.kernel.org>;
          Tue, 25 Mar 2008 13:57:30 +0100
In-Reply-To: <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Tuesday 2008-03-25 03:28, Jan Engelhardt wrote:
>>
>>>  None of my packets that were supposed to have that "3" mark ever kept
>>>  them.  For some reason, they either never were marked or they were
>>>  marked and then the mark disappeared.
>>
>> I can reproduce it. [...]
>> Now that is indeed interesting. I had this thought, maybe the mark 
>> does not disappear, maybe ebtables is run -- contrary to most graphics 
>> depicting the netfilter flow -- _after_ iptables. So I tried:
>>
>>      iptables -t mangle -A POSTROUTING -j LOG --log-prefix "[ipt] " -d
>>      134.76.13.21
>>      ebtables -A OUTPUT -p ipv4 --ip-destination 134.76.13.21 --log
>>      --log-prefix "[ebt] "
>>
>> with the result of:
>>
>>      [214961.190130] [ipt] IN= OUT=br0 SRC=10.10.106.161 DST=134.76.13.21
>>      LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ICMP TYPE=8 CODE=0
>>      ID=59252 SEQ=1
>>
>>      [214961.190186] [ebt]  IN= OUT=sis0 MAC source = 00:0a:e6:98:ed:d7
>>      MAC
>>      dest = 68:a8:3e:d3:d0:fb proto = 0x0800
>>
>> which means ebtables actually comes after iptables, and hence, your 
>> mark 3 will not show up as you expected.


Indeed, on output bridge netfilter will run after IPv4 netfilter.
Does that explain things?
