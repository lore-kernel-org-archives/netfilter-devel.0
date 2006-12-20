From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] xt_request_find_match
Date: Wed, 20 Dec 2006 10:11:25 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612201009540.26276@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr>
 <4587D227.1000003@trash.net> <Pine.LNX.4.61.0612191405160.24179@yvahk01.tjqt.qr>
 <4587E91A.2020903@trash.net> <Pine.LNX.4.61.0612191623490.10396@yvahk01.tjqt.qr>
 <4588F175.8060109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964948AbWLTJMU@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4588F175.8060109@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>Jan Engelhardt wrote:
>> [...]
>>
>> Ok, but let's say I wanted to use a bigger match module (layer7, anyone?)
>> Then it's just not if(protocol == IPPROTO_TCP). What's the preferred solution
>> then?
>
>Make sure the user specifies the match on the command line before
>your match. Look at the TCPMSS or REJECT targets for examples for
>this.

That would mean I'd have to

  -p tcp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
lotsofothers -j TARGET
  -p udp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
lotsofothers -j TARGET

which can become quite computationally expensive - which I wanted to 
avoid.


	-`J'
-- 
