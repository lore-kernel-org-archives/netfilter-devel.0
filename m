From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 07/10] nfnetlink_log: fix module reference
	counting
Date: Tue, 13 Feb 2007 13:48:03 +0100
Message-ID: <45D1B383.5060400@trash.net>
References: <20070212003956.GH8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212003956.GH8262@rere.qmqm.pl>
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
> Count module references correctly: after instance_destroy() there
> might be timer pending and holding a reference for this netlink instanc=
e.

I think we should just cancel the timer on destruction.
