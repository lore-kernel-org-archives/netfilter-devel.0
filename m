From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Tue, 18 Jan 2011 09:37:28 -0800
Message-ID: <AANLkTi=YWWM-ScWU6GZaYT3AszGi4-92Leya=hqOUQbX@mail.gmail.com>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
	<4D35BCC7.90805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56257 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1ARRhc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:37:32 -0500
Received: by bwz15 with SMTP id 15so3599543bwz.19
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jan 2011 09:37:30 -0800 (PST)
In-Reply-To: <4D35BCC7.90805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 18, 2011 at 8:16 AM, Patrick McHardy <kaber@trash.net> wrote:
> On 18.01.2011 16:38, Jan Engelhardt wrote:
>> bug report http://bugzilla.netfilter.org/show_bug.cgi?id=694 , though
>> being written in a heated fashion, did prompt me to revisit the
>> actual issue. While I have to question why users are relying on
>> inferior filesystems (the issue was raised before on the lists), I
>> feel inclined to solve bugs.
>
> Well, I don't see any benefit in causing so much churn just for
> *one* user, who has been feeling unhappy about his scripts not
> working properly.

It is a lot of churn, but it might be more than scripts. I've had
occaison to check out code on case-insensitive filesystems for the
purpose of reading it (Apple's and MS's), and had the checked files
trash each other because the file system considers the names to be the
same. Its annoying, even if it is the filesystem's fault. Though not
recently, not netfilter, and not with git.

Cheers,
Sam
