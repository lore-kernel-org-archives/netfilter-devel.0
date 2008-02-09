From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Ebtables plans
Date: Sat, 9 Feb 2008 01:49:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802090141050.26116@fbirervta.pbzchgretzou.qr>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>,
	ebtables-devel@lists.sourceforge.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38142 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbYBIAtu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:49:50 -0500
In-Reply-To: <1202494854.2895.11.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 8 2008 19:20, Bart De Schuymer wrote:
>Hi Kuo,
>
>Thanks for your patch. The patch looks ok. Tiny comment: the header
>diffs belong in the kernel patch and the userspace patch lacks a man
>page update.
>Seems like we'll need a merge of the two kernel patches and extra
>userspace code.
>
>I was gonna give my say about posting to netfilter-devel only, without
>userspace code, but I guess I'm better off restraining myself from doing
>that.

Time to unveil some plans.

I am not sure where exactly I picked the idea up, probably in one of the
last discussions on netfilter-devel, to make ebtables use xtables code.
Well, I am in the process of writing up a bunch of patches to get us
closer to that. Nothing spectacularly interesting for modules (ebt_*.c),

but at the same time I have to give a worry about the userspace code.
ebtables and arptables have not gotten the same attention as iptables
and look a bit disheveled. Eventually I would just merge them with the
iptables tree so it also shares all the option parsing and whatnot.

It would be most convenient to use a better VCS (thinking git) because
running quilt on top of svn or even cvs (ebtables) is not too nice,
even more if the changeset agglomeration is then lost in cvs.
While Patrick still seems to be AWOL for an opinion, I would want to
know from all parties (iptables, ebtables) if we can take this
management step.
