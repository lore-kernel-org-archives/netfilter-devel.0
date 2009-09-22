From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] Fix NAT issue in 2.6.30.4+
Date: Tue, 22 Sep 2009 17:34:09 +0200
Message-ID: <200909221734.09452.thomas.jarosch@intra2net.com>
References: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu> <alpine.DEB.2.00.0909171319040.5343@blackhole.kfki.hu> <4AB21C77.1010306@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:41080 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZIVPeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:34:09 -0400
In-Reply-To: <4AB21C77.1010306@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 17. September 2009 13:24:39 Patrick McHardy wrote:
> I double checked and it looks fine, apart from the minor reject.
> I'll give it some testing myself before pushing upstream.

Just a short side note: I extracted the patch from your git tree and voila, 
it solves a passive FTP NAT issue with stuck connections using 2.6.30.6.

The patch runs stable on our main internet gateway for two days, too.

Cheers,
Thomas

