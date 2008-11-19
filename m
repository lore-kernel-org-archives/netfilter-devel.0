From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: ip{,6}t_policy.h should include xp_policy.h
Date: Wed, 19 Nov 2008 19:08:17 +0100
Message-ID: <49245611.1080905@trash.net>
References: <1227111682-14073-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Andy Whitcroft <apw@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36639 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYKSSIY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:08:24 -0500
In-Reply-To: <1227111682-14073-1-git-send-email-apw@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andy Whitcroft wrote:
> It seems that all of the include/netfilter_{ipv4,ipv6}/{ipt,ip6t}_*.h which
> share constants include the corresponding include/netfilter/xp_*.h files.
> Neither ipt_policy.h not ip6t_policy.h do.  Make these consistant with
> the norm.

Does this actually fix a bug, or is it just for added consistency?
