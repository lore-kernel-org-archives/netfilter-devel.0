From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch] pom-ng version check confusion
Date: Fri, 27 Feb 2004 22:43:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402272240330.27750-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0402271011310.21531-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402271011310.21531-200000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

On Fri, 27 Feb 2004, Henrik Nordstrom wrote:

> The pom-ng version check failed if the difference was not in the last
> version number, i.e. 2.4.25 < 2.6.0 test failed.
>
> The attached patch simplifies the version check so it works
> somewhat better.

I have applied all your pomng patches in cvs.

> There is still room for improvement. The returned weight is not sufficient
> for determining the best match if there is multiple subversions. Should be
> acceptable if the weight is multiplied by a factor 1000 of the version
> depth I think.

Yes, exactly. It could pick a wrong version as best match. Fortunately we
haven't got any patch yet, for which it could happen :-). Patches are
welcomed :-))

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
