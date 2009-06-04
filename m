From: Emiliano Romero <emilianoromero@gmail.com>
Subject: Re: Nat+Iptables+Tcp Keepalive Problem
Date: Thu, 04 Jun 2009 12:53:55 -0300
Message-ID: <4A27EE13.5000303@gmail.com>
References: <4A27C999.3000609@gmail.com> <alpine.DEB.2.00.0906041656220.16139@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:52792 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbZFDQB0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:01:26 -0400
Received: by qw-out-2122.google.com with SMTP id 5so595870qwd.37
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2009 09:01:28 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.0906041656220.16139@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik escribi=F3:
> The TCP keepalived packet in the output above is invalid: it's sequen=
ce=20
> number is wrong.
>=20
> Best regards,
> Jozsef

Thanks for your reply Jozsef. After your reply I look at RFC 1122, It s=
ay:
"Some TCP implementations, however, have included a keep-alive=20
mechanism.  To confirm that an idle connection is still active, these=20
implementations send a probe segment designed to elicit a response from=
=20
the peer TCP.  Such a segment generally contains SEG.SEQ =3D SND.NXT-1"
=2E.."so that this SEG.SEQ will be outside the window.  Therefore, the=20
probe causes the receiver to return an acknowledgment segment"

When I try with a linux box sending TCP KA, I see that this sets the AC=
K=20
flag on TCP KeepAlive and that works correctly. I think that my remote=20
equipments (GPRS Modems) are making TCP KA is the wrong way. Or maybe=20
the GPRS Service Provider are touching my packets.

Thanks Again.

Regards
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
