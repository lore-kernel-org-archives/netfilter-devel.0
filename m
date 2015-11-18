From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Wed, 18 Nov 2015 17:50:35 +0100
Message-ID: <CAOkSjBiJexWsW30SQz48D3JEYxzyYSF_VeJ+9hPwMnJDh6zkog@mail.gmail.com>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
 <20151116111720.GA14988@salvia> <CAOkSjBgG7pVyP1LT0p+cbjrHkTGXRB=KPnrAVNQHSVSXys0xfw@mail.gmail.com>
 <20151116170325.GA1694@salvia> <20151117102520.GA16690@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38057 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbKRQu4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 11:50:56 -0500
Received: by wmec201 with SMTP id c201so81929945wme.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2015 08:50:55 -0800 (PST)
In-Reply-To: <20151117102520.GA16690@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 November 2015 at 11:25, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Mon, Nov 16, 2015 at 06:03:25PM +0100, Pablo Neira Ayuso wrote:
>> On Mon, Nov 16, 2015 at 03:22:21PM +0100, Arturo Borrero Gonzalez wr=
ote:
>> > On 16 November 2015 at 12:17, Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>> > > On Fri, Nov 13, 2015 at 11:59:35AM +0100, Arturo Borrero Gonzale=
z wrote:
>> > >> v2: change functions definitions to static inline if no BUILD_S=
YSTEMD,
>> > >>     and set watchdog variables as static.
>> > >>
>> > >> v3: add runtime systemd configuration. Report warnings.
>> > >
>> > > One more question:
>> > >
>> > > This is checking for 'libsystemd >=3D 227'
>> > >
>> > > Is this library version really required? Or it is simply that yo=
u have
>> > > set to the most recent version for some reason?
>> >
>> > 227 is the version I've tested. Previous versions may not work.
>> >
>> > For example, I remember the library being split in several small
>> > libraries and then mixed into this libsystemd, thus changing some
>> > headers and include paths.
>> >
>> > Also, I simply ignore what is the behaviour of the watchdog stuff
>> > previous to 227, it seems a recent thing.
>> >
>> > What are your concerns?
>>
>> I would like not to see many ifdefs in the conntrack-tools tree just
>> because they update interfaces too frequently. Could you check at
>> their history record to see how they have been performing on that
>> front so far?
>
> Arturo, I'm going to push this into master.
>
> I have just mangled the configure.ac part of your patch here so the
> default behaviour is that you have to explicitly indicate
> --enable-systemd support if you want this.
>
> We can revisit this later on to change the default.
>
> OK?

Ok thanks,

I've been scanning the debian changelog for systemd [0]. The only big
change to libsystemd seems to be when libsystemd-login,
libsytemd-daemon, libsystemd-* were merged into a general libsystemd.
The API prototypes seem to be stable across releases.

[0] https://tracker.debian.org/media/packages/s/systemd/changelog-227-3
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
