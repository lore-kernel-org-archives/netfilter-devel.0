From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: "#ifndef __KERNEL" ??
Date: Mon, 18 Feb 2008 00:58:09 +0100
Message-ID: <47B8CA11.2020801@netfilter.org>
References: <alpine.LFD.1.00.0802171225390.7957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52673 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755294AbYBQX6R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:58:17 -0500
In-Reply-To: <alpine.LFD.1.00.0802171225390.7957@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Robert P. J. Day wrote:
>   this doesn't look right:
> 
> .../include/linux/netfilter/nfnetlink_compat.h:
> ...
> #ifndef __KERNEL
> ...

Indeed. I'll cook a patch for this and pass it to Patrick.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
