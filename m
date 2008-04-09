From: Thomas Mader <thezema@gmail.com>
Subject: Re: libnetfilter_queue and libnetfilter_conntrack API questions
Date: Wed, 09 Apr 2008 18:00:19 +0200
Message-ID: <47FCE813.3040907@gmail.com>
References: <47FCCD6C.6050409@gmail.com> <47FCD6AA.8030205@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:20357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYDIQA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:00:27 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2383640fgb.17
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2008 09:00:22 -0700 (PDT)
In-Reply-To: <47FCD6AA.8030205@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> I'd prefer polling from both sockets instead of using threads, you can
> access the socket descriptors via nfct_fd() and nfq_fd().
> 
> Anyway, the main problem that I see is that you'll have to delay the
> packet verdict until you receive the conntrack event, otherwise you risk
> to have a race condition. However, I think that the solution would not
> be that performant.

Would it be better if I just spawn another thread with a timer which 
looks at intervals if a connection in my list has to be deleted? This 
way I would not need conntrack at all and it might be the fastest solution.

Btw. I did a throughput test on the kernelspace module and the userspace 
daemon without conntrack (so no deletion of connections in my list). I 
figured out that the kernelspace module had less throughput than my 
daemon and I didn't had a good explanation for this.
Is it possible that my conntrack solution in kernelspace is lowering the 
performance below the performance in userspace without conntrack?
