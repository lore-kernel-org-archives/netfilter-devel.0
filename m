From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 4th revision] Add SELinux context support to AUDIT target
Date: Mon, 20 Jun 2011 15:21:55 +0100
Message-ID: <4DFF5783.3070808@googlemail.com>
References: <4DF9C085.3040306@googlemail.com> <4DFC9525.2080402@googlemail.com> <201106200820.23127.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
	Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44796 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1FTOWP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:22:15 -0400
Received: by wyb38 with SMTP id 38so1690366wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2011 07:22:14 -0700 (PDT)
In-Reply-To: <201106200820.23127.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Do you think this should be hardcoded to be obj? Would we ever log the subj? Or should 
> obj be part of the function name to make it clear which piece is getting logged?
>   
I thought of that, though I don't know what variety of option names 
would be there to be used with that function.

If there is a need to use something other than "obj", like, "subj" or 
even "tcontext" or "scontext" for example, then I would favour passing 
the option name as function parameter - something like "void 
audit_log_secctx(struct audit_buffer *ab, char *secname, u32 secid)" or 
even "void audit_log_secctx(struct audit_buffer *ab, int secname, u32 
secid)" (secname here being one of 0, 1, 2 ... corresponding to "obj", 
"subj" etc).

Similar approach is already used in audit.c - in audit_log_config_change 
for example:

static int audit_log_config_change(char *function_name, int new, int 
old, uid_t loginuid, u32 sessionid, u32 sid, int allow_changes)
{
    struct audit_buffer *ab;
    int rc = 0;

    ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
    audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, 
new, old, loginuid, sessionid);

