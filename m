From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] netfilter: nft: reject support for IPv6 and TCP
 reset
Date: Thu, 12 Dec 2013 09:14:49 +0100
Message-ID: <1386836089.6457.28.camel@ice-age2.regit.org>
References: <1386722554-4827-1-git-send-email-eric@regit.org>
	 <1386834281-28347-1-git-send-email-eric@regit.org>
	 <1386834281-28347-3-git-send-email-eric@regit.org>
	 <52A96BE2.2030906@linux.intel.com> <52A96C63.8070109@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56499 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3LLIOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:14:53 -0500
In-Reply-To: <52A96C63.8070109@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2013-12-12 at 09:57 +0200, Tomasz Bursztyka wrote:
> >> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> >
> > Isn't it NF_TABLES_IPV6 instead?
> >
> 
> I of course meant CONFIG_NF_TABLES_IPV6, sorry

Good point and this also means we have a issue in nf_reject.h where we
use CONFIG_IP6_NF_IPTABLES which is out-of-scope in nft_reject.

I'll try to fix that.

++
-- 
Eric Leblond <eric@regit.org>

