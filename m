From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Wed, 22 Jun 2005 05:24:57 +0200
Message-ID: <42B8DA09.9080406@eurodev.net>
References: <42A6AB19.2040106@tac.ch> <42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
	<20050621003441.GI8335@postel.suug.ch>
	<42B76474.8080209@eurodev.net>
	<20050621111328.GK8335@postel.suug.ch> <42B81D75.8090205@trash.net>
	<20050621215027.GP8335@postel.suug.ch> <42B8B181.4020607@trash.net>
	<20050622005243.GQ8335@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050622005243.GQ8335@postel.suug.ch>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Thomas Graf wrote:
> * Patrick McHardy <42B8B181.4020607@trash.net> 2005-06-22 02:32
> 
>>Thomas Graf wrote:'
>>
>>>This patch seems fine but it cannot fix the bug. The fact that we
>>>trigger the BUG() implies a serious problem which is that we'd be
>>>calling destroy() on a conntrack entry which was never allocated.
>>
>>Sorry, I didn't follow the entire thread and there seem to be a lot
>>of BUG()s :) Which one exactly are you refering to?
> 
> 
> Roberto added the following to nf_conntrack_put():
> 
> if ((((long) nfct) & 0xf8000000) && atomic_read(&nfct->master->use) <= 1)
>         BUG();

I don't consider reliable such BUG() triggered since I see this as a 
tricky race condition. AFAICS, the skbuff still enqueued holds a pointer 
to an invalid address that doesn't store ip_conntrack_untracked anymore, 
instead it points to something different, say the .bss section of 
another module reloaded which isn't the ip_conntrack module. Roberto's 
recipe requires module removal and reload in a very short space of time 
and I can't assure that those modules are installed and removed in the 
same order.

--
Pablo
