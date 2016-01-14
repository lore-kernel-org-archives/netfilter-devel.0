From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [xtables-addons] Problem with compilation
Date: Thu, 14 Jan 2016 19:06:48 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1601141906150.22594@nerf40.vanv.qr>
References: <38301452784663@web4g.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Romaneev Vasily <entervuz@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:43124 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbcANSGu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2016 13:06:50 -0500
In-Reply-To: <38301452784663@web4g.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2016-01-14 16:17, Romaneev Vasily wrote:

>Hello!
>I try to compile xtables-addons-2.10 and latest snapshot from git on Centos 7.2, kernel version is 3.10.0-327.3.1.el7.x86_64
>and both build are failed.

Redhat Enterprise  kernels have an incompatible API and are not 
supported.
