From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/3] build: rename conflicting parser.h instances
Date: Wed, 20 Nov 2013 10:06:39 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1311201002440.24243@nerf07.vanv.qr>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de> <1382280491-9921-3-git-send-email-jengelh@inai.de> <20131119202534.GB4929@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:44087 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab3KTJGl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:06:41 -0500
In-Reply-To: <20131119202534.GB4929@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2013-11-19 21:25, Pablo Neira Ayuso wrote:

>On Sun, Oct 20, 2013 at 04:48:10PM +0200, Jan Engelhardt wrote:
>> If -I. is on the command line, #include <parser.h> becomes ./parser.h
>> instead of ../include/parser.h.
>
>What use case are you trying to handle with this?
>
automake adds -I${builddir} -I${srcdir} and -I{dir with config.h} to the 
command line. Because both ${builddir} and -I${top_srcdir}/include 
(which is also being passed, this time by Makefile.am), #include 
<parser.h> becomes sort of ambiguous (the compiler knows which one to 
pick, but it's not the one to success).
