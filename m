From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4th revision] Add SELinux context support to AUDIT target
Date: Thu, 30 Jun 2011 13:35:10 +0200
Message-ID: <4E0C5F6E.4000005@trash.net>
References: <4DF9C085.3040306@googlemail.com>	<4DFC9525.2080402@googlemail.com>	<201106200820.23127.sgrubb@redhat.com>	<4DFF5783.3070808@googlemail.com> <BANLkTi=Ls8Xnqa6ZF+Qwg_yyUH4Yxbgijg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
	netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Paris <eparis@parisplace.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44067 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1F3LfO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:35:14 -0400
In-Reply-To: <BANLkTi=Ls8Xnqa6ZF+Qwg_yyUH4Yxbgijg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 20.06.2011 16:27, schrieb Eric Paris:
> On Mon, Jun 20, 2011 at 10:21 AM, Mr Dash Four
> <mr.dash.four@googlemail.com> wrote:
>> >
>>> >> Do you think this should be hardcoded to be obj? Would we ever log the
>>> >> subj? Or should obj be part of the function name to make it clear which
>>> >> piece is getting logged?
>>> >>
>> >
>> > I thought of that, though I don't know what variety of option names would be
>> > there to be used with that function.
>> >
>> > If there is a need to use something other than "obj", like, "subj" or even
>> > "tcontext" or "scontext" for example, then I would favour passing the option
>> > name as function parameter - something like "void audit_log_secctx(struct
>> > audit_buffer *ab, char *secname, u32 secid)" or even "void
>> > audit_log_secctx(struct audit_buffer *ab, int secname, u32 secid)" (secname
>> > here being one of 0, 1, 2 ... corresponding to "obj", "subj" etc).
>> >
>> > Similar approach is already used in audit.c - in audit_log_config_change for
>> > example:
>> >
>> > static int audit_log_config_change(char *function_name, int new, int old,
>> > uid_t loginuid, u32 sessionid, u32 sid, int allow_changes)
>> > {
>> >   struct audit_buffer *ab;
>> >   int rc = 0;
>> >
>> >   ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
>> >   audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
>> > old, loginuid, sessionid);
> Hard code for now.  %s in audit record building is the devil since
> there is no enforcement of audit's rather 'special' string encoding
> rules.  If we need another name later we'll cross that bridge when we
> get there, possibly with another helper function and pushing the %s to
> a static function inside audit.  I will not willing expose %s to code
> outside of audit.c.
> 
> Acked-by: Eric Paris <eparis@redhat.com>
> 

Applied, thanks.

I had to fix some overly long lines and whitespace errors in the
patch and the commit message to contain a subject and not have the
entire text contained in two lines.

Please be more careful of this next time.
