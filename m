From: Thomas Graf <tgraf@redhat.com>
Subject: Re: [PATCH] xt_AUDIT.c: remove ipv6 dependencies
Date: Sun, 22 May 2011 12:01:40 +0200
Message-ID: <1306058500.4840.130.camel@lsx>
References: <4DD83EB4.5040800@googlemail.com>
	 <1306057384.12435.5.camel@edumazet-laptop>
Reply-To: tgraf@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1EVKBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 May 2011 06:01:48 -0400
In-Reply-To: <1306057384.12435.5.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2011-05-22 at 11:43 +0200, Eric Dumazet wrote: 
> Its not clear why you beliebe this patch is needed.
> 
> I have a kernel without IPV6, and xt_AUDIT compiles fine here, it even
> loads properly.

The patch is not required. The protocol definitions and header parsing
functions are available even if IPv6 is not selected.


