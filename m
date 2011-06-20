From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 4th revision] Add SELinux context support to AUDIT target
Date: Mon, 20 Jun 2011 10:27:08 -0400
Message-ID: <BANLkTi=Ls8Xnqa6ZF+Qwg_yyUH4Yxbgijg@mail.gmail.com>
References: <4DF9C085.3040306@googlemail.com>
	<4DFC9525.2080402@googlemail.com>
	<201106200820.23127.sgrubb@redhat.com>
	<4DFF5783.3070808@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35478 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1FTO1J convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:27:09 -0400
Received: by iwn6 with SMTP id 6so1218642iwn.19
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2011 07:27:09 -0700 (PDT)
In-Reply-To: <4DFF5783.3070808@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2011 at 10:21 AM, Mr Dash Four
<mr.dash.four@googlemail.com> wrote:
>
>> Do you think this should be hardcoded to be obj? Would we ever log t=
he
>> subj? Or should obj be part of the function name to make it clear wh=
ich
>> piece is getting logged?
>>
>
> I thought of that, though I don't know what variety of option names w=
ould be
> there to be used with that function.
>
> If there is a need to use something other than "obj", like, "subj" or=
 even
> "tcontext" or "scontext" for example, then I would favour passing the=
 option
> name as function parameter - something like "void audit_log_secctx(st=
ruct
> audit_buffer *ab, char *secname, u32 secid)" or even "void
> audit_log_secctx(struct audit_buffer *ab, int secname, u32 secid)" (s=
ecname
> here being one of 0, 1, 2 ... corresponding to "obj", "subj" etc).
>
> Similar approach is already used in audit.c - in audit_log_config_cha=
nge for
> example:
>
> static int audit_log_config_change(char *function_name, int new, int =
old,
> uid_t loginuid, u32 sessionid, u32 sid, int allow_changes)
> {
> =A0 struct audit_buffer *ab;
> =A0 int rc =3D 0;
>
> =A0 ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> =A0 audit_log_format(ab, "%s=3D%d old=3D%d auid=3D%u ses=3D%u", funct=
ion_name, new,
> old, loginuid, sessionid);

Hard code for now.  %s in audit record building is the devil since
there is no enforcement of audit's rather 'special' string encoding
rules.  If we need another name later we'll cross that bridge when we
get there, possibly with another helper function and pushing the %s to
a static function inside audit.  I will not willing expose %s to code
outside of audit.c.

Acked-by: Eric Paris <eparis@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
