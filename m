From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Patches to xtables-addons xt_quota2
Date: Thu, 9 Jan 2014 10:07:43 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1401091004570.32765@nerf08.vanv.qr>
References: <CAOj-5WAsU-WxdKbP1ijmhRGAO=u204ZyGM5PZNcrsJoOB1hsug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sam Liddicott <sam@liddicott.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:37632 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaAIJHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:07:45 -0500
In-Reply-To: <CAOj-5WAsU-WxdKbP1ijmhRGAO=u204ZyGM5PZNcrsJoOB1hsug@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2014-01-07 19:56, Sam Liddicott wrote:
>[0003]
>@@ -79,9 +80,35 @@ quota_proc_write(struct file *file, const char __user *input,
> 	if (size < sizeof(buf))
> 		buf[size]=0;
> 
>-	spin_lock_bh(&e->lock);
>-	e->quota = simple_strtoull(buf, NULL, 0);
>-	spin_unlock_bh(&e->lock);
>+	while (isspace(*c))
>+		c++;
>+
>+	if (size - (c - buf) < 1) /* min string length */
>+		return c - buf;

Because @input is copied to @buf and that is size-limited, a string like
 "                  +-123"
would be recognizd as -12 rather than -123. So, don't bother with
spaces at all.
