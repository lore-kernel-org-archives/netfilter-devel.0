From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 13:18:58 +0200
Message-ID: <20050621111858.GL8335@postel.suug.ch>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net> <42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch> <20050621003441.GI8335@postel.suug.ch>
	<20050621003930.GJ8335@postel.suug.ch> <42B7B7D8.1050204@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42B7B7D8.1050204@tac.ch>
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

* Roberto Nibali <42B7B7D8.1050204@tac.ch> 2005-06-21 08:46
> > Almost forgot: the nf_reset() patch should "fix" this bug. "Fix"
> > because it doesn't really fix it but rather hides this issue
> > for a later possible revival.
> 
> I thought so, however is there a clean fix which does not involve rewriting the
> raw patch? I mean the unconditional nf_reset() is rather intrusive. What about
> other netfilter extensions, they could have the same refcnt problem, couldn't they?

I suggest to introduce a flag to mark undestroyable conntrack
entries just like we declared qdisc->handle == 0 to be default
qdiscs which may never be destroyed. A new status flag might
do it but I'm simply not familiar enough with the netfilter
code to propose any specific fixes.
