From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Ebtables plans
Date: Sat, 16 Feb 2008 23:49:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802112230450.7915@fbirervta.pbzchgretzou.qr>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net>
  <3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com>
 <3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com>
 <1201303354.2909.1.camel@localhost.localdomain>
 <3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com>
 <Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr>
 <3F25FE8C477E9E4FB3D42C2FF937C08A85CA7F@orsmsx423.amr.corp.intel.com>
 <Pine.LNX.4.64.0802080126020.25157@fbirervta.pbzchgretzou.qr>
 <3F25FE8C477E9E4FB3D42C2FF937C08A85CB14@orsmsx423.amr.corp.intel.com>
 <1202494854.2895.11.camel@localhost.localdomain>
 <Pine.LNX.4.64.0802090141050.26116@fbirervta.pbzchgretzou.qr>
 <1202763461.2893.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>,
	ebtables-devel@lists.sourceforge.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35961 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYBPWti (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Feb 2008 17:49:38 -0500
In-Reply-To: <1202763461.2893.8.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 11 2008 21:57, Bart De Schuymer wrote:
>Op za, 09-02-2008 te 01:49 +0100, schreef Jan Engelhardt:
>> Time to unveil some plans.
>> 
>> I am not sure where exactly I picked the idea up, probably in one of the
>> last discussions on netfilter-devel, to make ebtables use xtables code.
>> Well, I am in the process of writing up a bunch of patches to get us
>> closer to that. Nothing spectacularly interesting for modules (ebt_*.c),
>> 
>> but at the same time I have to give a worry about the userspace code.
>> ebtables and arptables have not gotten the same attention as iptables
>> and look a bit disheveled. Eventually I would just merge them with the
>> iptables tree so it also shares all the option parsing and whatnot.
>
>Arptables was a hack from the start.

Mh, I particularly like it for one reason: you do not need to make a
half-bridge (a bridge with one port) out of an interface just to do
ARP filtering. Unfortunately, but I hope to change that, arpreply is
only available with a bridge right now.

>Ebtables is completely different
>code and is not portable with a few simple patches.

I noticed. A flag day will most likely be needed to get it into shape, 
but it still looking promising.

Only annoyance so far was ebt_among which uses a dynamic match size, but 
other than that it seems that I have successfully converted the 
kernel-side ebtables to use x_tables.

>Thanks for pointing
>out your opinion about the code though, it really helps.
>

>I'm not going to go change the versioning system at this stage just so
>it's a bit more convenient for you. Use whatever versioning tool you
>want on your local checked out version.

Right, I have started a blank git without caring about history for now.
