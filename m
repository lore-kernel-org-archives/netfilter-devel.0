From: Harald Welte <laforge@gnumonks.org>
Subject: Re: possible race in init_conntrack()?
Date: Fri, 5 Jul 2002 16:18:44 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705141844.GJ21280@naboo.ists.dartmouth.edu>
References: <20020702111451.D7684@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020702111451.D7684@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 02, 2002 at 11:14:51AM +0200, Patrick Schaaf wrote:
> Hi devel,
> Did I overlook something? Making drop_next atomic_t should be a good fix.

no, you didn't.  I'm not going to submit a patch for this, since we've
never had a single bug report and it is very theoretic [whatever reason
has to become true], and we are currently redesigning the conntrack hash
anyway.... so I'd expect the new conntrack hash code including the
limit-number-of-entries-per-chain code to fix this issue as well :)

> best regards
>   Patrick

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
