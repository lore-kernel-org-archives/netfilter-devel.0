From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ipt_unclean-ubit.patch
Date: Tue, 22 Oct 2002 16:28:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022142830.GE3039@naboo.club.berlin.ccc.de>
References: <20021015100916.GD672@morinfr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Guillaume Morin <guillaume@morinfr.org>
Content-Disposition: inline
In-Reply-To: <20021015100916.GD672@morinfr.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 15, 2002 at 12:09:16PM +0200, Guillaume Morin wrote:
> Hi Harald,
> 
Hi Guillaume.

Sorry for the late reply, but I was travelling during the last week and
stuff tends to get delayed...

> I'd like to know if you plan to send to David ipt_unclean-ubit.patch. I
> think it would be an useful addition to the unclean module since some
> scan papers recommend using this field.

I have had a look at the patch, and I'm going to submit it for kernel
inclusion.

It is too late for being included in 2.4.20, since it is not really a
bug fix but rather an extension to an experimental iptables match.

> Regards,

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
