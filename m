From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: SVN ULOG2
Date: Wed, 09 Apr 2008 13:01:10 +0200
Message-ID: <47FCA1F6.2000204@netfilter.org>
References: <200804091520.28617.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58250 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753272AbYDILBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:01:18 -0400
In-Reply-To: <200804091520.28617.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> Hello!
> 
> A little question, regarding the current status of ULOGD2, 
> and could it be used in the live accounting? 
> Just trying to compile fresh SVN of ulog2 and noticed that 
> lots of dependencies to fresh versions of NF libraries, and 
> ULOG2 tries to compile MAC2STR, which does not exists in the 
> ULOGD2 sources tree, so I had to remove it from Makefile to 
> get it compiling.

I forgot to commit the MAC2STR file. Please, refresh you SVN tree.

> Maybe ULOGD2 still is in deep development and not ready to 
> any use yet?

As you said, it's under development but any help in testing and
bugreporting would be great.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
