From: Sam Liddicott <sam@liddicott.com>
Subject: Re: Patches to xtables-addons xt_quota2
Date: Thu, 9 Jan 2014 13:35:11 +0000
Message-ID: <CAOj-5WApVv8Q8BOzHewhoWJ_H=1EA6GwUUsQEqR-kwvB6iMpMg@mail.gmail.com>
References: <CAOj-5WAsU-WxdKbP1ijmhRGAO=u204ZyGM5PZNcrsJoOB1hsug@mail.gmail.com>
	<alpine.LSU.2.11.1401091004570.32765@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:33651 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaAINfN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:35:13 -0500
Received: by mail-qe0-f53.google.com with SMTP id t7so3055303qeb.26
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jan 2014 05:35:12 -0800 (PST)
In-Reply-To: <alpine.LSU.2.11.1401091004570.32765@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

True, it doesn't fix all problems. I don't mind if you strip that part
before applying.

Sam

On Thu, Jan 9, 2014 at 9:07 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Tuesday 2014-01-07 19:56, Sam Liddicott wrote:
>>[0003]
>>@@ -79,9 +80,35 @@ quota_proc_write(struct file *file, const char __user *input,
>>       if (size < sizeof(buf))
>>               buf[size]=0;
>>
>>-      spin_lock_bh(&e->lock);
>>-      e->quota = simple_strtoull(buf, NULL, 0);
>>-      spin_unlock_bh(&e->lock);
>>+      while (isspace(*c))
>>+              c++;
>>+
>>+      if (size - (c - buf) < 1) /* min string length */
>>+              return c - buf;
>
> Because @input is copied to @buf and that is size-limited, a string like
>  "                  +-123"
> would be recognizd as -12 rather than -123. So, don't bother with
> spaces at all.
