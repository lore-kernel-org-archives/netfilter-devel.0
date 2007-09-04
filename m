From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Tue, 4 Sep 2007 11:39:34 +0200
Message-ID: <20070904093934.GP18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<20070903100943.GH18480@postel.suug.ch>
	<46DCBEFF.5070509@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DCBEFF.5070509@snapgear.com>
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

* Philip Craig <philipc@snapgear.com> 2007-09-04 12:12
> Yes it would be nice to only do it for subsystems that need it.
> The only place I can see in the existing arguments for nla_parse()
> is to overload the meaning of the unused policy[0]. The other options
> are to change nla_parse() or add nla_parse_masked(). Any preference?

Actually after discussing this with Patrick a bit I think we can safely
assume that this bit is never set in any other subsystem so just leave
it as-is.
