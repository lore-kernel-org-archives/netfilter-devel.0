From: Philip Craig <philipc@snapgear.com>
Subject: Re: new target - ebtables dynamic snat, kernel and userspace patch
Date: Fri, 25 Sep 2009 11:04:17 +1000
Message-ID: <4ABC1711.6050004@snapgear.com>
References: <4ABB2336.6040806@storwize.com> <alpine.LSU.2.00.0909241011400.13479@obet.zrqbmnf.qr> <4ABB2E30.8080107@storwize.com> <4ABB5773.4080500@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Shai Tahar <shait@storwize.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, bdschuym@pandora.be,
	shai.tahar@storwize.com
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:51599 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178AbZIYBIE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:08:04 -0400
In-Reply-To: <4ABB5773.4080500@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Amos Jeffries wrote:
> Shai Tahar wrote:
>> in case you manipulate the data in the connection, such as in tproxy 
>> scenario (squid etc')
>> a new connection goes out (with the same tuple) but the mac address is 
>> diffrent (the source mac is the device interface)
>>
>> assuming A,B,C are mac address and 1,2,3 are ip address
>>
>> [user]<--->[transparent bridge]<--->[server]
>> A1 B2 C3
>>
> 
> Your next steps misunderstand how MAC addresses work. MAC changes at 
> each physical NIC card plugged into the cable.

Not necessarily, and not for a bridge.  That's why bridges put the
NIC in promiscuous mode.

> Corrections follow...
> 
>> user initiates a connection A1--->C3
> 
> Correction:
>   user initiates query A1---->?3
>   network responds  ===> go to 3 via B
>   user initiates connection A1--->B3

That's how proxy arp works, not bridging.  A bridge knows nothing
about IP, it just forwards packets unmodified to the destination
MAC address.

