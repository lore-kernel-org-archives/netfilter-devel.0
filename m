From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: nfqueue library setup requires root
Date: Thu, 02 Feb 2012 22:52:40 +0100
Message-ID: <4F2B05A8.4030803@mutluit.com>
References: <20111229140019.23841ead@wwwwww-701SD> <4F29679F.6090704@mutluit.com> <20120202184905.GB5268@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59747 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab2BBVww (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:52:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Rt4aH-0003qC-Fg
	for netfilter-devel@vger.kernel.org; Thu, 02 Feb 2012 22:52:49 +0100
Received: from p4fe8b3b2.dip.t-dialin.net ([79.232.179.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2012 22:52:49 +0100
Received: from for-gmane by p4fe8b3b2.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2012 22:52:49 +0100
In-Reply-To: <20120202184905.GB5268@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote, On 02/02/12 19:49:
> On Wed, Feb 01, 2012 at 05:26:07PM +0100, U.Mutlu wrote:
>> abirvalg@lavabit.com wrote, On 12/29/11 15:00:
>>> Hi,
>>> I launched my application with CAP_NET_ADMIN capability, yet both nfq_unbind_pf and nfq_bind_pf produce an error.
>>> When I setuid(0) no error is produced and everything works as expected.
>>> Could you please confirm that Library setup operations require root.
>>> Isn't it a bit misleading that libnetfilter_queue docu states that CAP_NET_ADMIN is required without mentioning root permissions.
>>> Would it be possible to do Library Setup with only CAP_NET_ADMIN and without root priviliges in future versions?
>>
>> On a host node I didn't need CAP_NET_ADMIN when starting it as root
>> (ie. maybe on my system root already has that cap by default; would make sense).
>
> Yes, root is fine. You should also get it running with CAP_NET_ADMIN.
>
>> But on a VPS on the same host node I couldn't get it working yet.
>> It always gives errno=111 (ECONNREFUSED; "Connection refused").
>
> This has nothing to do with permissions (in that case you'll hit
> -EPERM).

So then why does it bring ECONNREFUSED in the VM,
but works fine on the host node?

>> Does yours work in a virtual machine, ie. on a VPS ?
>
> By "virtual machine" you mean one linux container (lxc)?

Yes, exactly. Have you tested it in such a container like LXC or openvz?

