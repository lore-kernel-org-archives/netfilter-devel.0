From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 11/14] nfnetlink_log: iterator functions need	iter_state
 * only
Date: Tue, 13 Feb 2007 13:51:58 +0100
Message-ID: <45D1B46E.9030701@trash.net>
References: <20070212003738.GA8262@rere.qmqm.pl>	<20070212202052.GA28704@rere.qmqm.pl> <20070212202200.GB28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750706AbXBMMwE@vger.kernel.org>
In-Reply-To: <20070212202200.GB28704@rere.qmqm.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Micha=C2=B3 Miros=C2=B3aw wrote:
> get_*() don't need access to seq_file - iter_state is enough for them=
=2E

Applied, thanks.
