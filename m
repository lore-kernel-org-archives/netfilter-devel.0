From: Patrick McHardy <kaber@trash.net>
Subject: Re: status of netfilter+ipsec patches
Date: Mon, 28 Mar 2005 21:49:38 +0200
Message-ID: <42485FD2.3020508@trash.net>
References: <42289633.6020804@sysgo.com> <424853B8.9090607@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <424853B8.9090607@shorewall.net>
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

Tom Eastep wrote:
> I second this question -- I'm giving a presentation about Shorewall and
> IPSEC next month at Linuxfest Northwest and I'd like to be able to give
> the audience the current status of the patches.

Read last weeks netdev archive, turns out the whole idea of skipping
netfilter hooks until all IPsec processing is done was wrong. I don't
know how to solve it yet.

Regards
Patrick
