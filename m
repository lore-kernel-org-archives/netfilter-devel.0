From: Harald Welte <laforge@netfilter.org>
Subject: Re: Help Urgent (getting Oops in kfree_skb)
Date: Fri, 6 May 2005 13:16:17 +0200
Message-ID: <20050506111617.GH30482@sunbeam.de.gnumonks.org>
References: <20050503150756.78518.qmail@web52209.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: linux lover <linux_lover2004@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20050503150756.78518.qmail@web52209.mail.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Tue, May 03, 2005 at 08:07:56AM -0700, linux lover wrote:
> Hello,     
>       On 2 ethernet linux box. After it gets started i
> ifdown both eth's and do ping localhost.

which kernel versions are you using?  which modules loaded? which
configuration? please always provide as much detail as possible. 

also, consider using bugzilla.netfilter.org for bug reports.

- -- 
- - Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCe1IBXaXGVTD0i/8RApVSAJ4tjihdOdG5fn97ClOKGBvdbN9QBgCffVB8
DzaLdjDk/RK56vtmJF3jhT8=
=1CnC
-----END PGP SIGNATURE-----
