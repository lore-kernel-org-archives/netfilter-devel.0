From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 17:22:32 +0000
Message-ID: <4B4E0158.4050102@oracle.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bernd Eckenfels <be-mail2010@lina.inka.de>, Narendra_K@Dell.com,
	jengelh@medozas.de, shemminger@linux-foundation.org,
	netfilter-devel@vger.kernel.org, jgarzik@users.sourceforge.net,
	Charles_Rose@Dell.com, Matt_Domsch@Dell.com, Shyam_Iyer@Dell.com,
	Jordan_Hargrave@Dell.com, Sandeep_K_Shandilya@Dell.com
To: net-tools@lina.inka.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:31526 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab0AMR1Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:27:25 -0500
In-Reply-To: <20100113110425.GA5095@lina.inka.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13/01/10 11:04, Bernd Eckenfels wrote:
> Hello,
>
> On Wed, Jan 13, 2010 at 12:17:16PM +0530, Narendra_K@Dell.com wrote:
>    
>> The implementation is for char device node solution we proposed earlier.
>> It would be extended to handle the current proposal if it is acceptable.
>>      
> For the record: I still dont like the idea to add another namespace (besides
> interface index number and kernel names (possibly renamed)) to network
> devices (especially in usermode), however if nobody else objects I will keep
> quiet and accept the patches.
>    

I am less than enthusiastic about the idea as well.  I've come across 
numerous userspace scripts and whatnot that have enough trouble with the 
default route not being through "eth0" let alone anything more 
complex.   Aliases are going to cause a lot of problems for a lot of 
people for little actual gain.

jch
