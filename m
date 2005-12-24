From: Patrick Schaaf <bof@bof.de>
Subject: Re: ipt_limit patch for iptables-1.3.1 and linux-2.4.22
Date: Sat, 24 Dec 2005 07:27:17 +0100
Message-ID: <20051224062717.GA11503@oknodo.bof.de>
References: <5210898791.20051223141249@uu3.net> <43ABFE4B.6040102@cineca.it>
	<3519928555.20051223164319@uu3.net>
	<43AC4F57.8090702@trash.net> <036110574.20051223211301@uu3.net>
	<20051223201951.GA28723@linuxace.com>
	<16937451772.20051223213523@uu3.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: borg@uu3.net
Content-Disposition: inline
In-Reply-To: <16937451772.20051223213523@uu3.net>
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

> Okey.. So you saying that my system is broken?

No.

The patch would break other people's systems who DONT consistently
patch kernel and userspace. Iptables developers have for years now
resisted to accept patches that behave that way, because they don't want
the "support hell" it creates. That's what people are telling you.
That's why your patch is considered "broken". In this case, "broken"
is a synonym for "not acceptable to our established way of changing
things".

best regards
  Patrick
