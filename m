From: Gordon Messmer <yinyang@eburg.com>
Subject: Re: kernel crash
Date: Thu, 29 May 2003 21:23:35 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED6DCC7.7020302@eburg.com>
References: <3ED67067.6080605@eburg.com>
 <1054247760.709.94.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <1054247760.709.94.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:
> 
> Beware that conntrack in kernel 2.4.20 has a serious bug caused by core
> kernel changes. Can you please try 2.4.21-rc or apply at least
> submitted/10_confirm_fix.patch from patch-o-matic and run the same thing
> again and see if it still happens?

I've suggested the patch to the person responsible for the machine (I'm 
just helping him track this down).

> It appears that as if the reply-tuple is modified after the conntrack
> has been added to the hashtable (shouldn't happen). The only place this
> modification could happen is in ip_conntrack_alter_reply() which is
> called from ip_nat_setup_info() which in turn is called from various
> places to set up NAT mappings. But I can't find a place where it's
> called for a connection that's already in the hashtable...
> And the IP_NF_ASSERT() in ip_conntrack_alter_reply() would have
> triggered unless the conntrack had already been deleted from the
> lists...

Possibly memory corruption, then?

> 
> Which modules are you using?
> 

According to Mark:

lsmod
Module                  Size  Used by    Not tainted
ipt_MARK                 856   1  (autoclean)
ipt_LOG                 3320   1  (autoclean)
ipt_limit               1048   1  (autoclean)
ipt_REJECT              2840  13  (autoclean)
ipt_mark                 536   1  (autoclean)
iptable_mangle          2228   1  (autoclean)
ip_nat_ftp              3696   0  (unused)
ip_conntrack_ftp        4240   1  [ip_nat_ftp]
ipt_state                632   0  (unused)
ipt_multiport            728   0  (unused)
ipt_esp                  632   0  (unused)
ipt_MASQUERADE          1944   1
iptable_filter          1736   1
iptable_nat            21176   2  [ip_nat_ftp ipt_MASQUERADE]
ip_conntrack           28064   3  [ip_nat_ftp ip_conntrack_ftp ipt_state
				ipt_MASQUERADE iptable_nat]
ip_tables              13400  14  [ipt_MARK ipt_LOG ipt_limit ipt_REJECT
				ipt_mark iptable_mangle ipt_state
				ipt_multiport ipt_esp ipt_MASQUERADE
				iptable_filter iptable_nat]
ip_gre                  7584   0  (unused)
sk98lin               113136   1
e1000                  47980   1
