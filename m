From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 4th revision] Add SELinux context support to AUDIT target
Date: Mon, 20 Jun 2011 08:20:22 -0400
Message-ID: <201106200820.23127.sgrubb@redhat.com>
References: <4DF9C085.3040306@googlemail.com> <4DFC9525.2080402@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1FTMUk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:20:40 -0400
In-Reply-To: <4DFC9525.2080402@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday, June 18, 2011 08:08:05 AM Mr Dash Four wrote:
> +#ifdef CONFIG_SECURITY
> +/**
> + * audit_log_secctx - Converts and logs SELinux context
> + * @ab: audit_buffer
> + * @secid: security number
> + *
> + * This is a helper function that calls security_secid_to_secctx to
> convert secid to secctx + * and then adds the (converted) SELinux context
> to the audit log + * by calling audit_log_format, thus also preventing
> leak of internal secid to userspace. + * If secid cannot be converted
> audit_panic is called.
> + */
> +void audit_log_secctx(struct audit_buffer *ab, u32 secid)
> +{
> +	u32 len;
> +	char *secctx;
> +
> +	if (security_secid_to_secctx(secid, &secctx, &len)) {
> +		audit_panic("Cannot convert secid to context");
> +	} else {
> +		audit_log_format(ab, " obj=%s", secctx);
> +		security_release_secctx(secctx, len);

Eric,

Do you think this should be hardcoded to be obj? Would we ever log the subj? Or should 
obj be part of the function name to make it clear which piece is getting logged?

-Steve

