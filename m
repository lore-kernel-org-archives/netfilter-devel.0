From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 8 Jun 2011 14:33:10 -0400
Message-ID: <BANLkTinjSiNc8VtxTntq7ekFtHrR2nq8EA@mail.gmail.com>
References: <4DEDEB99.4070601@netfilter.org>
	<4DEDFE43.5060402@googlemail.com>
	<201106081049.48026.sgrubb@redhat.com>
	<4DEFBBBE.6090307@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44721 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1FHSdM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:33:12 -0400
Received: by iyb14 with SMTP id 14so648657iyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 11:33:11 -0700 (PDT)
In-Reply-To: <4DEFBBBE.6090307@schaufler-ca.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 8, 2011 at 2:13 PM, Casey Schaufler <casey@schaufler-ca.com=
> wrote:
> On 6/8/2011 7:49 AM, Steve Grubb wrote:
>> On Tuesday, June 07, 2011 06:32:35 AM Mr Dash Four wrote:
>>> Add SELinux context support to AUDIT target - 3rd revision (style-t=
ype
>>> changes made *only* since 2nd revision of this patch). Typical (raw
>>> auditd) output after applying this patch would be:
>> <snip>
>>
>>> @@ -163,6 +170,15 @@ audit_tg(struct sk_buff *skb, const struct
>>> xt_action_param *par) break;
>>> =A0 =A0 =A0}
>>>
>>> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
>>> + =A0 =A0if (skb->secmark) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0if (!security_secid_to_secctx(skb->secmark=
, &secctx, &len)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0audit_log_format(ab, " obj=
=3D%s", secctx);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0security_release_secctx(se=
cctx, len);
>>> + =A0 =A0 =A0 =A0 =A0 =A0}
>> else
>> =A0 =A0 =A0 audit_log_format(ab, " osid=3D%u", skb->secmark);
>>
>> _All_ =A0audit code records the number on a failed conversion.
>
> But it really shouldn't. An unconvertible secid is indicative
> of a serious, unrecoverable failure within the LSM. It's every
> bit as bad as an invalid pointer.

I'm with Casey and Mr Dash Four.  The right way to do this is to make
a helper function in the audit code which takes care of the LSM calls
(rather than making LSM calls up here).  The function should throw an
error of one sort or another if it cannot convert the context.  My
suggestion:

int audit_log_secctx(struct auditbuffer *ab, u32 secid)
{
    int len, rc;
    char *ctx;

    rc =3D security_secid_to_secctx(sid, &ctx, &len);
    if (rc) {
        audit_panic("Cannot convert secid to context");
    } else {
            audit_log_format(ab, " subj=3D%s", ctx);
            security_release_secctx(ctx, len);
    }
    return rc;
}

Such a function could be used a couple of places in the audit code itse=
lf.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
