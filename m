From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 12/13] doc: document the -4 and -6 options
Date: Wed, 26 Dec 2012 09:21:46 +0100
Message-ID: <CAHo-OoyZ8gq9zrPVDQzmKCTbGAa7nSgjGY_f05xdrBYQrWiSrA@mail.gmail.com>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
	<1356477089-13241-13-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:35073 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2LZIVr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 03:21:47 -0500
Received: by mail-vb0-f48.google.com with SMTP id fc21so8489459vbb.21
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Dec 2012 00:21:46 -0800 (PST)
In-Reply-To: <1356477089-13241-13-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Should have done this myself.  Thanks.

On Wed, Dec 26, 2012 at 12:11 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  iptables/ip6tables.8.in |    9 +++++++++
>  iptables/iptables.8.in  |    9 +++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
> index dfeebe6..c274e91 100644
> --- a/iptables/ip6tables.8.in
> +++ b/iptables/ip6tables.8.in
> @@ -240,6 +240,15 @@ Give a (currently very brief) description of the command syntax.
>  The following parameters make up a rule specification (as used in the
>  add, delete, insert, replace and append commands).
>  .TP
> +\fB\-4\fP, \fB\-\-ipv4\fP
> +If a rule using the \fB\-4\fP option is inserted with (and only with)
> +ip6tables-restore, it will be silently ignored. Any other uses will throw an
> +error. This option allows to put both IPv4 and IPv6 rules in a single rule file
> +for use with both iptables-restore and ip6tables-restore.
> +.TP
> +\fB\-6\fP, \fB\-\-ipv6\fP
> +This option has no effect in ip6tables and ip6tables-restore.
> +.TP
>  [\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
>  The protocol of the rule or of the packet to check.
>  The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
> diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
> index 9276cf9..22a8478 100644
> --- a/iptables/iptables.8.in
> +++ b/iptables/iptables.8.in
> @@ -243,6 +243,15 @@ Give a (currently very brief) description of the command syntax.
>  The following parameters make up a rule specification (as used in the
>  add, delete, insert, replace and append commands).
>  .TP
> +\fB\-4\fP, \fB\-\-ipv4\fP
> +This option has no effect in iptables and iptables-restore.
> +.TP
> +\fB\-6\fP, \fB\-\-ipv6\fP
> +If a rule using the \fB\-6\fP option is inserted with (and only with)
> +iptables-restore, it will be silently ignored. Any other uses will throw an
> +error. This option allows to put both IPv4 and IPv6 rules in a single rule file
> +for use with both iptables-restore and ip6tables-restore.
> +.TP
>  [\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
>  The protocol of the rule or of the packet to check.
>  The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
