From: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>
Subject: RE: [Ebtables-devel] [PATCH 0/2] Add IPv6 support
Date: Tue, 26 Feb 2008 11:08:59 -0800
Message-ID: <3F25FE8C477E9E4FB3D42C2FF937C08A965060@orsmsx423.amr.corp.intel.com>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net><3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com><3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com><1201303354.2909.1.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CA7F@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802080126020.25157@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CB14@orsmsx423.amr.corp.intel.com><1202494854.2895.11.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A85D069@orsmsx423.amr.corp.intel.com><1202664082.2907.5.camel@localhost.localdomain> <3F25FE8C477E9E4FB3D42C2FF937C08A85D440@o
 rsmsx423.amr.corp.intel.com> <3F25FE8C477E9E4FB3D42C2FF937C08A897BDA@orsmsx423.amr.corp.intel.com> <Pine.LNX.4.64.0802120333400.29955@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Bart De Schuymer" <bdschuym@pandora.be>
To: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>,
	<ebtables-devel@lists.sourceforge.net>,
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYBZTJD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:09:03 -0500
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tseng, Kuo-Lang wrote on Monday, February 18, 2008 5:49 PM:

> According to
>
http://article.gmane.org/gmane.linux.network.bridge.ebtables.devel/719,
> I need to add required functions into userspace ebtables program and
> bridge-nf kernel module for parsing and matching on IPv6 header
> fields address, traffic class, IP protocol, and layer-4 port ids.    
> 
> Signed-off-by: Kuo-lang Tseng <kuo-lang.tseng@intel.com>

I haven't heard any feedback yet. Since these patches have been accepted
upstream, I suggest we can push the patch files into our tree (this will
be needed by va_nw_mgr for adding IPv6 support). 

The kernel patch (sent in [PATCH 2/2] mail]) needs to be applied into
linux-2.6.18-xen source. Is it the hg/xen/patches/linux-2.6.18 directory
that we should add the patch file into? Who can do this push? 

For userspace change, since I don't see ebtbales user space source in
our tree so I assume we only need to push in the excutable ebtables
which should be in /sbin in sos file system. 

