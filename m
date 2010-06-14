From: Narendra Choyal <narendrachoyal@gmail.com>
Subject: Re: Using conntrack to create new expectation entry
Date: Tue, 15 Jun 2010 01:27:16 +0530
Message-ID: <AANLkTik5ejkWJDclzJtMQt8paJiYJLcYhM78DR0_iSI9@mail.gmail.com>
References: <4C15E69D.3070400@cea.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: GLAUME Vincent <vincent.glaume@cea.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35711 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0FNUDI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:03:08 -0400
Received: by gye5 with SMTP id 5so2732923gye.19
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 13:03:07 -0700 (PDT)
In-Reply-To: <4C15E69D.3070400@cea.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

:)

On Mon, Jun 14, 2010 at 1:51 PM, GLAUME Vincent <vincent.glaume@cea.fr>=
 wrote:
> Hi there,
>
> I'm currently trying to figure out how the whole libnetfilter_conntra=
ck
> works, and more precisely the expect part of the lib.
> My aim is to be able to create new expectation entries with this lib =
in an
> application that would inspect packets (either coming from a pcap-bas=
ed
> sniffer or from netfilter via the nfqueue mechanism) : thus I'd like =
to
> allow connections related to the inspected (and already allowed)
> connections.
>
> My various tests make me think that to create such an expectation ent=
ry, a
> kernel module related to the master connection is required: am I righ=
t?
> For instance, the "expect_create" app in the libnetfilter_conntrack "=
utils"
> subdirectory works fine, unless I modify the destination port of the =
master
> conntrack structure... then it's no longer related to the FTP conntra=
ck
> mechanism...
> Same thing happens when using the conntrack app. from the conntrack-t=
ools.
>
> So, I'd like to know how to do this the right way, without coding the=
 whole
> inspection thing in a kernel module (if this is possible). Is there a=
ny
> generic tcp conntrack system that could help here?
> As I'm not too sure to fully understand the whole mechanism of expect=
ed
> connection creation, any hint is welcome!
> I hope this is not too confused... Thanks,
>
> --
> V.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
