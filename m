From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: nfqueue library setup requires root
Date: Wed, 01 Feb 2012 17:26:07 +0100
Message-ID: <4F29679F.6090704@mutluit.com>
References: <20111229140019.23841ead@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: abirvalg@lavabit.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51640 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab2BAQ01 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:26:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Rsd0m-00040s-Q5
	for netfilter-devel@vger.kernel.org; Wed, 01 Feb 2012 17:26:20 +0100
Received: from p4fe8a3ee.dip.t-dialin.net ([79.232.163.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Feb 2012 17:26:20 +0100
Received: from for-gmane by p4fe8a3ee.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Feb 2012 17:26:20 +0100
In-Reply-To: <20111229140019.23841ead@wwwwww-701SD>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

abirvalg@lavabit.com wrote, On 12/29/11 15:00:
> Hi,
> I launched my application with CAP_NET_ADMIN capability, yet both nfq_unbind_pf and nfq_bind_pf produce an error.
> When I setuid(0) no error is produced and everything works as expected.
> Could you please confirm that Library setup operations require root.
> Isn't it a bit misleading that libnetfilter_queue docu states that CAP_NET_ADMIN is required without mentioning root permissions.
> Would it be possible to do Library Setup with only CAP_NET_ADMIN and without root priviliges in future versions?

On a host node I didn't need CAP_NET_ADMIN when starting it as root
(ie. maybe on my system root already has that cap by default; would make sense).

But on a VPS on the same host node I couldn't get it working yet.
It always gives errno=111 (ECONNREFUSED; "Connection refused").

Does yours work in a virtual machine, ie. on a VPS ?

