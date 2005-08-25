From: Silimite <silimite@gmail.com>
Subject: Re: Checking add/remove rules
Date: Thu, 25 Aug 2005 08:32:27 -0400
Message-ID: <5ad977d105082505326208dc02@mail.gmail.com>
References: <5ad977d1050822070113bd1e6b@mail.gmail.com>
	<5ad977d1050824201244abc978@mail.gmail.com>
	<Pine.LNX.4.58.0508250750040.23501@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0508250750040.23501@tux.rsn.bth.se>
Content-Disposition: inline
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

Thanks!  That's what I needed to know.  I was mostly just wondering if
there was a way besides something like ref-counting.  Since there does
not seem to be another way I now know what to do.

Thanks again.

S

On 8/25/05, Martin Josefsson <gandalf@wlug.westbo.se> wrote:
> Look at the geoip match in patch-o-matic-ng, more exactly the refcounting
> in the checkentry()/destroy() functions in ipt_geoip.c And look at the
> posision of the refcount member of the ipt_geoip_info struct in the
> includefile. And look at the size and userspacesize members of struct
> iptables_match in libipt_geoip.c
>=20
> I hope that helps.
>=20
> /Martin
