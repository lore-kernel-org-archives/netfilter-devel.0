From: Harald Welte <laforge@gnumonks.org>
Subject: Re: new iptables module
Date: Wed, 10 Jul 2002 11:20:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020710092017.GP23676@naboo.de.gnumonks.org>
References: <000201c1a3a8$3c2c6460$0201a8c0@bspengle>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Brad Spengler <spender@grsecurity.net>
Content-Disposition: inline
In-Reply-To: <000201c1a3a8$3c2c6460$0201a8c0@bspengle>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 22, 2002 at 07:52:30PM -0500, Brad Spengler wrote:
> I've just tried my hand at writing an iptables module.  It's a match
> module that matches SYNs sent to unserved TCP ports and datagrams sent
> to unserved UDP ports.  Since doing something like this is impossible
> with regular iptables rules, would a module like this be accepted into
> the patch-o-matic list for iptables?  Comments/questions welcome

Hi Brad.

I suppose this was the mail you were referring to when we met yesterday?

I can now tell you because it was lost:

- Subject didn't really say anything about what the module was
- you didn't include the code in the email.

This might be different with other projects, but in the netfilter
project [and as well as the netdev and linux-kernel lists] this is the
preferred method.

It's really unfortunate that we lost this important contribution because
of this :(

Anyway, please send your module as patch-o-matic patch, if possible.

We'd certainly like to include it.

> -Brad
> http://grsecurity.net

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
