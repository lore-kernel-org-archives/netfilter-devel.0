From: Sam Liddicott <sam@liddicott.com>
Subject: Re: Patches to xtables-addons xt_quota2
Date: Wed, 8 Jan 2014 10:12:35 +0000
Message-ID: <CAOj-5WD_+rGGZXA7X1FaMVUgkRJAPbpgwy6Ax1YnQDBpRbtPPA@mail.gmail.com>
References: <CAOj-5WAsU-WxdKbP1ijmhRGAO=u204ZyGM5PZNcrsJoOB1hsug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:55997 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaAHKMg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:12:36 -0500
Received: by mail-qc0-f181.google.com with SMTP id e9so1070183qcy.40
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2014 02:12:35 -0800 (PST)
In-Reply-To: <CAOj-5WAsU-WxdKbP1ijmhRGAO=u204ZyGM5PZNcrsJoOB1hsug@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because of a diversion in my private tree patch 3 did not compile due
to missing include directive. I'm doing a merge request via
sourceforge for one that does.

Sam

On Tue, Jan 7, 2014 at 6:56 PM, Sam Liddicott <sam@liddicott.com> wrote:
> 0001,0002 fix bugs, 0003 adds new feature of incremental changes to quota files.
>
> They apply to HEAD of xtables-addons on sourceforge
>
> These patches should be self explanatory but may need some review as I
> have tried to preserve existing style rather than refactor but you may
> prefer to refactor. There was also some confusion on locking in the
> increment support patch and I'm not sure if I have it right.
>
> Sam
