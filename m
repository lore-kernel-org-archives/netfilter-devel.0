From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: NF [PATCH 2/4] xt_TEE
Date: Sun, 25 Nov 2007 20:39:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252030520.13641@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-926093390-1196019562=:13641"
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sebastian Classen <sebastian.classen@freenet.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:37901 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXKYTje (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:39:34 -0500
In-Reply-To: <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-926093390-1196019562=:13641
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 25 Nov 2007, Jan Engelhardt wrote:

>
> Netfilter: Import xt_TEE
>
>
> Originally from Sebastian Classen.
> xt_TEE is the logical successor to ipt_ROUTE; routing based on packet
> charactersitics is done using xt_MARK/iproute2/fwmark nowadays, so
> what remains of ipt_ROUTE is the --tee option, which xt_TEE implements.

IMHO it is not successor as it does not provide all ipt_ROUTE=20
functionality. As I appreciate your work and time spent on cleaning this=20
code I think it would be better not to strip it as xt_MARK/iproute2/fwmark=
=20
is not always a valid option.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-926093390-1196019562=:13641--
