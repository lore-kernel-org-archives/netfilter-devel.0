From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Re: netfilter (+/- kernel) crash ( in 2.4.23)
Date: Thu, 12 Feb 2004 17:22:38 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076586758.916.11.camel@vijay>
References: <019501c3f041$1520fdd0$5746370a@nsp.co.nz>
	 <1076482972.4101.16.camel@vijay> <000701c3f0d9$173032b0$5746370a@nsp.co.nz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: VeNoMouS <venom@gen-x.co.nz>
In-Reply-To: <000701c3f0d9$173032b0$5746370a@nsp.co.nz>
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

I would try that. I had actually tried testing on only one system, so
your point abt bad ram 'might' be valid.

But we've been having similar crashes on about 5 servers (each with
either 1 or 2 gigs of ram), on which memory utilisation too isn't high.
So I suspect memory corruption because of some module/part of the
kernel.

It's only on the lower config ( 500 MHz celeron with 128 MB of ram )
system that I am getting the oops for iptables through syslog. On the
production servers that are having this problem, the system just
silently crashes and has to be hard booted.

I am right now trying to test the setup without using conntracking and I
would try your suggestion after that and let you know.

Regards,
Vijaya Chandra Vupputuri,
Tachyon Technologies

On Thu, 2004-02-12 at 14:26, VeNoMouS wrote:
> compile it into the kernel rather then modular it uses more ram being
> modular and u may have some bad ram, plus it manages it much faster in the
> kernel rather then a module, try that and let me know how u go
> ----- Original Message ----- 
> From: "Vijaya Chandra Vupputuri" <vijay@tachyontech.net>
> To: "VeNoMouS" <venom@gen-x.co.nz>
> Sent: Wednesday, February 11, 2004 8:02 PM
> Subject: Re: netfilter (+/- kernel) crash with
> 
> 
> > On Wed, 2004-02-11 at 20:17, VeNoMouS wrote:
> > > is iptables moduluar??
> >
> > Hi,
> > Am not sure if I understood your query properly.
> >
> > However as can be seen in the listing of the modules loaded, 'ip_tables'
> > has been loaded as a module and wasn't built into the kernel, if this
> > was what you were asking.
> >
> > Module                  Size  Used by    Not tainted
> > ipt_quota               1696  23  (autoclean)
> > iptable_filter          2368   1  (autoclean)
> > ip_nat_ftp              3936   0  (unused)
> > ip_conntrack_ftp        5024   1  [ip_nat_ftp]
> > iptable_nat            21972   2  (autoclean) [ip_nat_ftp]
> > ip_conntrack           29396   2  (autoclean) [ip_nat_ftp
> > ip_conntrack_ftp iptable_nat]
> > ip_tables              14912   5  [ipt_quota iptable_filter iptable_nat]
> > 8139too                14496   2
> >
> >
> > Regards,
> > Vijaya Chandra Vupputuri,
> > Tachyon Technologies
