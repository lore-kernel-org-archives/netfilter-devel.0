From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 14:43:26 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001131439330.31436@obet.zrqbmnf.qr>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <4B4DC997.20306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Narendra K <Narendra_K@dell.com>, shemminger@linux-foundation.org,
	be-mail2009@lina.inka.de, net-tools@lina.inka.de,
	netfilter-devel@vger.kernel.org, jgarzik@users.sourceforge.net,
	charles_rose@dell.com, matt_domsch@dell.com, shyam_iyer@dell.com,
	jordan_hargrave@dell.com, sandeep_k_shandilya@dell.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56657 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0AMNn1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:43:27 -0500
In-Reply-To: <4B4DC997.20306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-01-13 14:24, Patrick McHardy wrote:
>> 
>> The proposal is to enhance iptables (and other tools which might fail if
>> integrated port 1 does not get named as eth0) to support something like
>[...]
>> +	strcpy(vianame, kernel_name);
>> +	int vialen = strlen(kernel_name);
>>  	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
>>  		memset(mask, 0, IFNAMSIZ);
>>  	else if (vianame[vialen - 1] == '+') {
>> 
>> 
>> where kernel_name is the ethN name that will be returned by a library
>> like libnetdevname which will map the user supplied "Embedded_NIC_1"
>> name to the corresponding ethN name, thus bringing in determinism while
>> referring to the network interfaces.
>> 
>> Netfilter-devel, would this be acceptable ?
>
>What I don't like very much is that you can't decide whether to
>map the interface names back in order to display a rule the same
>way it was specified. Anyone looking at the output will have to
>know the alias mapping, which seems to defeat the purpose of
>this patch.

By definition, the mapping from aliases to real names is not
bijective, thus not always unambiguously reversible. That also means
there will be problems if either side of a mapping disappears - say,
across a reboot - you are in for some local DoS. That of course also
holds for regular network interface names, but only if you do not use
udev to give them a persistent name.
