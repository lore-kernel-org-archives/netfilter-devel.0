From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: ulogd - does it work with ip_conntrack_netlink?
Date: Fri, 27 Jul 2012 13:26:42 -0700
Message-ID: <CAAJpzgbyuKzb6cPA-TcEu48nJcoUaPJcUkijVB7D88U7SeZh2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44739 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2G0U1D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:27:03 -0400
Received: by gglu4 with SMTP id u4so3625209ggl.19
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jul 2012 13:27:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

ulogd requires nf_conntrack_netlink for flow based logging. The linux
version that I have, does not have that. Instead it has
ip_conntrack_netlink.
Because of this reason, I think I'm not getting flow based logs. Is
there any way I can include nf_conntrack_netlink in my system? I'm not
able to find the packages for that.

Your help would be much appreciated.

Thanks & Regards,
