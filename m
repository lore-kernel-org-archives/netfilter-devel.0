From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 08:46:48 +0200
Message-ID: <42B7B7D8.1050204@tac.ch>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net> <42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch> <20050621003441.GI8335@postel.suug.ch>
	<20050621003930.GJ8335@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050621003930.GJ8335@postel.suug.ch>
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

> Almost forgot: the nf_reset() patch should "fix" this bug. "Fix"
> because it doesn't really fix it but rather hides this issue
> for a later possible revival.

I thought so, however is there a clean fix which does not involve rewriting the
raw patch? I mean the unconditional nf_reset() is rather intrusive. What about
other netfilter extensions, they could have the same refcnt problem, couldn't they?

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
