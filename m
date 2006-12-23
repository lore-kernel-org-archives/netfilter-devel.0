From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_request_find_match
Date: Sat, 23 Dec 2006 22:57:05 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612232254110.10087@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr>
 <4587D227.1000003@trash.net> <Pine.LNX.4.61.0612191405160.24179@yvahk01.tjqt.qr>
 <4587E91A.2020903@trash.net> <Pine.LNX.4.61.0612191623490.10396@yvahk01.tjqt.qr>
 <4588F175.8060109@trash.net> <Pine.LNX.4.61.0612201009540.26276@yvahk01.tjqt.qr>
 <4588FF92.9050607@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753782AbWLWV54@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4588FF92.9050607@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Dec 20 2006 10:17, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>>>Make sure the user specifies the match on the command line before
>>>your match. Look at the TCPMSS or REJECT targets for examples for
>>>this.
>> 
>> That would mean I'd have to
>> 
>>   -p tcp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
>> lotsofothers -j TARGET
>>   -p udp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
>> lotsofothers -j TARGET
>
>I don't see any match that would depend on an other match in
>your example. How about your start explaining what you would
>like to do, ideally with some code.

Yup, on the spot!
http://jengelh.hopto.org/f/chaostables/chaostables-0.1.tar.bz2
(Contains a target, but still something that could use 
xt_request_find_module.)


	-`J'
-- 
