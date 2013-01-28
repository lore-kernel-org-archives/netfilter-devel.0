From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 8/8] build: fix libiptc build failure on old
 linux-glibc-devel headers
Date: Mon, 28 Jan 2013 12:41:10 +0100
Message-ID: <20130128114110.GE15781@1984>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
 <1359056278-27618-9-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42486 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab3A1LlP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:41:15 -0500
Content-Disposition: inline
In-Reply-To: <1359056278-27618-9-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 24, 2013 at 08:37:58PM +0100, Jan Engelhardt wrote:
> On Linux 2.4.x systems, where /usr/include/linux generally contain
> unsanitized headers, compilation of libiptc fails with
> 
> 	  CC       libip4tc.lo
> 	In file included from libip4tc.c:113:
> 	libiptc.c:93: error: field `list' has incomplete type
> 
> This is because /usr/include/linux/list.h still existed at that time,
> but has all its definitions stashed in __KERNEL__. Switching
> linux_list.h's guards to another name resolves the problem.

We'll have no more releases of 2.4:

http://lwn.net/Articles/491245/

It's been announced several times that it has entered EOL.
