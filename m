From: Patrick McHardy <kaber@trash.net>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 11:06:21 +0100
Message-ID: <49C2191D.1060807@trash.net>
References: <49C202EA.40006@trash.net> <alpine.LSU.2.00.0903191057280.25879@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64348 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZCSKGZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:06:25 -0400
In-Reply-To: <alpine.LSU.2.00.0903191057280.25879@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-03-19 09:31, Patrick McHardy wrote:
> 
>> I've planned to release the next iptables version sometime (late)
>> this weekend. We've had quite a lot of changes since the last
>> version, please test the latest version from git and report any
>> issues.
> 
>     libxtables: add -I/-L flags to pkgconfig files
>     
>     These are needed in case iptables gets installed into a non-standard
>     path. It also enables automatic detection of these locations from 3rd
>     party programs via pkgconfig.
> 
> 
> Patch pullable from  git://dev.medozas.de/iptables master

Pulled, thanks Jan.
