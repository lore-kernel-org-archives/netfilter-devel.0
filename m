From: Harald Welte <laforge@sunbeam.franken.de>
Subject: Re: ip_conntrack_lock not readlocked
Date: Tue, 2 Jul 2002 18:02:05 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702160205.GQ18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <3D21B499.141D270C@isd.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Albrecht Melan <melan@isd.uni-stuttgart.de>
Content-Disposition: inline
In-Reply-To: <3D21B499.141D270C@isd.uni-stuttgart.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 02, 2002 at 04:11:37PM +0200, Albrecht Melan wrote:
> Hi,
> 
>  I'm using a kernel of version 2.4.18 where module-support is disabled
> together with iptables-1.2.6a ( all compiled by myself).
>  I applied patches to netfilter  using POM.

which patches?

>  The following messages are seen in  my log-file
>         ASSERT: ip_nat_core.c: 743 &ip_conntrack_lock not readlocked
>         ASSERT:ip_conntrack_core.c: 973 &ip_conntrack_lock readlocked

how often do you see them? Do they have always the same  line number?
Could you send me a grep on all 'ASSERT:' entries in your syslog?

What kind of machine are you running?

>  Thanks for your help
>      Albrecht

-- 
Live long and prosper
- Harald Welte / laforge@sunbeam.franken.de    http://www.sunbeam.franken.de
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
