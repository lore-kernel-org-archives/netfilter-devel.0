From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: iproute2: use automake
Date: Mon, 15 Nov 2010 14:26:00 -0800
Message-ID: <20101115142600.66a7e3c3@nehalam>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: stephen.hemminger@vyatta.com, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:54745 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624Ab0KOW0I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:26:08 -0500
In-Reply-To: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 15 Nov 2010 23:23:02 +0100
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> The following changes since commit 3f5c1a01e6bc15593635705aa0b19dcac965be26:
> 
>   Update to 2.6.36 headers (2010-10-20 17:38:04 -0700)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iproute2 master
> 
> Jan Engelhardt (2):
>       Fix up permissions on scripts
>       build: start using Automake for building

NAK. I agree with Alexey, automake is an abomination.


-- 
