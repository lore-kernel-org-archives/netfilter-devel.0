From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd IPv6 client support for interface scope
Date: Mon, 12 May 2014 18:07:32 +0200
Message-ID: <20140512160732.GA13013@localhost>
References: <C1308655-F367-4C0F-BD8D-DF62B0E7A8EA@nearband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Michael Griego <mgriego@nearband.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43838 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaELQHq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:07:46 -0400
Content-Disposition: inline
In-Reply-To: <C1308655-F367-4C0F-BD8D-DF62B0E7A8EA@nearband.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, May 07, 2014 at 03:18:04PM -0500, Michael Griego wrote:
> Greetings,
>=20
> I=E2=80=99ve been setting up conntrackd on a pair of new firewalls, a=
nd I
> discovered that, while the server code handles setting the scope for
> the IPv6 address structure, the client code does not.  In a case
> where a person is using link-local addresses for conntrackd syncing
> (as I am) on a multi-homed system (as is generally expected in these
> scenarios, especially since conntrackd is expected to be running on
> a dedicated interface), this causes the server socket to get bound
> to the proper scope/interface, but the client socket never gets the
> scope, so it will fall back to the kernel routing table to connect
> to its peer.  The kernel routing table will often not choose the
> correct interface for this.
>=20
> I patched my local copy of conntrack-tools (for UDP in this case) as =
so:
>=20
> --- conntrack-tools-1.4.1.orig/src/udp.c	2013-02-24 16:23:57.18398500=
9 -0600
> +++ conntrack-tools-1.4.1/src/udp.c	2014-05-07 14:18:20.407835364 -05=
00
> @@ -144,6 +144,7 @@
>  		memcpy(&m->addr.ipv6.sin6_addr, &conf->client.inet_addr6,
>  		       sizeof(struct in6_addr));
>  		m->sockaddr_len =3D sizeof(struct sockaddr_in6);=20
> +		m->addr.ipv6.sin6_scope_id =3D conf->server.ipv6.scope_id;
>  		break;
>  	default:
>  		ret =3D -1;
>=20
>=20
> It simply sets the scope ID of the client socket to the same one
> that=E2=80=99s being used for the server socket.  It should be a safe
> assumption, since only one Interface stanza is used for the channel
> configuration.  This did allow usage of link-local addresses to
> begin working properly without having to resort to setting up host
> routes in each firewall for the link local address of each other.
>=20
> The same thing would need to be done for the other channel types as
> well, but I was curious about the reception of this type of patch
> before creating a full patch (against 1.4.2 instead of 1.4.1, of
> course).  As I said, this patched code is now working properly in my
> setup using link-local IPv6 addresses in a UDP unicast channel.

I don't find a reasonable scenario in which someone would need to
receive sync message from one interface and send them from another.

So I agree with your assumption, could you please send me a patch in
git-format-patch including a Signed-off-by that I can apply with
git-am.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
