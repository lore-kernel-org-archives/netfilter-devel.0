From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 05/10] nfnetlink_log: micro-optimization
 for	inst==NULL in nfulnl_recv_config()
Date: Tue, 13 Feb 2007 13:47:38 +0100
Message-ID: <45D1B36A.9080000@trash.net>
References: <20070212003928.GF8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212003928.GF8262@rere.qmqm.pl>
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

Micha=C2=B3 Miros=C2=B3aw wrote:
> Simple micro-optimization: don't call instance_put() on known NULL poin=
ters.

Applied.
