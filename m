From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch-o-matic cleanup
Date: Wed, 05 Apr 2006 15:27:57 +0200
Message-ID: <4433C5DD.10903@trash.net>
References: <443165AA.4030509@trash.net>
	<40106.195.55.244.106.1144140883.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: samueldg@arcoscom.com
In-Reply-To: <40106.195.55.244.106.1144140883.squirrel@www.arcoscom.com>
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

Samuel D=EDaz Garc=EDa wrote:
> Patrick, after the last "cleanup" (18/9/2005?), many patches were remov=
ed
> and 2.4/2.6 compatibility broken, for example the "condition" match ove=
r
> 2.6 or CONNMARK over 2.4.
>=20
> I think, that if devteam are going to invert time to "cleanup" pomng,
> would be fantastic that old ussefull and broken patches (or teorically
> merged into kernel main base) must be reviewed.

Yes, that was the idea, most useful patches will be merged, a few useful
but obscure will be kept and all others will be deleted. There will also
be a new feature to download patches from external sources when using
patch-o-matic, so if anyone wants to keep maintaining a specific patch,
we can just include a line in the sources.list.

> For example, you put pptp_conntrack to be deleted, but I used it into 2=
.4
> kernel versions, where it isn't into mainline.
>=20
> That are the ticks I think you will need to take care of.

Most effort goes into 2.6 these days, and nobody seems to have the time
to maintain old versions. The PPtP-helper in pom is missing important
bugfixes, so as long as noone fixes those, it is better to remove it
than to distribute versions known to have critical bugs IMO.

This is the time for users to step up :)
