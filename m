From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: new target - ebtables dynamic snat, kernel and userspace patch
Date: Thu, 24 Sep 2009 23:26:43 +1200
Message-ID: <4ABB5773.4080500@treenet.co.nz>
References: <4ABB2336.6040806@storwize.com> <alpine.LSU.2.00.0909241011400.13479@obet.zrqbmnf.qr> <4ABB2E30.8080107@storwize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, bdschuym@pandora.be,
	shai.tahar@storwize.com
To: Shai Tahar <shait@storwize.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:49429
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZIXL0w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:26:52 -0400
In-Reply-To: <4ABB2E30.8080107@storwize.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shai Tahar wrote:
> in case you manipulate the data in the connection, such as in tproxy 
> scenario (squid etc')
> a new connection goes out (with the same tuple) but the mac address is 
> diffrent (the source mac is the device interface)
> 
> assuming A,B,C are mac address and 1,2,3 are ip address
> 
> [user]<--->[transparent bridge]<--->[server]
> A1 B2 C3
> 

Your next steps misunderstand how MAC addresses work. MAC changes at 
each physical NIC card plugged into the cable.

Corrections follow...

> user initiates a connection A1--->C3

Correction:
  user initiates query A1---->?3
  network responds  ===> go to 3 via B
  user initiates connection A1--->B3


> the connection is redirected into B2,

Correction:
    the connection succeeds.
    packets get forwarded

NORMAL OPERATION:
    B2 relays packets to C3...
    server sends reply packets C3--->B1

   B2 proceeds to shuffle packets like so
    out A1-->B3::B1-->C3
    and back C3-->B1::B3-->A1

> the connection is terminated as a 
> socket to a local application on the traparent bridge machine.

YOUR SCENARIO OPERATION:

   B2 relays packets to local app.

   local app initiates query B1---->?3
   network responds  ===> go to 3 via C
   local app initiates connection B1--->C3


   B2 proceeds to shuffle packets like so
    out A1-->B3:local-app:B1-->C3
    and back  C3-->B1:local-app:B3-->A1


As you can see there is no difference between normal correct MAC 
operation and the existing tproxy scenario as viewed by C3 and A1.


AYJ

> 
> a new connection goes out from B2, masked as B1--->C3 (the target 
> changes B1 into A1)
> in return, the server answers A1 C3--->A1, the connection is redirected 
> into the localhost
> the data then forwarded to the user B3--->A1 (the target changes B3 int C3)
> 
> Shai Tahar
> Storwize
> 
> Jan Engelhardt wrote:
>> On Thursday 2009-09-24 09:43, Shai Tahar wrote:
>>
>>  
>>> ---- README ---
>>> ebt_dyn_snat - ebtable dynamic snat
>>>    Authors:
>>>      Shai Tahar <shai.tahar@storwize.com>
>>>
>>>    Changes source mac address according to source ip address based on 
>>> local
>>> arp table
>>>    to be used when source ip address is snated
>>>
>>> Copyright (C) 2009 Storwize
>>>
>>> ebtables target for transparent bridge
>>> [user]<--->[transparent bridge]<--->[server]
>>>
>>> if the transparent bridge maskes user ip address towards the server,
>>> the bridge normally would replace the source mac address
>>>     
>>
>> Well, if you want to have the client's original MAC address in the
>> packet, do not SNAT it. It (seems) as simple as that.
>>   

Even better, plug the client machine directly into the server NIC.

Amos
-- 
Please be using
   Current Stable Squid 2.7.STABLE7 or 3.0.STABLE19
   Current Beta Squid 3.1.0.13
