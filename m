From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!)
	in	ipt_limit
Date: Mon, 21 Nov 2005 15:38:34 +0100
Message-ID: <4381DBEA.6030103@eurodev.net>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>	<20051017143053.GA29010@pc-innocenti.cineca.it>	<4353BFFB.7070406@trash.net>	<20051020090100.GA23412@pc-innocenti.cineca.it>
	<4381D94A.8080404@cineca.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "m.innocenti@cineca.it" <m.innocenti@cineca.it>
In-Reply-To: <4381D94A.8080404@cineca.it>
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

m.innocenti@cineca.it wrote:
> There is something else I have to do to make the patch to add support
> for invert in ipt_limit being applied?

Wait until someone realises that it's there. Otherwise you could resend
it. About your patch, I must confess that I don't like too much the idea
of adding new versions of targets/matches for such small modifications,
but we have no other choice to implement that new feature.

-- 
Pablo
