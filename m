From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 1/2] netfilter: IPv6: initialize TOS field in
 REJECT target module
Date: Wed, 15 Jun 2011 12:25:34 -0700
Message-ID: <20110615192534.GA11496@kroah.com>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
 <20110606173623.GC7394@kroah.com>
 <1307414373.6576.25.camel@nexus.oss.ntt.co.jp>
 <20110615001122.GA1645@kroah.com>
 <1308118784.4256.18.camel@nexus.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, stable@kernel.org,
	netfilter-devel@vger.kernel.org
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41036 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab1FOTff (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:35:35 -0400
Content-Disposition: inline
In-Reply-To: <1308118784.4256.18.camel@nexus.oss.ntt.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 15, 2011 at 03:19:44PM +0900, Fernando Luis V=E1zquez Cao w=
rote:
> Hi Craig,
>=20
> On Tue, 2011-06-14 at 17:11 -0700, Greg KH wrote:
> > On Tue, Jun 07, 2011 at 11:39:33AM +0900, Fernando Luis V=E1zquez C=
ao wrote:
> > > [PATCH 1/2] netfilter: IPv6: initialize TOS field in REJECT targe=
t module
> > > For linux-2.6.38.8 you can take the upstream
> > > 4319cc0cf5bb894b7368008cdf6dd20eb8868018. For linux-2.6.37.6,
> > > linux-2.6.36.4, linux-2.6.35.13, linux-2.6.34.9, linux-2.6.33.14,
> > > linux-2.6.32.41, and linux-2.6.27.59 you will need to use the att=
ached
> > > backport.
> >=20
> > Ok, but this doesn't apply at all to the 2.6.39-stable kernel.
>=20
> The reason is that both patch 1/2 and patch 2/2 are already in 2.6.39=
,
> which is from where I would like to have them backported.
>=20
>=20
> > So, care to start all over again?
>=20
> Sure
>=20
>=20
> > I need patches that apply to the .39-stable tree.
>=20
> As mentioned above they were merged during the 2.6.39 merge window.
>=20
>=20
> > And then to any other stable kernel that you wish to have them appl=
y to.
> > Currently "live" kernels are .32-longterm, .33-longterm, .34-longte=
rm,
> > and .35-longterm.
>=20
> I would like to have them applied to all those. The patches are:
>=20
> 1. [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
>=20
>    This one you can take from upstream commit
>    1ed2f73d90fb49bcf5704aee7e9084adb882bfc5.
>=20
> 2. [PATCH 1/2] netfilter: IPv6: initialize TOS field in REJECT target=
 module
>=20
>    The upstream patch would not apply cleanly so use the attached pat=
ch
>    instead.

Ok, I've queued them up for the .32 and .33-longterm kernels, I'll let
the other longterm kernel maintainers apply them if they get around to
doing new releases of their trees.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
