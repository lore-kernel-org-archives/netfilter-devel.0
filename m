From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 14:47:44 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625124744.GB7975@naboo.ols.wavesec.org>
References: <008201c21a96$88eb6520$0489cb8a@etbx180> <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 01:33:13PM +0200, Jozsef Kadlecsik wrote:
> From where do you think that the module usage counter reports how many
> packets/connections are handled (currently? totally?) by the module.
> There is no whatsoever connection!

one should also consider the performance impact this would have !!!

> According to your first mail, the machine has 256M RAM and you issued
> 
> insmod ip_conntrack 16384
> 
> That requires 16384*8*~600byte ~= 75MB non-swappable RAM.
> 
> When you issued "iptables -t nat -L", the system tried to reserve plus
> 2x75MB. That's in total pretty near to all your available physical RAM
> and the machine might died in swapping.

??? Why should listing an IP table try to reserve twice the size of the
conntrack table?

> Regards,
> Jozsef

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
