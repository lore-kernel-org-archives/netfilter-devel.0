From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Security: Add iptables security table for mandatory
 access control rules
Date: Wed, 21 May 2008 19:22:04 +0200
Message-ID: <48345A3C.1080407@trash.net>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au> <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46834 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936442AbYEURWI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 13:22:08 -0400
In-Reply-To: <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James Morris wrote:
> The following patch implements a new "security" table for iptables, so
> that MAC (SELinux etc.) networking rules can be managed separately to
> standard DAC rules.
> 
> This is to help with distro integration of the new secmark-based
> network controls, per various previous discussions.
> 
> The need for a separate table arises from the fact that existing tools
> and usage of iptables will likely clash with centralized MAC policy
> management.
> 
> The SECMARK and CONNSECMARK targets will still be valid in the mangle
> table to prevent breakage of existing users.
> 
> Signed-off-by: James Morris <jmorris@namei.org>


Applied, thanks. I'll add the dependency myself in case you agree.

