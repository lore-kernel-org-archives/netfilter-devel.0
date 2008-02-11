From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Ebtables plans
Date: Mon, 11 Feb 2008 21:57:41 +0100
Message-ID: <1202763461.2893.8.camel@localhost.localdomain>
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
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>,
	ebtables-devel@lists.sourceforge.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:51660 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYBKU6d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:58:33 -0500
Received: from nelson.telenet-ops.be (unknown [195.130.133.66])
	by yergi.telenet-ops.be (Postfix) with ESMTP id E0BDC5CAA96
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Feb 2008 21:58:21 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0802090141050.26116@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op za, 09-02-2008 te 01:49 +0100, schreef Jan Engelhardt:
> Time to unveil some plans.
> 
> I am not sure where exactly I picked the idea up, probably in one of the
> last discussions on netfilter-devel, to make ebtables use xtables code.
> Well, I am in the process of writing up a bunch of patches to get us
> closer to that. Nothing spectacularly interesting for modules (ebt_*.c),
> 
> but at the same time I have to give a worry about the userspace code.
> ebtables and arptables have not gotten the same attention as iptables
> and look a bit disheveled. Eventually I would just merge them with the
> iptables tree so it also shares all the option parsing and whatnot.

Arptables was a hack from the start. Ebtables is completely different
code and is not portable with a few simple patches. Thanks for pointing
out your opinion about the code though, it really helps.

> It would be most convenient to use a better VCS (thinking git) because
> running quilt on top of svn or even cvs (ebtables) is not too nice,
> even more if the changeset agglomeration is then lost in cvs.
> While Patrick still seems to be AWOL for an opinion, I would want to
> know from all parties (iptables, ebtables) if we can take this
> management step.

Once ebtables or arptables is in a state so that it can be merged with
the rest of netfilter I'm fine with it residing wherever the netfilter
core team wants.
I'm not going to go change the versioning system at this stage just so
it's a bit more convenient for you. Use whatever versioning tool you
want on your local checked out version.

cheers,
Bart


