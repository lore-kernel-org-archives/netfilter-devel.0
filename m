From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] autotools conversion: include the header 'config.h' in
 every C source file.
Date: Sat, 12 Jul 2014 11:09:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1407121105170.12026@nerf08.vanv.qr>
References: <20140710125245.GA10007@macbook.localnet> <1405001313-12902-1-git-send-email-giorgio.nicole@arcor.de> <20140710145426.GA23419@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:35466 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaGLJJH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jul 2014 05:09:07 -0400
In-Reply-To: <20140710145426.GA23419@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2014-07-10 16:54, Pablo Neira Ayuso wrote:
>On Thu, Jul 10, 2014 at 04:08:08PM +0200, Giorgio Dal Molin wrote:
>> Added an #include <config.h> to all the C source files so that the results
>> of the tests in the configure script are available to all the compilation
>> units.
>
>I think we can avoid this by passing the configuration options to the
>compiler via -D instead of via config.h file.
>
>https://www.gnu.org/software/autoconf/manual/autoconf-2.65/html_node/Configuration-Headers.html
>
>Any reason not to do it that way?

The compiler command line is already long enough (when choosing to
look at it via `make V=1`) for human analysis, and distros easily add
even more CFLAGS like -O,-f,-m into it. Not using config.h would make
the situation worse for analysis by human.
