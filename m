From: Herve Eychenne <rv@wallfire.org>
Subject: Re: iptables: memory allocation problem
Date: Tue, 23 Dec 2003 00:58:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031222235855.GE7269@eychenne.org>
References: <20031216182959.GA1216@eychenne.org> <20031220121218.GA1370@eychenne.org> <1071923429.24067.76.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1071923429.24067.76.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Dec 20, 2003 at 01:30:29PM +0100, Martin Josefsson wrote:

> On Sat, 2003-12-20 at 13:12, Herve Eychenne wrote:

> > Well, anyway, as conntrack listing locks conntrack state, don't you
> > think we should definitely provide a way to read ip_conntrack_count
> > through /proc/sys/net/ipv4/netfilter/ip_conntrack_count ? (aka
> > "Yet Another Oneliner Patch For Patch-O-Matic")

> Just a quick response before I vanish for some christmas vacation.

> Look at extra/ctstat.patch*
> Apply it and download the util, it will give you what you want and more=
.

Ok, let me put it differently... :-)
This patch is interesting, and it adds so little overhead that I don't
understand why it isn't already in submitted.

If, for any reason, the coreteam doesn't want to include it as-is,
then we could consider adding ip_conntrack_count to /proc, and add a
kernel config option (defaulting to no) for conntrack stats.
What do you think?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
