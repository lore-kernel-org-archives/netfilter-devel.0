From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH pom-ng] prepare a 2.6 tree in h323-conntrack-nat
Date: Wed, 19 Jan 2005 12:42:33 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501191241320.10783@blackhole.kfki.hu>
References: <20050119113504.GA17232@roonstrasse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050119113504.GA17232@roonstrasse.net>
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

On Wed, 19 Jan 2005, Max Kellermann wrote:

> This is actually not a patch, just a svn copy command... someone with
> svn write access, please execute the following command:
>
>  svn copy \
>   https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/h323-conntrack-nat/linux \
>   https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/h323-conntrack-nat/linux-2.6 \
>   -m 'prepare a 2.6 tree for h323-conntrack-nat'
>
> This allows me to publish patches for the existing codebase for my
> Linux 2.6 port of the module, and preserves the svn log once my
> patches are accepted.

I'll do it afternoon. You don't need to send new patches, I'll use what
you posted earlier.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
