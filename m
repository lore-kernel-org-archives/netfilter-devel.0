From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] iptables and NO_SHARED_LIBS/dlfcn.h
Date: Wed, 19 Dec 2007 15:40:22 +0100
Message-ID: <47692D56.50305@trash.net>
References: <200712190715.46466.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53883 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXLSOkr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:40:47 -0500
In-Reply-To: <200712190715.46466.vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mike Frysinger wrote:
> if NO_SHARED_LIBS is defined, then iptables shouldnt even include dlfcn.h.
> otherwise you hit a build failure when using toolchains that do not provide
> dlfcn.h because they do not support shared objects.

Applied, thanks. With some luck Pablo hasn't started preparing the 1.4.0
release yet :)
