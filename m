From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: iptables freeze
Date: Wed, 07 Jul 2004 13:06:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089198419.2599.28.camel@nienna.balabit>
References: <20040706224021.GU32707@sunbeam2>
	 <1089192566.2599.5.camel@nienna.balabit>
	 <38713.83.103.143.1.1089194587.squirrel@83.103.143.1>
	 <1089195093.2599.23.camel@nienna.balabit>
	 <46146.193.231.247.183.1089198052.squirrel@193.231.247.183>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: arny <arny@arny.ro>
In-Reply-To: <46146.193.231.247.183.1089198052.squirrel@193.231.247.183>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-07-07, sze keltezéssel 13:00-kor arny ezt írta:
> Yes, i have transparent proxy on that server, i have 2 LAN`s, eth1 1 with
> 30 computers, and the second LAN eth2 with ~300 computers. All HTTP trafic
> from lans are redirected to the eth1 IP port 3128 and eth2 port 3128.
> 
> Here are the modules:
> arny@gw:~$ lsmod
> Module                  Size  Used by
> ipt_mac                 3712  4
> ipt_REJECT              7936  5
> ipt_REDIRECT            3968  2
> iptable_mangle          4608  1
> iptable_nat            33956  2 ipt_REDIRECT
> iptable_filter          4608  1
> ip_tables              22672  6
> ipt_mac,ipt_REJECT,ipt_REDIRECT,iptable_mangle,iptable_nat,iptable_filter

  Ok, thanks for the information. Do you know of any kernel version
which did not have this problem?

-- 
 Regards,
   Krisztian KOVACS
