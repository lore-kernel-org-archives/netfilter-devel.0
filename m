From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] iptables: add manual page section for AUDIT target
Date: Tue, 15 Mar 2011 19:28:47 -0700
Message-ID: <20110315192847.27cb35fb@nehalam>
References: <20110316002620.GA26145@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:45032 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1CPC2v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:28:51 -0400
In-Reply-To: <20110316002620.GA26145@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 15 Mar 2011 20:26:20 -0400
Thomas Graf <tgraf@infradead.org> wrote:

> 
> Signed-off-by: Thomas Graf <tgraf@redhat.com>
> 
> diff --git a/extensions/libxt_AUDIT.man b/extensions/libxt_AUDIT.man
> new file mode 100644
> index 0000000..cd79696
> --- /dev/null
> +++ b/extensions/libxt_AUDIT.man
> @@ -0,0 +1,14 @@
> +This target allows to create audit records for packets hitting the target.
> +It can be used to record accepted, dropped, and rejected packets. See
> +auditd(8) for additional details.
> +.TP
> +\fB\-\-type\fP {\fBaccept\fP|\fBdrop\fP|\fBreject\fP}
> +Set type of audit record.
> +.PP
> +Example:
> +.IP
> +iptables \-N AUDIT_DROP
> +.IP
> +iptables \-A AUDIT_DROP \-j AUDIT \-\-type drop
> +.IP
> +iptables \-A AUDIT_DROP \-j DROP
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied to net-next

-- 
