From: marian stagarescu <marian@ti.com>
Subject: rmmod ip_conntrack hangs ...?
Date: 03 Apr 2003 12:23:17 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049390597.3172.80.camel@gt4rvnd11.telogy.design.ti.com>
References: <20030403135757.GB1702@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20030403135757.GB1702@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i get occasional rmmod ip_conntrack hanging and never returns

is this a known/old/resolved issue ?
i run on 2.4.17 pached up with newnat13 ...

# lsmod 
Module                  Size  Used by
ip_nat_talk             3128   0 (unused)
ip_conntrack_talk       2940   2
ip_nat_tftp             2312   0 (unused)
ip_conntrack_tftp       2236   1
ip_nat_irc              3272   0 (unused)
ip_conntrack_irc        3868   1
ip_nat_h323             3376   0 (unused)
ip_conntrack_h323       3100   1
ip_nat_ftp              4088   0 (unused)
ip_conntrack_ftp        5036   1
ipt_multiport           1004   0 (unused)
ipt_REDIRECT            1076   0 (unused)
ipt_limit               1388   0 (unused)
ipt_LOG                 4412   0 (unused)
ipt_state                952   0 (unused)
ipt_MASQUERADE          1716   0 (unused)
iptable_nat            23192   6 [ip_nat_talk ip_nat_tftp ip_nat_irc
ip_nat_h323 ip_nat_ftp ipt_REDIRECT i
pt_MASQUERADE]
iptable_filter          2124   0 (unused)
ip_conntrack           30080   8 [ip_nat_talk ip_conntrack_talk
ip_nat_tftp ip_conntrack_tftp ip_nat_irc i
p_conntrack_irc ip_nat_h323 ip_conntrack_h323 ip_nat_ftp
ip_conntrack_ftp ipt_REDIRECT ipt_state ipt_MASQU
ERADE iptable_nat]
ip_tables              14688  10 [ipt_multiport ipt_REDIRECT ipt_limit
ipt_LOG ipt_state ipt_MASQUERADE ip
table_nat iptable_filter]


and after:

# /sbin/lsmod 
Module                  Size  Used by
ip_conntrack           30080   0 (deleted)
ip_tables              14688   0



On Thu, 2003-04-03 at 08:57, netfilter@interlinx.bc.ca wrote:
> On Thu, Apr 03, 2003 at 12:15:43PM +0200, Martin Josefsson wrote:
> > 
> > Thanks for the report, I'll try to fix it up.
> 
> Excellent!
> 
> > The answer is that I don't have time to check all the time if
> everything
> > still applies after new stuff has been added to pom.
> 
> No, of course not.  My appologies if that is how my message came
> across.  My question was more a case of, "should I report when this
> happens or is it to be expected with so many patches to be applied"
> (kinda like maintaining a kernel these days :-).
> 
> You are welcome for the report in any case however.
> 
> Thanx for the great work!
> 
> b.
> 
> -- 
> Brian J. Murrell
