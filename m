From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: problems applying ipset patch
Date: Mon, 28 May 2007 22:03:54 +0200
Message-ID: <20070528200354.GA8360@outback.rfc2324.org>
References: <Pine.LNX.4.64.0705241544070.18888@blackhole.kfki.hu>
	<4655997E.7010407@gmail.com> <4655AEB6.5060004@gmail.com>
	<4655B3A8.10809@gmail.com>
	<Pine.LNX.4.64.0705251555200.21023@blackhole.kfki.hu>
	<4657147E.7040602@gmail.com>
	<1180149879.304.16.camel@henriknordstrom.net>
	<465A9A9C.2030304@gmail.com>
	<20070528124811.GA22826@outback.rfc2324.org>
	<465B036B.4080405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <465B036B.4080405@gmail.com>
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

Am Monday, den 28 May hub Andrea folgendes in die Tasten:

Hi!

> In the old .config there's CONFIG_IP_NF_NAT=m, instead in the new 
> .config there aren't neither CONFIG_IP_NF_NAT nor CONFIG_NF_NAT. I 
> thought that the "make oldconfig" had imported the full old kernel 
> configuration.

> So, I have do add this option and recompile again (argh!); and how can I 
> be sure that the oldconfig has not missed other entries again?

'make oldconfig' should ask you about new items.
In the past there were some Kconfig items added and renamed, so you
should be carefull if 'make oldconfig' asks you about things.

Ciao
Max
-- 
	Follow the white penguin.
