From: "Shipman, Jeffrey E" <jeshipm@sandia.gov>
Subject: RE: TCP/IP checksums and changing destination address
Date: Mon, 17 Jun 2002 07:38:00 -0600
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <03781128C7B74B4DBC27C55859C9D7380984063A@es06snlnt>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: "'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'Harald Welte'" <laforge@gnumonks.org>,
	"Shipman, Jeffrey E" <jeshipm@sandia.gov>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

No. I'm calculating the checksum as it leaves my
machine. I only have a hook for locally outgoing
packets. So, I'm calculating a correct checksum
for a correct packet that I've modified.

Thanks for those two files, though. I'll check
them out although I doubt it'll fix my problem.

Jeff Shipman - CCD
Sandia National Laboratories
(505) 844-1158 / MS-1372


-----Original Message-----
From: Harald Welte [mailto:laforge@gnumonks.org]
Sent: Saturday, June 15, 2002 6:58 AM
To: Shipman, Jeffrey E
Cc: 'netfilter-devel@lists.samba.org'
Subject: Re: TCP/IP checksums and changing destination address


On Fri, Jun 14, 2002 at 08:03:38AM -0600, Shipman, Jeffrey E wrote:
> I'm currently writing a netfilter module to modify
> some options in TCP packets. Currently, I'm just
> trying to learn a bit about it so I've written a
> module that 1) Sets the PSH flag in all TCP packets
> and 2) Modifies the destination address to be the
> source address.
> 
> I wrote a small function that uses tcp_v4_check()
> and ip_fast_csum() to recalculate the checksums
> on the packets. 

This is wrong. Just think of a packet arriving with broken checksum, and
then
you recalculate the checksum - passing on a broken packet with a valid
checksum. Please use incremental checksumming, as used by netfilter/iptables
all over the place (like in ipt_TOS.c, or ipt_TCPMSS.c)

> Jeff Shipman - CCD
> Sandia National Laboratories

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+ 
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)
