From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Re: ulogd - does it work with ip_conntrack_netlink?
Date: Fri, 27 Jul 2012 17:22:06 -0700
Message-ID: <CAAJpzgb+nyZSnQvJQzPwhY3KL9O3p0ie0P-Goac=rLfQ5Ts+cA@mail.gmail.com>
References: <CAAJpzgbyuKzb6cPA-TcEu48nJcoUaPJcUkijVB7D88U7SeZh2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35208 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2G1AW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jul 2012 20:22:27 -0400
Received: by obbuo13 with SMTP id uo13so5039460obb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jul 2012 17:22:26 -0700 (PDT)
In-Reply-To: <CAAJpzgbyuKzb6cPA-TcEu48nJcoUaPJcUkijVB7D88U7SeZh2w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If ulogd does not work without nf_conntrack_netlink, is that possible
I can write my own code that interacts ip_conntrack_netlink, and get
the flow based logging? Your advice would be much appreciated.

Thanks & Regards,




On Fri, Jul 27, 2012 at 1:26 PM, Gomathivinayagam Muthuvinayagam
<sankarmail@gmail.com> wrote:
> Hi,
>
> ulogd requires nf_conntrack_netlink for flow based logging. The linux
> version that I have, does not have that. Instead it has
> ip_conntrack_netlink.
> Because of this reason, I think I'm not getting flow based logs. Is
> there any way I can include nf_conntrack_netlink in my system? I'm not
> able to find the packages for that.
>
> Your help would be much appreciated.
>
> Thanks & Regards,
