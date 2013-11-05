From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/3] android: Don't include conflicting headers
Date: Tue, 5 Nov 2013 14:02:48 +0100
Message-ID: <20131105130248.GA29037@localhost>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
 <1382813433-20890-3-git-send-email-cernekee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57121 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3KENC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:02:57 -0500
Content-Disposition: inline
In-Reply-To: <1382813433-20890-3-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Kevin,

On Sat, Oct 26, 2013 at 11:50:32AM -0700, Kevin Cernekee wrote:
> <netinet/ip.h> and <linux/ip.h> redefine a couple of structs, including
> iphdr.  Handle this the same way as on glibc, i.e. don't include
> <linux/ip.h>.
> 
> This change comes from AOSP.

No major objections to this 1/3 and 2/3, but I don't see this patch
here:

https://android.googlesource.com/platform/external/iptables/

Please, tell me if it's the right place to look at. Any plan to
include these patches to AOSP repositories?

Thanks.
