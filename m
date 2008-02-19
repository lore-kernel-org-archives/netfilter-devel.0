From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [Ebtables-devel] [PATCH 0/2] Add IPv6 support
Date: Tue, 19 Feb 2008 18:46:59 +0100
Message-ID: <1203443219.2896.2.camel@localhost.localdomain>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com>
	 <1201303354.2909.1.camel@localhost.localdomain>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com>
	 <Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A85CA7F@orsmsx423.amr.corp.intel.com>
	 <Pine.LNX.4.64.0802080126020.25157@fbirervta.pbzchgretzou.qr>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A85CB14@orsmsx423.amr.corp.intel.com>
	 <1202494854.2895.11.camel@localhost.localdomain>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A85D069@orsmsx423.amr.corp.intel.com>
	 <1202664082.2907.5.camel@localhost.localdomain>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A85D440@orsmsx423.amr.corp.intel.com>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A897BDA@orsmsx423.amr.corp.intel.com>
	 <Pine.LNX.4.64.0802120333400.29955@fbirervta.pbzchgretzou.qr>
	 <3F25FE8C477E9E4FB3D42C2FF937C08A8D0909@orsmsx423.amr.corp.intel.com>
	 <47BAEFC5.30702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>,
	ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from harold.telenet-ops.be ([195.130.133.65]:54922 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYBSRq6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:46:58 -0500
In-Reply-To: <47BAEFC5.30702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op di, 19-02-2008 te 16:03 +0100, schreef Patrick McHardy:
> Tseng, Kuo-Lang wrote:
> > According to
> > http://article.gmane.org/gmane.linux.network.bridge.ebtables.devel/719,
> > I need to add required functions into userspace ebtables program and
> > bridge-nf kernel module for parsing and matching on IPv6 header fields
> > address, traffic class, IP protocol, and layer-4 port ids. 
> > 
> > Signed-off-by: Kuo-lang Tseng <kuo-lang.tseng@intel.com>
> 
> 
> I'll queue this for 2.6.26 if Bart is fine with these patches.

I received this with lines split around 80 characters. Kuo, please
repost with an attachment or fix your mailer...

cheers,
Bart


