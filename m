From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: problems applying ipset patch
Date: Mon, 28 May 2007 14:48:11 +0200
Message-ID: <20070528124811.GA22826@outback.rfc2324.org>
References: <Pine.LNX.4.64.0705241321370.18888@blackhole.kfki.hu>
	<46559618.8040708@gmail.com>
	<Pine.LNX.4.64.0705241544070.18888@blackhole.kfki.hu>
	<4655997E.7010407@gmail.com> <4655AEB6.5060004@gmail.com>
	<4655B3A8.10809@gmail.com>
	<Pine.LNX.4.64.0705251555200.21023@blackhole.kfki.hu>
	<4657147E.7040602@gmail.com>
	<1180149879.304.16.camel@henriknordstrom.net>
	<465A9A9C.2030304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <465A9A9C.2030304@gmail.com>
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

[...]
> - iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE ===>

> iptables v1.3.7: can't initialize iptables table `nat': Table does not 
> exist (do you need to insmod?)
> Perhaps iptables or your kernel needs to be upgraded.

> At this point I think the problem is in some missing settings in the 
> kernel conf

I guess, that you do not have the 'CONFIG_NF_NAT' option activated?
So your kernel will also lack the 'CONFIG_IP_NF_TARGET_MASQUERADE'
option.

If you use the "old" layer 3 depended conntrack, you need
'CONFIG_IP_NF_NAT' instead of 'CONFIG_NF_NAT'.

You can check this looking in "menuconfig" at:
 Networking
  -> Networking options
   -> Network packet filtering framework (Netfilter)
    -> Core Netfilter Configuration
     -> Netfilter connection tracking support

HTH
Ciao
Max
-- 
	Follow the white penguin.
