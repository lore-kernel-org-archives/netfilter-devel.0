From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack hash function
Date: Fri, 5 Jul 2002 15:59:55 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705135955.GH21280@naboo.ists.dartmouth.edu>
References: <20020625132643.C31BD45CF@lists.samba.org> <15640.49204.886734.272701@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15640.49204.886734.272701@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 12:10:44PM -0700, Don Cohen wrote:

> A few questions here:
> - Why make the two halves of the connection hash to different buckets?
>   I'd think you'd want to consider the two halves to be the same
>   connection.  So you want them to hash the same.  It would make the
>   comparison a little more expensive, but save half the space.

so what happens in case of NAT?  The tuples are not the same in this
case...

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
