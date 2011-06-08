From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 8 Jun 2011 15:39:37 -0400
Message-ID: <BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>
References: <4DEDEB99.4070601@netfilter.org>
	<4DEFC6C9.5030004@googlemail.com>
	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
	<201106081528.22926.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54793 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1FHTjh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:39:37 -0400
Received: by iyb14 with SMTP id 14so698649iyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 12:39:37 -0700 (PDT)
In-Reply-To: <201106081528.22926.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 8, 2011 at 3:28 PM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, June 08, 2011 03:08:38 PM Eric Paris wrote:
>> On Wed, Jun 8, 2011 at 3:00 PM, Mr Dash Four
>>
>> <mr.dash.four@googlemail.com> wrote:
>> >> int audit_log_secctx(struct auditbuffer *ab, u32 secid)
>> >> {
>> >> =A0 =A0int len, rc;
>> >> =A0 =A0char *ctx;
>> >>
>> >> =A0 =A0rc =3D security_secid_to_secctx(sid, &ctx, &len);
>> >> =A0 =A0if (rc) {
>> >> =A0 =A0 =A0 =A0audit_panic("Cannot convert secid to context");
>> >> =A0 =A0} else {
>> >> =A0 =A0 =A0 =A0 =A0 =A0audit_log_format(ab, " subj=3D%s", ctx);
>> >> =A0 =A0 =A0 =A0 =A0 =A0security_release_secctx(ctx, len);
>> >> =A0 =A0}
>> >> =A0 =A0return rc;
>> >> }
>> >>
>> >> Such a function could be used a couple of places in the audit cod=
e
>> >> itself.
>> >
>> > My view on this is that LSM error-handling should be part of LSM.
>> >
>> > I presume security_secid_to_secctx is going to be called from quit=
e a few
>> > places (well, I know of at least two now and they have nothing to =
do with
>> > the LSM) and in my opinion it would be better if that error handli=
ng, if
>> > adopted, is implemented within the function itself - whether by ca=
lling
>> > another function, like the one you proposed above, or as part of t=
he
>> > secctx retrieval - this could be open to interpretation, but the p=
oint I
>> > am trying to make is that whichever code security_secid_to_secctx =
is
>> > invoked from shouldn't be involved in reporting/handling (internal=
 LSM)
>> > errors at all.
>> >
>> > I think I made that point in my previous post, but just wanted to =
make
>> > sure that is the case.
>>
>> The LSM might report and error. =A0It's up to the caller to figure o=
ut
>> how to deal with that error. =A0In this case we want to use the audi=
t
>> system so it's up to the audit system how to handle that error.
>
> We are happy recording the failed number. Its the LSM people that say=
 nuke the system.
> So, I would put that in security_secid_to_secctx() so that everyone k=
nows whose
> requirements it was to do the nuclear option.

If the number meets your requirements then the requirements are total
shit.  The number has NO relation to the label on the object as
understood by the system.  If audit has a requirement to always log
the label or call audit_panic(), its only option is to call
audit_panic().

Exposing secids and internal representations of information to
userspace is always wrong.  Full stop.

I'd be willing to take a patch which caused security_secid_to_secctx()
to BUG() if it got an invalid secid.  But on ENOMEM I'm going to just
push the error back up the stack.  In that case audit has to decide
how to handle the situation.  That secid is NOT the label associated
with the object and printing it to userspace is meaningless garbage.

Just because audit did it wrong yesterday doesn't mean I'm going to
ACK more patches that do it wrong tomorrow.  I don't care what some
arbitrary and obviously poorly thought out requirement document says.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
