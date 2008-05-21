From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/2] Security: Add iptables security table for mandatory
 access control rules
Date: Thu, 22 May 2008 08:44:34 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0805220843571.8393@us.intercode.com.au>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
 <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au> <48345A3C.1080407@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:38835 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755471AbYEUWop (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 18:44:45 -0400
In-Reply-To: <48345A3C.1080407@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 21 May 2008, Patrick McHardy wrote:

> Applied, thanks. I'll add the dependency myself in case you agree.

Ok, I can't really see a use for the table without CONFIG_SECURITY, so 
please go ahead.


- James
-- 
James Morris
<jmorris@namei.org>
