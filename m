From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Thu, 09 Jun 2011 14:28:15 +0200
Message-ID: <4DF0BC5F.5040100@trash.net>
References: <4DEDEB99.4070601@netfilter.org>	<4DEFC6C9.5030004@googlemail.com>	<BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>	<201106081528.22926.sgrubb@redhat.com> <BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Steve Grubb <sgrubb@redhat.com>,
	Mr Dash Four <mr.dash.four@googlemail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Paris <eparis@parisplace.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1FIM2T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:28:19 -0400
In-Reply-To: <BANLkTik9wXe+g4EXByUt3MrxGhuLKgTV3A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.06.2011 21:39, Eric Paris wrote:
> On Wed, Jun 8, 2011 at 3:28 PM, Steve Grubb <sgrubb@redhat.com> wrote:
>> On Wednesday, June 08, 2011 03:08:38 PM Eric Paris wrote:
>>> On Wed, Jun 8, 2011 at 3:00 PM, Mr Dash Four
>>>
>>> <mr.dash.four@googlemail.com> wrote:
>>>>> int audit_log_secctx(struct auditbuffer *ab, u32 secid)
>>>>> {
>>>>>    int len, rc;
>>>>>    char *ctx;
>>>>>
>>>>>    rc = security_secid_to_secctx(sid, &ctx, &len);
>>>>>    if (rc) {
>>>>>        audit_panic("Cannot convert secid to context");
>>>>>    } else {
>>>>>            audit_log_format(ab, " subj=%s", ctx);
>>>>>            security_release_secctx(ctx, len);
>>>>>    }
>>>>>    return rc;
>>>>> }
>>>>>
>>>>> Such a function could be used a couple of places in the audit code
>>>>> itself.
>>>>
>>>> My view on this is that LSM error-handling should be part of LSM.
>>>>
>>>> I presume security_secid_to_secctx is going to be called from quite a few
>>>> places (well, I know of at least two now and they have nothing to do with
>>>> the LSM) and in my opinion it would be better if that error handling, if
>>>> adopted, is implemented within the function itself - whether by calling
>>>> another function, like the one you proposed above, or as part of the
>>>> secctx retrieval - this could be open to interpretation, but the point I
>>>> am trying to make is that whichever code security_secid_to_secctx is
>>>> invoked from shouldn't be involved in reporting/handling (internal LSM)
>>>> errors at all.
>>>>
>>>> I think I made that point in my previous post, but just wanted to make
>>>> sure that is the case.
>>>
>>> The LSM might report and error.  It's up to the caller to figure out
>>> how to deal with that error.  In this case we want to use the audit
>>> system so it's up to the audit system how to handle that error.
>>
>> We are happy recording the failed number. Its the LSM people that say nuke the system.
>> So, I would put that in security_secid_to_secctx() so that everyone knows whose
>> requirements it was to do the nuclear option.
> 
> If the number meets your requirements then the requirements are total
> shit.  The number has NO relation to the label on the object as
> understood by the system.  If audit has a requirement to always log
> the label or call audit_panic(), its only option is to call
> audit_panic().
> 
> Exposing secids and internal representations of information to
> userspace is always wrong.  Full stop.
> 
> I'd be willing to take a patch which caused security_secid_to_secctx()
> to BUG() if it got an invalid secid.  But on ENOMEM I'm going to just
> push the error back up the stack.  In that case audit has to decide
> how to handle the situation.  That secid is NOT the label associated
> with the object and printing it to userspace is meaningless garbage.
> 
> Just because audit did it wrong yesterday doesn't mean I'm going to
> ACK more patches that do it wrong tomorrow.  I don't care what some
> arbitrary and obviously poorly thought out requirement document says.

Just to make sure, so the conclusion is that the patch is fine as
it is and anything related to unconvertible secids will be handled
by SELinux internally?
