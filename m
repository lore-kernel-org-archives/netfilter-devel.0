From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: [PATCH] ROUTE target with ARP lookups
Date: 26 Mar 2003 10:08:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1048669690.27352.189.camel@descartes.info.ucl.ac.be>
References: <1048519994.27352.149.camel@descartes.info.ucl.ac.be>
	 <1048635304.14737.81.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1048635304.14737.81.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 26/03/2003 =E0 00:35, Martin Josefsson a =E9crit :
> On Mon, 2003-03-24 at 16:33, Cedric de Launois wrote:
> > Here is a patch for the --oif option of the ROUTE target.
> > When sending to a destination through an interface, the target
> > now performs ARP cache lookup & ARP request (excepted if the
> > device is a tunnel). This should now enable "Transparent broadband
> > network connectivity (IP PnP)" as John said.
> >=20
> > The patch is against the current CVS tree.
>=20
> I don't really like the check for ARP-able devices...
> There are a lot more non-arpable devices than the ones you test for.
> And your code looks ethernet specific so why not test for ARPHRD_ETHER
> instead?

You are 100% right. However, I'll try to make the code non ethernet
specific instead of testing for ARPHRD_ETHER.
Since the ROUTE target claims to be able to send through an interface
whatever the routing table said, I have to handle all cases...

> I havn't followed the discussion on the use of this, but it's probably
> useful :)

NOTE: Several people are doing weird think with the ROUTE target but
I do not always agree with the use they make of it. Anyway, the target
should work the way it is supposed to do.

> If you fix the dev->type issue or convince me it should look like it
> does I'll be glad to apply the patch.

I'll rework the code. Just give me more time ;) ...

Thanks for your comments and suggestions !

C=E9dric
