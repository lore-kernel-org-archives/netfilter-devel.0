From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Q: Any other way on handling "conntrack DESTROY" without ip_conntrack_destroyed()
Date: Fri, 5 Jul 2002 15:57:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705135736.GG21280@naboo.ists.dartmouth.edu>
References: <1458624.1025158005416.JavaMail.postfix@mailsrv10.mail.sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: qhou <qhou_acornsoft@sohu.com>
Content-Disposition: inline
In-Reply-To: <1458624.1025158005416.JavaMail.postfix@mailsrv10.mail.sohu.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 27, 2002 at 02:06:45PM +0800, qhou wrote:
> I have a requirement:
> =====================
> 1.When a conntrack is created, I'll allocate memory for my private
> data, if the associated connect is what I am interested on.

> 2.And as the conntrack is destroyed for the connect is absolutely
> closed or timeout, I'll then release the memory of my private data.

What are you implementing? A layer four helper (like
ip_conntrack_proto_tcp.c?)

In CVS is a patch which adds a proto->destroy function to the l4 proto
helpers (ip_conntrack_protocol_destroy.patch)

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
