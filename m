From: Patrick McHardy <kaber@trash.net>
Subject: Re: expectation mask handling in nfctnetlink (Was Re: [PATCH] fix
 nf_conntrack_netlink expectation dumping/event notification)
Date: Wed, 01 Feb 2006 12:04:02 +0100
Message-ID: <43E095A2.1040908@trash.net>
References: <200601130938.k0D9c6ud007984@toshiba.co.jp>	<43C78C3C.6080707@netfilter.org>	<200601151307.k0FD7evx014168@toshiba.co.jp>
	<200601200457.k0K4vvAI001787@toshiba.co.jp>
	<43E01851.4040306@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <43E01851.4040306@netfilter.org>
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

Pablo Neira Ayuso wrote:
> a) just remove the unlikely() statement.
> Drawback: Not so efficient, since that checking isn't always required.

I'm not sure I understand the problem. Is it about the unlikely in
__nf_ct_proto_find? That one is most likely not making any difference
at all, since there is no code to reorder.
