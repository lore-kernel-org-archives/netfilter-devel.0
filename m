From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] arptables: build an libarptc.a archive
Date: Fri, 22 Feb 2013 09:50:23 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302220950030.1652@nerf07.vanv.qr>
References: <1361490336-4676-1-git-send-email-jonh.wendell@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Jonh Wendell <jonh.wendell@oiwifi.com.br>
To: Jonh Wendell <jonh.wendell@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37778 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3BVIu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:50:27 -0500
In-Reply-To: <1361490336-4676-1-git-send-email-jonh.wendell@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2013-02-22 00:45, Jonh Wendell wrote:

>From: Jonh Wendell <jonh.wendell@oiwifi.com.br>
>
>this allows programs to statically link against libarptc.

A shared library, should anyone ever wish to develop against arptc 
(which I doubt), is much preferable.
