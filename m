From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 5 Jan 2004 12:32:35 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0401051150120.15063-100000@blackhole.kfki.hu>
References: <20040101163627.GD3530@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040101163627.GD3530@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 1 Jan 2004, Harald Welte wrote:

> a 2.6 specific patch would then be inside a linux-2.6 directory.  The
> only remaining question is:
>
> - how to encode the information 'which patch for which version' in the
>   info file ?  We would need something like
>   "if linux >= 2.6.0 && linux < 2.7.0, then use linux-2.6 and
>   linux-2.6.patch"
>
> - what about patchlets that have the same wholefiles but a different
>   'patch' file.  I.e. a new conntrack helper that has the same source
>   file, valid for 2.4 and 2.6 - but a different diff for patching
>   something into conntrack_core ?

Something like 'best match wins'?

linux-2.6.13		- just for 2.6.13
linux-2.6		- every (other) 2.6 release
linux-2.4		- every 2.4 release
linux			- every other release :-)

(Same goes for the linux.patch file.) 'Requires' could be used to set
general version bounds, like

Requires: linux >= 2.4.22

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
