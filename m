From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 02:39:30 +0200
Message-ID: <20050621003930.GJ8335@postel.suug.ch>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net> <42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch> <20050621003441.GI8335@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <20050621003441.GI8335@postel.suug.ch>
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

* Thomas Graf <20050621003441.GI8335@postel.suug.ch> 2005-06-21 02:34
> ip_conntrack_untracked is put into the conntrack with a refcnt of 2
> (+1 during init and +1 while assigning it to nfct). Once the packet
> leaves the ip stack we release the first use, when the modules
> get unloaded we release the entry again and call destroy() on it
> resulting in a overall corruption.
> 
> The whole notrack thing seems to be a big hack. ;->

Almost forgot: the nf_reset() patch should "fix" this bug. "Fix"
because it doesn't really fix it but rather hides this issue
for a later possible revival.
