From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] pom-ng new release
Date: Tue, 04 May 2004 17:11:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4097B2BA.7000500@trash.net>
References: <Pine.LNX.4.33.0405041202330.26840-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405041202330.26840-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

>- reported bugs and improvements fixed/incorporated:
>    - dependency clashing did not work (Jim Gifford)
>
>      [Could any Perl guru explain in plain English while the code
>
>      for my $dep (@{$$patchlet{info}{depends}}) {
>		$dep =~ s/^!//;
>      }
>  
>

My local Perl guru is surprised, too, but if you really want
to modify only $dep (why, it's scope is just the loop?), you
can just assign $dep it to a new variable and modify this
one, in this case the content of the array won't be touched.

Regards
Patrick

>      modifies the content of array $patchlet{info}{depends} too??]
>
>    - broken out patches are supported (KOVACS Krisztian)
>    - ignore case in runme (syrius.ml)
>
>Please check out and try the new code. Bugreports, suggestion for
>improvements are welcomed!
>
>Best regards,
>Jozsef
>-
>E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
>PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>Address : KFKI Research Institute for Particle and Nuclear Physics
>          H-1525 Budapest 114, POB. 49, Hungary
>
>
>  
>
