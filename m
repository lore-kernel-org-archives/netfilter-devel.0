From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 8 Jun 2011 15:08:38 -0400
Message-ID: <BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
References: <4DEDEB99.4070601@netfilter.org>
	<4DEDFE43.5060402@googlemail.com>
	<201106081049.48026.sgrubb@redhat.com>
	<4DEFBBBE.6090307@schaufler-ca.com>
	<BANLkTinjSiNc8VtxTntq7ekFtHrR2nq8EA@mail.gmail.com>
	<4DEFC6C9.5030004@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Casey Schaufler <casey@schaufler-ca.com>,
	Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57701 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1FHTIj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:08:39 -0400
Received: by iyb14 with SMTP id 14so675126iyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 12:08:39 -0700 (PDT)
In-Reply-To: <4DEFC6C9.5030004@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 8, 2011 at 3:00 PM, Mr Dash Four
<mr.dash.four@googlemail.com> wrote:
>
>> int audit_log_secctx(struct auditbuffer *ab, u32 secid)
>> {
>> =A0 =A0int len, rc;
>> =A0 =A0char *ctx;
>>
>> =A0 =A0rc =3D security_secid_to_secctx(sid, &ctx, &len);
>> =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0audit_panic("Cannot convert secid to context");
>> =A0 =A0} else {
>> =A0 =A0 =A0 =A0 =A0 =A0audit_log_format(ab, " subj=3D%s", ctx);
>> =A0 =A0 =A0 =A0 =A0 =A0security_release_secctx(ctx, len);
>> =A0 =A0}
>> =A0 =A0return rc;
>> }
>>
>> Such a function could be used a couple of places in the audit code i=
tself.
>>
>
> My view on this is that LSM error-handling should be part of LSM.
>
> I presume security_secid_to_secctx is going to be called from quite a=
 few
> places (well, I know of at least two now and they have nothing to do =
with
> the LSM) and in my opinion it would be better if that error handling,=
 if
> adopted, is implemented within the function itself - whether by calli=
ng
> another function, like the one you proposed above, or as part of the =
secctx
> retrieval - this could be open to interpretation, but the point I am =
trying
> to make is that whichever code security_secid_to_secctx is invoked fr=
om
> shouldn't be involved in reporting/handling (internal LSM) errors at =
all.
>
> I think I made that point in my previous post, but just wanted to mak=
e sure
> that is the case.

The LSM might report and error.  It's up to the caller to figure out
how to deal with that error.  In this case we want to use the audit
system so it's up to the audit system how to handle that error.  This
helper function says the audit system should log it if it work and
should audit_panic() if it doesn't.  audit_panic() will just call
printk for most people and can actually panic the box for nutters who
really care.  In this way we always log the information and if we
don't it's up to audit how audit handles it's inability to log info.

It's not netfilter's job to handle the error.  It's not the LSMs job
to know how it's caller wants to handle the error.  Audit is who has
special requirements and the code to handle the error should be in
audit code.  (Maybe it wasn't clear, but I think this function should
go in kernel/audit.c, not the netfilter code.  The netfilter code
should call this helper function.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
