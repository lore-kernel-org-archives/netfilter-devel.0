From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: Sat, 5 Apr 2003 16:45:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304051643090.21072-100000@blackhole.kfki.hu>
References: <1049541403.25169.167.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1049541403.25169.167.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On 5 Apr 2003, Martin Josefsson wrote:

> But do we really want to check dependencies in reverse mode?
>
> Say I have patches B and C which both depends on patch A.
> I patch in B and A is automagically applied, then I apply C.
> Then I reverse B or C and as a result A is also backed out, oops.
>
>     # Check the dependecy of the patch
>     if [ -f "$1.depend" ]; then
>
> should probably be
>
>     # Check the dependecy of the patch
>     if [ -f "$1.depend" -a -z "$MODE" ]; then
>
> which also makes some of the code below redundant.

Yes, I think you're right.

> I've tested this and it works fine.
> (changed both the testing and applying)
>
> If that's ok with you I'll commit it together with my changes that adds
> support for conflicting patches as well. just add "not " first on the
> line in the .depend file.
>
> so tcp-window-tracking.patch.depend would look like:
>
> not extra/ip_conntrack-timeouts.patch
>
> And if ip_conntrack-timeouts.patch already is applied you get this
> output:
>
> Patch extra/tcp-window-tracking.patch conflicts with extra/ip_conntrack-timeouts.patch...
> ip_conntrack-timeouts.patch ALREADY APPLIED (0 rejects out of 10 hunks).
>
> Conflicting dependency.
>    extra/tcp-window-tracking.patch
> is incompatible with
>    extra/ip_conntrack-timeouts.patch
>
> and it stops.
>
> It skips empty lines and lines beginning with # in the .depend files
>
> I've also added a check if we are using force in apply_patch_depend()
> and if we are deps won't be checked.
>
> I've tested my changes with various dependencies and conflicts and it
> seems to work.

Great suggestions! Feel free to introduce them all.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
