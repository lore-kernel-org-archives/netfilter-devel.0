From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: use _DEFAULT_SOURCE for newer glibc
Date: Wed, 19 Aug 2015 09:09:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508190908430.11093@nerf40.vanv.qr>
References: <1439935658-17834-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:51681 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbbHSHJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 03:09:33 -0400
In-Reply-To: <1439935658-17834-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2015-08-19 00:07, Mike Frysinger wrote:

>Since _BSD_SOURCE is deprecated with newer glibc versions, we get build
>warnings when using only that define.  Add the newer _DEFAULT_SOURCE to
>quiet things down.

Why do we even need _BSD_SOURCE/_ISOC99_SOURCE/_DEFAULT_SOURCE? The 
thing apparently builds without it (glibc-2.19), too.
