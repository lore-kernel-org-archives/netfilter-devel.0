From: Philip Craig <philipc@snapgear.com>
Subject: Re: Trouble with PPTP
Date: Fri, 17 Oct 2003 09:46:39 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8F2DDF.6070806@snapgear.com>
References: <000c01c39322$c9fbcf40$01d2a8c0@adm.ae.wroc.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrzej Kozak <kozak@manager.ae.wroc.pl>
In-Reply-To: <000c01c39322$c9fbcf40$01d2a8c0@adm.ae.wroc.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Andrzej Kozak wrote:
> Hello!
> When I patched my 2.4.22 kernel with pptp-conntrack-nat -DNAT and -SNAT is broken if I use iptables with -t nat
> I get message: iptables: Invalid argument
> Iptables v. 1.2.8

 From pptp-conntrack-nat.patch.help:
- you have to recompile your iptables userspace program since some
   structure sizes change

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
