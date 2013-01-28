From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/8] extensions: S/DNPT: add missing save function
Date: Mon, 28 Jan 2013 12:36:46 +0100
Message-ID: <20130128113646.GC15781@1984>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
 <1359056278-27618-6-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41157 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab3A1LhG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:37:06 -0500
Content-Disposition: inline
In-Reply-To: <1359056278-27618-6-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 24, 2013 at 08:37:55PM +0100, Jan Engelhardt wrote:
> Jean-Michel DILLY reports that `ip6tables -S` exits with
> 
> 	Target `DNPT' is missing save function
> 
> when a DNPT rule is invoked. Fix this omission.

I have applied this to -stable.
