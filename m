From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: kernel crash
Date: 30 May 2003 12:53:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054291985.711.107.camel@tux.rsn.bth.se>
References: <3ED67067.6080605@eburg.com>
	 <1054247760.709.94.camel@tux.rsn.bth.se>  <3ED6DCC7.7020302@eburg.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gordon Messmer <yinyang@eburg.com>
In-Reply-To: <3ED6DCC7.7020302@eburg.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-05-30 at 06:23, Gordon Messmer wrote:
> Martin Josefsson wrote:
> > 
> > Beware that conntrack in kernel 2.4.20 has a serious bug caused by core
> > kernel changes. Can you please try 2.4.21-rc or apply at least
> > submitted/10_confirm_fix.patch from patch-o-matic and run the same thing
> > again and see if it still happens?
> 
> I've suggested the patch to the person responsible for the machine (I'm 
> just helping him track this down).

Ok.

> Possibly memory corruption, then?

Can very well be a real bug, There have been reports of the same thing
happening to UP machines running 2.4.21-rc kernels (which include the
patch mentioned above, but I still think your friend should apply it)

I'll see if I can cook up some form of debugging-patch for this, it
might help us track it down. Some way of reproducing it wouldn't hurt.

Does he still have the same problem if he removes ip_conntrack_ftp and
ip_nat_ftp ?

> > 
> > Which modules are you using?
> > 
> 
> According to Mark:
> 
> lsmod
> Module                  Size  Used by    Not tainted
> ipt_MARK                 856   1  (autoclean)
> ipt_LOG                 3320   1  (autoclean)
> ipt_limit               1048   1  (autoclean)
> ipt_REJECT              2840  13  (autoclean)
> ipt_mark                 536   1  (autoclean)
> iptable_mangle          2228   1  (autoclean)
> ip_nat_ftp              3696   0  (unused)
> ip_conntrack_ftp        4240   1  [ip_nat_ftp]
> ipt_state                632   0  (unused)
> ipt_multiport            728   0  (unused)
> ipt_esp                  632   0  (unused)
> ipt_MASQUERADE          1944   1
> iptable_filter          1736   1
> iptable_nat            21176   2  [ip_nat_ftp ipt_MASQUERADE]
> ip_conntrack           28064   3  [ip_nat_ftp ip_conntrack_ftp ipt_state
> 				ipt_MASQUERADE iptable_nat]
> ip_tables              13400  14  [ipt_MARK ipt_LOG ipt_limit ipt_REJECT
> 				ipt_mark iptable_mangle ipt_state
> 				ipt_multiport ipt_esp ipt_MASQUERADE
> 				iptable_filter iptable_nat]
> ip_gre                  7584   0  (unused)
> sk98lin               113136   1
> e1000                  47980   1
-- 
/Martin
