From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNETLINK answers: No such file or directory
Date: Thu, 19 Jun 2008 16:03:48 +0200
Message-ID: <485A6744.9060607@netfilter.org>
References: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>	 <485A3E81.5070100@netfilter.org> <7b0a40830806190650g6ccacd5br3bc3c9088c73dd2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Adelson O. Junior" <jroliv@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52549 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbYFSOEC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:04:02 -0400
In-Reply-To: <7b0a40830806190650g6ccacd5br3bc3c9088c73dd2c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adelson O. Junior wrote:
> Hi, thanks for reply
> 
> I'm using the versions:
> 
> libnfnetlink-0.0.25-1
> libnetfilter_conntrack-0.0.50-2
> conntrack-1.0-0.1.beta2
> 
> We have an application Java based that uses this tools, and uses these versions.
> I need to know which of this packets is causing the problem, and which
> version is fixing it, before a apply new versions on the Java App.
> There are any place thats show the problems fixed in each version?

Yes, you can look for the changes on Netfilter's git [1] and the
website. However, those versions are from the caveman era and the amount
of changes is cumbersome. I strongly recommend you to upgrade. Make sure
you use a Linux kernel version >= 2.6.18.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
