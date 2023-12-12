Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AFBAB
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2023 17:09:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rCrH6-0004IY-3z
	for netfilter-devel@vger.kernel.org; Tue, 12 Dec 2023 02:09:28 +0100
Date: Tue, 12 Dec 2023 02:09:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Should we keep the advice to increase queue max length?
Message-ID: <20231212010928.GA16434@breakpoint.cc>
References: <ZXetLVAKMug1YvL3@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXetLVAKMug1YvL3@slk15.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> /proc/net/netfilter/nfnetlink_queue has a line for every active queue. The 3rd
> field is the number of queued packets. The max length is not in these lines but
> kernel source suggests it is 1024 by default. Anyway, I updated nfq6 to be able
> to set the max (using mnl functions).
> 
> And I found the maximum number of queued packets is: 238. Further packets are
> dropped.
> 
> If I lower the max below 238, limiting occurs at the new max.
> 
> So I propose to drop the advice to increase the queue max length when I revise
> the libnetfilter_queue main page as part of the project to stop using
> libnfnetlink.
> 
> Anyone have any comments?

This code is very old, it stems from a time where the network stack
did not do any kind of packet aggregation.

I think the hint should be removed as you suggest.
