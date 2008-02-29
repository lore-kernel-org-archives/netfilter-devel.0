From: Patrick McHardy <kaber@trash.net>
Subject: Re: Accessing conntrack memory on multicore machine
Date: Fri, 29 Feb 2008 13:17:25 +0100
Message-ID: <47C7F7D5.4040001@trash.net>
References: <005001c87abf$d328d570$797a8050$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:3161 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755183AbYB2MRj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:17:39 -0500
In-Reply-To: <005001c87abf$d328d570$797a8050$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah wrote:
> Now,
>             I am using CONNMARK  target to do mark on conntrack. Here
> packets with direction IP_CT_DIR_ORIGINAL are marked with 1 and packe=
ts with
> direction IP_CT_DIR_REPLY are marked with 2. Now as eth0 and eth1 are=
 served
> by different CPUs, is there chances of =E2=80=93m connmark will get w=
rong values of
> conntrack mark ?


Yes, you should mark the packet and not the connection since
the direction is a property of the packet.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
