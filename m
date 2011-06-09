From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Thu, 9 Jun 2011 08:52:20 -0400
Message-ID: <BANLkTin-M-60LSTbvAdpzfio0suYj2WcqA@mail.gmail.com>
References: <4DEDEB99.4070601@netfilter.org>
	<4DEFC6C9.5030004@googlemail.com>
	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
	<201106081528.22926.sgrubb@redhat.com>
	<BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>
	<4DF0BC5F.5040100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve Grubb <sgrubb@redhat.com>,
	Mr Dash Four <mr.dash.four@googlemail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53860 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1FIMwV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:52:21 -0400
Received: by iwn34 with SMTP id 34so1267775iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 05:52:21 -0700 (PDT)
In-Reply-To: <4DF0BC5F.5040100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 9, 2011 at 8:28 AM, Patrick McHardy <kaber@trash.net> wrote=
:
> On 08.06.2011 21:39, Eric Paris wrote:
>> On Wed, Jun 8, 2011 at 3:28 PM, Steve Grubb <sgrubb@redhat.com> wrot=
e:
>>> On Wednesday, June 08, 2011 03:08:38 PM Eric Paris wrote:
>>>> On Wed, Jun 8, 2011 at 3:00 PM, Mr Dash Four
>>>>
>>>> <mr.dash.four@googlemail.com> wrote:
>>>>>> int audit_log_secctx(struct auditbuffer *ab, u32 secid)
>>>>>> {
>>>>>> =A0 =A0int len, rc;
>>>>>> =A0 =A0char *ctx;
>>>>>>
>>>>>> =A0 =A0rc =3D security_secid_to_secctx(sid, &ctx, &len);
>>>>>> =A0 =A0if (rc) {
>>>>>> =A0 =A0 =A0 =A0audit_panic("Cannot convert secid to context");
>>>>>> =A0 =A0} else {
>>>>>> =A0 =A0 =A0 =A0 =A0 =A0audit_log_format(ab, " subj=3D%s", ctx);
>>>>>> =A0 =A0 =A0 =A0 =A0 =A0security_release_secctx(ctx, len);
>>>>>> =A0 =A0}
>>>>>> =A0 =A0return rc;
>>>>>> }
>>>>>>
>>>>>> Such a function could be used a couple of places in the audit co=
de
>>>>>> itself.
>>>>>
>>>>> My view on this is that LSM error-handling should be part of LSM.
>>>>>
>>>>> I presume security_secid_to_secctx is going to be called from qui=
te a few
>>>>> places (well, I know of at least two now and they have nothing to=
 do with
>>>>> the LSM) and in my opinion it would be better if that error handl=
ing, if
>>>>> adopted, is implemented within the function itself - whether by c=
alling
>>>>> another function, like the one you proposed above, or as part of =
the
>>>>> secctx retrieval - this could be open to interpretation, but the =
point I
>>>>> am trying to make is that whichever code security_secid_to_secctx=
 is
>>>>> invoked from shouldn't be involved in reporting/handling (interna=
l LSM)
>>>>> errors at all.
>>>>>
>>>>> I think I made that point in my previous post, but just wanted to=
 make
>>>>> sure that is the case.
>>>>
>>>> The LSM might report and error. =A0It's up to the caller to figure=
 out
>>>> how to deal with that error. =A0In this case we want to use the au=
dit
>>>> system so it's up to the audit system how to handle that error.
>>>
>>> We are happy recording the failed number. Its the LSM people that s=
ay nuke the system.
>>> So, I would put that in security_secid_to_secctx() so that everyone=
 knows whose
>>> requirements it was to do the nuclear option.
>>
>> If the number meets your requirements then the requirements are tota=
l
>> shit. =A0The number has NO relation to the label on the object as
>> understood by the system. =A0If audit has a requirement to always lo=
g
>> the label or call audit_panic(), its only option is to call
>> audit_panic().
>>
>> Exposing secids and internal representations of information to
>> userspace is always wrong. =A0Full stop.
>>
>> I'd be willing to take a patch which caused security_secid_to_secctx=
()
>> to BUG() if it got an invalid secid. =A0But on ENOMEM I'm going to j=
ust
>> push the error back up the stack. =A0In that case audit has to decid=
e
>> how to handle the situation. =A0That secid is NOT the label associat=
ed
>> with the object and printing it to userspace is meaningless garbage.
>>
>> Just because audit did it wrong yesterday doesn't mean I'm going to
>> ACK more patches that do it wrong tomorrow. =A0I don't care what som=
e
>> arbitrary and obviously poorly thought out requirement document says=
=2E
>
> Just to make sure, so the conclusion is that the patch is fine as
> it is and anything related to unconvertible secids will be handled
> by SELinux internally?
>

No.  This patch does not get my ACK.  Steve is right that silently
dropping information is a big big no no for the audit system and
that's what this patch does.  This cannot be wholly handled properly
inside the LSM either.  I don't see any patch meeting everyone's
requirements outside of a new one that includes the audit helper I
suggested.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
