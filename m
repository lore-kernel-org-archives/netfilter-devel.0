From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 14:58:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0604281455520.20380@blackhole.kfki.hu>
References: <200604201919.19246.max@nucleus.it>
	<200604281246.40488.max@nucleus.it>
	<4451F745.4070900@trash.net> <200604281444.50982.max@nucleus.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604281444.50982.max@nucleus.it>
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

On Fri, 28 Apr 2006, Massimiliano Hofer wrote:

> > How would you achieve O(1) average?
>
> Hash. But it adds complexity to the code and unnecessary complexity is a form
> of ugliness.

Why don't you choose an array and its indices? Array size could be
specified by module parameter if the default were not sufficient for
someone.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
