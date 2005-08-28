From: Eric Leblond <eric@inl.fr>
Subject: Re: NuFW port to libnfnetlink_queue
Date: Sun, 28 Aug 2005 19:39:01 +0200
Message-ID: <1125250741.5109.5.camel@localhost.localdomain>
References: <1123707250.4996.9.camel@porky>
	<20050828114657.GD4244@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050828114657.GD4244@rama.de.gnumonks.org>
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

Le dimanche 28 ao=FBt 2005 =E0 13:46 +0200, Harald Welte a =E9crit :
> On Wed, Aug 10, 2005 at 10:54:10PM +0200, Eric Leblond wrote:
> > Hi,
> >=20
> > I've just finished to port NuFW to NFQUEUE.
> >=20
> > For the moment, only svn is up-to-date but the daily export will soon
> > contains this new feature.
> > Svn access method is described at :
> > 	http://www.nufw.org/-Downloads-.html
> >=20
> > It seems to work fine and I will soon do some more extensive tests to
> > see how it works under some load.=20
>=20
> Did you yet run those load tests?  Did everything work fine?

No, I've run out of time before my holiday this week. I will probably be
able to to some tests next week or the following.=20

> Also, if you have the time, I would be interested in performance
> measurements, comparing ip_queue with nfnetlink_queue.

I will provide result to the list as soon as I've some.

By the way what's the status of the patch I sent which provides a set of
higher level functions to libnfnetlink_queue ?

BR,
--=20
Eric Leblond <eric@inl.fr>
