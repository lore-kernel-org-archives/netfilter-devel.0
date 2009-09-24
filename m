From: Shai Tahar <shait@storwize.com>
Subject: Re: new target - ebtables dynamic snat, kernel and userspace patch
Date: Thu, 24 Sep 2009 11:30:40 +0300
Message-ID: <4ABB2E30.8080107@storwize.com>
References: <4ABB2336.6040806@storwize.com> <alpine.LSU.2.00.0909241011400.13479@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be,
	shai.tahar@storwize.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bzq-179-166-116.static.bezeqint.net ([212.179.166.116]:17352
	"EHLO stmail.storwiz.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbZIXIak (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:30:40 -0400
In-Reply-To: <alpine.LSU.2.00.0909241011400.13479@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

in case you manipulate the data in the connection, such as in tproxy 
scenario (squid etc')
a new connection goes out (with the same tuple) but the mac address is 
diffrent (the source mac is the device interface)

assuming A,B,C are mac address and 1,2,3 are ip address

[user]<--->[transparent bridge]<--->[server]
A1 B2 C3

user initiates a connection A1--->C3
the connection is redirected into B2, the connection is terminated as a 
socket to a local application on the traparent bridge machine.

a new connection goes out from B2, masked as B1--->C3 (the target 
changes B1 into A1)
in return, the server answers A1 C3--->A1, the connection is redirected 
into the localhost
the data then forwarded to the user B3--->A1 (the target changes B3 int C3)

Shai Tahar
Storwize

Jan Engelhardt wrote:
> On Thursday 2009-09-24 09:43, Shai Tahar wrote:
>
>   
>> ---- README ---
>> ebt_dyn_snat - ebtable dynamic snat
>>    Authors:
>>      Shai Tahar <shai.tahar@storwize.com>
>>
>>    Changes source mac address according to source ip address based on local
>> arp table
>>    to be used when source ip address is snated
>>
>> Copyright (C) 2009 Storwize
>>
>> ebtables target for transparent bridge
>> [user]<--->[transparent bridge]<--->[server]
>>
>> if the transparent bridge maskes user ip address towards the server,
>> the bridge normally would replace the source mac address
>>     
>
> Well, if you want to have the client's original MAC address in the
> packet, do not SNAT it. It (seems) as simple as that.
>   

