From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix a range check in netfilter IP NAT for SNMP
Date: Wed, 09 Jul 2008 18:34:34 +0200
Message-ID: <4874E89A.9080608@trash.net>
References: <20080709115317.13290.93539.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, netfilter-devel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32925 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYGIQef (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:34:35 -0400
In-Reply-To: <20080709115317.13290.93539.stgit@warthog.procyon.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Howells wrote:
> Fix a range check in netfilter IP NAT for SNMP to always use a big enough size
> variable that the compiler won't moan about comparing it to ULONG_MAX/8 on a
> 64-bit platform.

Applied, thanks.
