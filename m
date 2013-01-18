From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Build fixes for old Linuxes
Date: Fri, 18 Jan 2013 01:44:55 +0100
Message-ID: <20130118004455.GA20537@1984>
References: <1358274002-6042-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40033 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3ARApA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:45:00 -0500
Content-Disposition: inline
In-Reply-To: <1358274002-6042-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 15, 2013 at 07:20:00PM +0100, Jan Engelhardt wrote:
> 
> With this, iptables-1.4.17a (current git state) is tested to compile
> and, to the degree covered by this patchset, to function under
> Linux 2.4.27/glibc-2.3.2/Debian-3.1.
> 
> ===
> The following changes since commit 983196ceb4d3bb7b6d3cf6da18bb6d5a5eafb347:
> 
>   doc: document the -4 and -6 options (2013-01-07 02:26:16 +0100)
> 
> are available in the git repository at:
> 
>   git://git.inai.de/iptables old-linux
> 
> for you to fetch changes up to 1071ec54e6d7af406fe34afea1ce2c3e49ee1914:
> 
>   parser: workaround glibc-2.3.2 bug 358 (2013-01-15 19:16:55 +0100)
> 
> ----------------------------------------------------------------
> Jan Engelhardt (2):
>       build: fix libiptc build failure on old linux-glibc-devel headers
>       parser: workaround glibc-2.3.2 bug 358

Helping users is a noble thing from your side. However, that glibc
branch [1] and that debian release [2] are not maintained anymore.

[1] http://sourceware.org/glibc/wiki/Release
[2] http://www.debian.org/releases/sarge/

Sorry, I'm not taking this.
