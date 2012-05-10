From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Thu, 10 May 2012 12:39:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36497 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405Ab2EJKjD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 06:39:03 -0400
In-Reply-To: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-05-10 12:18, Jozsef Kadlecsik wrote:

>I'm happy to announce ipset 6.12. This release contains a few important 
>bugfixes, dynamic module support in the ipset tool by Neutron Soutmun
>and several backports and compatibility fixes.

There is no configure script in the current 6.12 tarball,
i.e. autogen has not been run before packing up.
