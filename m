From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] don't try to track broadcasts or multicasts (4/4)
Date: Sun, 9 Jun 2002 19:18:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020609171826.GD3181@naboo.de.gnumonks.org>
References: <1023366027.845.30.camel@tux> <20020608073547.GA1109@naboo.de.gnumonks.org> <1023547908.19838.46.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023547908.19838.46.camel@tux>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 08, 2002 at 04:51:47PM +0200, Martin Josefsson wrote:
> Hmm why didn't I think about that?

it just came to my mind after reading your mail..

> I've done some simple testing and the results are:

the results are actually quite interesting - but maybe there's a
particular reason for TCP behaving different than other protocols...

> It was a nice thought but doesn't work in the real world.

yup, it would have been a nice optimization...

> /Martin

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
