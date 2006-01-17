From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: x_tables userspace
Date: Tue, 17 Jan 2006 11:06:13 +0900 (JST)
Message-ID: <20060117.110613.11374495.yoshfuji@linux-ipv6.org>
References: <43CB93C4.4060500@eurodev.net>
	<Pine.LNX.4.64.0601161422590.387@bizon.gios.gov.pl>
	<333e1ca10601161208r6593dcd0kc40b1b8322477dcf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: michal.rokos@gmail.com
In-Reply-To: <333e1ca10601161208r6593dcd0kc40b1b8322477dcf@mail.gmail.com>
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

In article <333e1ca10601161208r6593dcd0kc40b1b8322477dcf@mail.gmail.com> (at Mon, 16 Jan 2006 21:08:40 +0100), Michal Rokos <michal.rokos@gmail.com> says:

> PS: Have your progs that read /proc/net/if_inet6 stopped working too?
> In recent git kernels I have:
> $ cat /proc/net/if_inet6
> fe80:0000:0000:0000:0214:a5ff:fe27:9306 03 40 20 80    wlan0
> 0000:0000:0000:0000:0000:0000:0000:0001 01 80 10 80       lo
> but before it was:
> $ cat /proc/net/if_inet6
> fe800000000000000214a5fffe279306 03 40 20 80    wlan0
> 00000000000000000000000000000001 01 80 10 80       lo
> and the result is that nothing can handle ip6 now (postfix, ifconfig, etc)

Patch already available to fix the format.
People should be more careful about API....  sigh...

--yoshfuji
