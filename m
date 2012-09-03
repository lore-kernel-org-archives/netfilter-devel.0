From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Mon, 3 Sep 2012 04:50:05 -0700
Message-ID: <CAHo-OowkvJe9UQnzwQ3yuYooh4Wd8-xq0kLR8DWRiX9aZbyYjA@mail.gmail.com>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
	<alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
	<CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
	<112224558.YVgvUMStDL@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46574 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2ICLuG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:50:06 -0400
Received: by vbbff1 with SMTP id ff1so5241000vbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Sep 2012 04:50:05 -0700 (PDT)
In-Reply-To: <112224558.YVgvUMStDL@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm not a huge fan of changing userspace visible API...

Deleting this doesn't seem to gain much.
If anything I'd add this into the CT code as just one more thing it registers.

That said, I don't really have a vote here, and don't really want to
do the work...
And cleanup is really good...
OTOH, this cleanup doesn't really help much - it is pretty much
entirely self contained.

(I don't see a clean way to do maintain backward compatibility in the
userspace tool...
it's easy enough to convert to CT on load, but how do you know what to
print it out as afterwards?  Do you just print as the new format?)

On Mon, Sep 3, 2012 at 1:33 AM, Oliver
<olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> wrote:
> On Monday 03 September 2012 15:57:53 you wrote:
>> So no objections from you, right? :)
>
> Meanwhile, -m state lives on.
>
> In all honesty, if you're going to obliterate things like this, it's arguably
> only fair to also implement something in your userland tools to catch the
> change, throw a deprecated warning and appropriately modify it to use CT
> instead.
>
> I would argue the same for those who wish to see the death of -m state (myself
> included)
>
> Regards,
> Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
