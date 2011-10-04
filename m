From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Packet statistics accounting module: request for comments
Date: Tue, 4 Oct 2011 13:02:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1110041256500.22180@frira.zrqbmnf.qr>
References: <CAFAca_CyLYGH+FyzyONsM7CiA6K3=BNdwY6PvTd+d1HEFKX6XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Julien Lafaye <jlafaye@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41030 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab1JDLCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Oct 2011 07:02:08 -0400
In-Reply-To: <CAFAca_CyLYGH+FyzyONsM7CiA6K3=BNdwY6PvTd+d1HEFKX6XQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-10-04 06:50, Julien Lafaye wrote:
>
>I created a small packet statistics accounting module based on the 
>xtables framework. It is based on a FIFO that is filled in netfilter 
>hooks and emptied by a user program reading statistics through /proc 
>callbacks. The goal of the module is to be able to get maximum traffic 
>rate with an improved resolution compared to basic techniques. Typical 
>expected resolution is 100ms.

I am thinking of how xt_quota2 (in grow mode) could have been enhanced 
to simply reset the counter when the procfs file is read. How would that 
have compared to your module?

>The code is currently stored in github: 
>https://github.com/jlafaye/xt_pktstat
>
>I would like the code to be considered for inclusion in the 
>xtables-addons framework. Nevertheless, the code might not be mature 
>enough as this is the first time I do kernel programming. Although 
>advised by knowledgeable persons, there are probably many issues in it.

The .c files need a little license-mentioning header at the least, and 
should in principle also use tab indents like LKCS.-See files from Xt-a 
for examples.
