From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Thu, 16 Dec 2010 15:47:55 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012161535080.6557@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>  <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>  <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>  <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>  <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr> <1292507013.3395.19.camel@lsx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Graf <tgraf@redhat.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1292507013.3395.19.camel@lsx>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Dec 2010, Thomas Graf wrote:

> On Thu, 2010-12-16 at 13:51 +0100, Jan Engelhardt wrote: 
> > On Thursday 2010-12-16 10:57, Jesper Dangaard Brouer wrote:
> > 
> > >Cc.ed Thomas Graf (tgraf@redhat.com), Thomas presented some interesting 
> > >ideas on netlink error-codes and strings during NetConf 2010, see:
> > >
> > >http://vger.kernel.org/netconf2010.html 
> > >http://vger.kernel.org/netconf2010_slides/tgraf_netconf10.odp
> > 
> > The idea is appending an error string is ok for Netlink as a protocol
> > (specification-wise), but the size constraints of the skbuffs in the
> > Linux may make its practical implementation a little harder. "Half of
> > the packet" is already used for the original request message, and
> > cramming an extra error string may bust the space.
> > It also does not look very netlinky to not use nlattrs ;-)
> 
> Why not use nlattr to encode the error string? It would make error
> messages easier to extend in the future. At some point we might want
> to add an offset field which points into the original netlink message
> describing the attribute which caused the failure.

I use full netlink messages with respect the buffers, taking into account 
the size of struct nlmsgerr in case of an error. If there was an error 
string, how much space should be reserved for that?

> > On Wed, 15 Dec 2010, Jozsef Kadlecsik came about with:
> > >
> > >>I have got a three-level error coding in my mind: general, standard 
> > >>error codes (ENOMEM, EPERM, etc.), general netfilter specific ones 
> > >>(like NFXTE_HOOKMASK_NOT_ADHERED) and table/match/target specific 
> > >>ones.
> > >>
> > >>But I do realize that it's much easier (and therefore quite tempting) 
> > >>to construct the full error message in kernel space and just send it 
> > >>back. However, that'd make quite hard to support internationalization.
> 
> Thinking of netlink protocols in general and netfilter in specific,
> maintaining a list of reserved error codes for each subsystem/target/
> module will result in an unbearable pain if the error codes are not
> separated into individual namespaces for each module.
> 
> That would in turn require each module to define a unique number or
> some form of namespace resolution mechanism which does not help to keep
> things simple.
> 
> This is the main reason why I advocate the use of error strings.

But why error codes looks complicated? Netlink already supports it and 
it's simple to separate them:
	errcode < 256	generic errors
256 <=	errcode < 512	generic netfilter specific errors
512 <=	errcode		table/match/module specific errors

An error pointer is required which points to the table/match/module, which
triggered the error.
 
> > It's not like those strings change all that much.
> > 
> > 
> > >To support internationalization, we could just add an error-number-code 
> > >in front of the constructed error message?
> > 
> > Buying us what? If you change the string, but the gettext lookup is 
> > based upon a number, you will get an outdated translation, which is not 
> > nice either. IMHO: Better an English message than an inaccurate message.
> 
> Do we *really* need internationalization for error messages on this
> level? Primarily userspace should be in charge of checking for all kinds
> of erroneous user input and produce meaningful context based,
> translatable error messages. Error messages produced by the kernel
> should be the exception and not a substitute for proper userspace error
> handling.

Netlink based protocol is the path to internationalization. Netlink based 
protol leads to usable library. Library leads to gui. Gui leads to 
internationalization. ;-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
