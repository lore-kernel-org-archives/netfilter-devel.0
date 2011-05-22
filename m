From: Thomas Graf <tgraf@redhat.com>
Subject: Re: [PATCH] xt_AUDIT.c: remove ipv6 dependencies
Date: Sun, 22 May 2011 13:58:07 +0200
Message-ID: <1306065487.4840.133.camel@lsx>
References: <4DD83EB4.5040800@googlemail.com>
	 <1306057384.12435.5.camel@edumazet-laptop> <1306058500.4840.130.camel@lsx>
	 <4DD8F713.1020902@googlemail.com>
Reply-To: tgraf@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab1EVL6f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 May 2011 07:58:35 -0400
In-Reply-To: <4DD8F713.1020902@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2011-05-22 at 12:44 +0100, Mr Dash Four wrote: 
> >> Its not clear why you beliebe this patch is needed.
> >>
> >> I have a kernel without IPV6, and xt_AUDIT compiles fine here, it even
> >> loads properly.
> >>     
> >
> > The patch is not required. The protocol definitions and header parsing
> > functions are available even if IPv6 is not selected.
> >   
> I had errors when I tried to compile it in (I do not have ipv6 at all), 
> hence I introduced the latest patch - with that patch everything 
> compiles and runs without problems.

Could you provide the config combination which results in the compile
errors?

