From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Re: 2.4.25 crash with conntrack msgs in the kernel log
Date: Thu, 04 Mar 2004 18:11:11 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078404070.25999.11.camel@vijay>
References: <1078250798.957.58.camel@vijay>
	 <1078402938.773.38.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1078402938.773.38.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Excuse me for not including details about the modules.
On the system with 2.4.25, all the modules had been into the kernel and
typically the following would be the ones used

Module                  Size  Used by    Not tainted
ip_nat_ftp              3808   0  (unused)
ipt_quota               1632 566  (autoclean)
cls_u32                 5700   2  (autoclean)
sch_htb                20672   2  (autoclean)
ipt_REDIRECT            1472  17  (autoclean)
ipt_mport               1344   1  (autoclean)
ipt_state               1216   2  (autoclean)
iptable_nat            21236   2  (autoclean) [ip_nat_ftp ipt_REDIRECT]
iptable_filter          2432   1  (autoclean)
ip_tables              14368   8  [ipt_quota ipt_REDIRECT ipt_mport
ipt_state iptable_nat iptable_filter]
ip_conntrack_ftp        4928   1 
ip_conntrack           27188   3  [ip_nat_ftp ipt_REDIRECT ipt_state
iptable_nat ip_conntrack_ftp]
eepro100               20652   2 
mii                     3800   0  [eepro100]

This is a listing from a system with 2.4.23 where the modules were not
built into the kernel.

Actually when the systems had ext3 as the filesystem, the kernel used to
cry out loud saying BUG in checkpoint.c. Included are bzipped copies of
some of the outputs from ksymoops. It's only with ext3 that we have any
msgs in the kernel logs and with ext2 and reiserfs, the system crashes
silently with junk in whatever log files are being written to (/that are
in use).

Regards,
Vijaya Chandra Vupputuri,
Tachyon Technologies.

On Thu, 2004-03-04 at 17:52, KOVACS Krisztian wrote:
>   Hi,
> 
> On Tue, 2004-03-02 at 19:08, Vijaya Chandra Vupputuri wrote:
> > The system acts as the gateway for around 500 active users, with around
> > 1000 rules in the forward chain and around 400 chains, each of these
> > chains with one rule (using the 'ipt_quota' match), in the filter table
> > and around 1500 rules in the 'nat' table, HTB, being the one used for
> > shaping bandwidth.
> 
>   What conntrack/NAT helpers do you use? Which modules are loaded in the
> kernel?
