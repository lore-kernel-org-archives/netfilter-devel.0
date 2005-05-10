From: Patrick McHardy <kaber@trash.net>
Subject: Netfilter socket hooks (was: Re: Status of owner-socketlookup)
Date: Tue, 10 May 2005 17:59:13 +0200
Message-ID: <4280DA51.8090201@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <426FE9DD.80201@trash.net>
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

Patrick McHardy wrote:
> I think what it comes down to is that we can filter in socket
> context, but the only useable attributes in both input- and
> output-path for owner-matching are
> sk->sk_socket->file->f_{uid,gid}. This should still be enough
> for many usage cases (and for mine), so I'm going to finish the
> patch.

Here is a first shot at socket hooks. Nothing uses them yet,
and at least two things are still missing:

- conntrack reference should not be dropped before socket hooks
- conntrack should be confirmed in socket hooks

Comments?
