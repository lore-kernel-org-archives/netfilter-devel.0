From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Tue, 11 May 2004 11:04:39 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405111103400.13357-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0405092357270.14931-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Willy TARREAU <willy@w.ods.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405092357270.14931-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 10 May 2004, Henrik Nordstrom wrote:

> On Sun, 9 May 2004, Willy TARREAU wrote:
>
> > While INFOP needs at least 2 arguments :
> >
> >    #define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
>
> Actually I think the bug is that there is no space infront of the comma in
> the ## expansion. To limit the conflicts with C99 the GNU CPP varargs
> comma magics is only activated if there is a space infront of the comma
> like in this example from the GNU CPP manual:
>
>      #define eprintf(format, args...) fprintf (stderr, format , ##args)

Yes, exactly. Patch is applied, thank you both.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
