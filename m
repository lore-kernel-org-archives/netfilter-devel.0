From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: Fri, 4 Apr 2003 10:46:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304041041450.18961-100000@blackhole.kfki.hu>
References: <1049368914.25169.63.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?ISO-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>,
	<netfilter@interlinx.bc.ca>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1049368914.25169.63.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 3 Apr 2003, Martin Josefsson wrote:

> > The best way is probably to have some scripts run regularly, trying
> > some patch-o-matic combinations (why not all, as patch is quite
> > fast...) to detect incompatibilities automatically, and especially
> > report new ones.
> > Such a list would be interesting.
>
> If someone builds the scripts needed :)

I have just updated the runme script in patch-o-matic:

- removed copying the source trees at patch testing (faster processing)
- added patch-dependency support

> tcp-window-tracking.patch should soon be updated in cvs to reflect the
> changes.

I'll update the tcp-window-tracking patch around the end of the next week.
I want to test the new version in production before releasing it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
