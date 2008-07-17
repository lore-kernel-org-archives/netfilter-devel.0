From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/2] Security: Add iptables security table for mandatory
 access control rules
Date: Thu, 17 Jul 2008 13:41:10 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0807171340360.17859@us.intercode.com.au>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
 <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au> <48345A3C.1080407@trash.net>
 <Xine.LNX.4.64.0805220843571.8393@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:49084 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752767AbYGQDlX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:41:23 -0400
In-Reply-To: <Xine.LNX.4.64.0805220843571.8393@us.intercode.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 22 May 2008, James Morris wrote:

> On Wed, 21 May 2008, Patrick McHardy wrote:
> 
> > Applied, thanks. I'll add the dependency myself in case you agree.
> 
> Ok, I can't really see a use for the table without CONFIG_SECURITY, so 
> please go ahead.

Patrick,

Do you intend to push this into 2.6.27 ?

(It would be appreciated).


- James
-- 
James Morris
<jmorris@namei.org>
