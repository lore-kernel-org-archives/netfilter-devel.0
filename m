From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 00/19] netfilter: IPv6 NAT
Date: Thu, 09 Aug 2012 13:56:32 -0700
Message-ID: <87a9y3n5rz.fsf@xmission.com>
References: <1344542943-11588-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:34808 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2HIU5G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:57:06 -0400
In-Reply-To: <1344542943-11588-1-git-send-email-kaber@trash.net>
	(kaber@trash.net's message of "Thu, 9 Aug 2012 22:08:44 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kaber@trash.net writes:

> The following patches contain an updated version of IPv6 NAT against
> Linus' current tree.
>
> The series is organized as follows:
>
> - Patches 01-03 contain bugfixes for SIP helper bugs/regressions
>   present in the current kernel

Why not just delete this code?  The current best practices are to
disable ALGs for SIP.  To the point in some circles people recommend
running SIP over TLS to avoid over helpful NAT ALGs.

Eric
