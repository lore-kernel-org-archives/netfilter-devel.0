From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH]: Keep the "state" match as alias [Re: state match is
 obsolete 1.4.17]
Date: Fri, 18 Jan 2013 01:28:18 +0100
Message-ID: <20130118002818.GA19003@1984>
References: <CAMD-=V+PhM3NLpWyxB0G4KUN6D+-XKL0PZCBAuyUXUw56gmuJw@mail.gmail.com>
 <alpine.LNX.2.01.1301150958390.16853@nerf07.vanv.qr>
 <50F5273F.5020205@inliniac.net>
 <alpine.DEB.2.00.1301151102490.11129@blackhole.kfki.hu>
 <alpine.LNX.2.01.1301151342440.19279@nerf07.vanv.qr>
 <alpine.DEB.2.00.1301151406540.11172@blackhole.kfki.hu>
 <alpine.LNX.2.01.1301151444250.20224@nerf07.vanv.qr>
 <alpine.DEB.2.00.1301151534360.11172@blackhole.kfki.hu>
 <alpine.DEB.2.00.1301151820230.12091@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>,
	Victor Julien <lists@inliniac.net>,
	Nick Edwards <nick.z.edwards@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3ARA2W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:28:22 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301151820230.12091@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, Jan 15, 2013 at 06:28:11PM +0100, Jozsef Kadlecsik wrote:
> On Tue, 15 Jan 2013, Jozsef Kadlecsik wrote:
> 
> > With passing one more internal flag, indicating that the "state" alias is 
> > used, the "conntrack" module can remain completely hidden and the user can 
> > list/save exactly the same command as the issued one.
> 
> Here follows the patch which introduces match module aliases (the same can 
> be done for targets as well). The alias is handled as it were a real 
> extension while it's actually handled by another module. Listing/saving 
> keeps the alias name and options.
> 
> The "state" extension is the first example of such an alias.

I like this symmetrical aliasing approach.

The aim is to get rid of redundant things in the kernel. And with
this, we can get that without disturbing users.

Would you do the same for the NOTRACK target?

Thanks.
