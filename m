From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: nftables/libnftables packages for Fedora
Date: Mon, 13 Jan 2014 09:54:22 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1401130953150.14789@nerf08.vanv.qr>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:55287 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaAMIyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:54:23 -0500
In-Reply-To: <20140112134024.2475a4f2@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2014-01-12 21:40, Kevin Fenzi wrote:
>
>1. Completely minor, but noted in review of both packages that the
>COPYING file has the old fsf address in it. Would be great if you could
>update to the new one. 
>https://fedoraproject.org/wiki/Common_Rpmlint_issues#incorrect-fsf-address

No, best remove the address, because you really don't want to be updating
all the time.

>3. nftables hard codes installing as root, which is no good for
>building packages (patch attached that just removes the owner/group
>setting there). 

Well I sent an automake-making patch that would fix all those problems,
but so far it has again been ignored to be merged.
