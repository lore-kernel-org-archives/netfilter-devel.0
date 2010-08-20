From: krunal patel <krunal.raj@gmail.com>
Subject: socket filter
Date: Fri, 20 Aug 2010 09:57:33 +0530
Message-ID: <AANLkTi=_YJTBy5pPfgBAi-cNt=ock0UGGcdD=X94YtUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58334 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0HTE1f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Aug 2010 00:27:35 -0400
Received: by bwz11 with SMTP id 11so1788096bwz.19
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Aug 2010 21:27:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

There are ioctl's for attaching bpf like filters to socket. I found it
in kernel documentation.
    setsockopt(sockfd, SOL_SOCKET, SO_ATTACH_FILTER, &Filter, sizeof(Filter));
I doubt is can we attach filters in case of netlink socket.
I am logging all packets using ULOG target and using ulogd.
Is it possible to use same ioctl for netlink socket we create in ulogd?
