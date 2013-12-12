From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 2/2] netfilter: nft: reject support for IPv6 and TCP reset
Date: Thu, 12 Dec 2013 09:55:14 +0200
Message-ID: <52A96BE2.2030906@linux.intel.com>
References: <1386722554-4827-1-git-send-email-eric@regit.org> <1386834281-28347-1-git-send-email-eric@regit.org> <1386834281-28347-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3LLHzR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:55:17 -0500
In-Reply-To: <1386834281-28347-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)

Isn't it NF_TABLES_IPV6 instead?


Tomasz
