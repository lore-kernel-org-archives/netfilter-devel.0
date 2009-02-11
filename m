From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 	entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults 	increase
 required?
Date: Wed, 11 Feb 2009 17:41:59 +0100
Message-ID: <4992FFD7.9090706@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>	 <498E3693.6030702@netfilter.org>	 <200902091556.25407.anton.vazir@gmail.com>	 <49901176.6020502@netfilter.org> <49928B62.1090600@netfilter.org> <c4b050a10902110426s5e997220r21d615ebf0683bb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36687 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754158AbZBKQmJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:42:09 -0500
In-Reply-To: <c4b050a10902110426s5e997220r21d615ebf0683bb8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton VG wrote:
> Pablo,
> 
> On 64bit system, after applying the patch, nfq_create_queue() started
> to oftenly return NULL, and calling
> strerror(errno) - I've got a error "Invalid or incomplete multibyte or
> wide character".
> 
> On 32bit it works. This have been tested with only 2x simultaneous queues
> Any thoughts?

Let me check this. Do you think that I can reproduce it with the test
file in libnetfilter_queue? If you can pass something similar to your
code to reproduce the problem, it would be great. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
