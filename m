From: Harald Welte <laforge@gnumonks.org>
Subject: Re: priority of MANGLE and NAT tables
Date: Wed, 10 Jul 2002 11:16:03 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020710091603.GO23676@naboo.de.gnumonks.org>
References: <20020710080036.GA9220@napri.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Peter Kundrat <kundrat@kundrat.sk>
Content-Disposition: inline
In-Reply-To: <20020710080036.GA9220@napri.sk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 10, 2002 at 10:00:36AM +0200, Peter Kundrat wrote:

> before rewriting dst addr/port), and there is no mangle hook in POSTROUTING
> (which would help, since it would be before SNAT).

yes, there is. You must be using a relatively old kernel verison. Think
this changed around 2.4.14

> 	peter

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
