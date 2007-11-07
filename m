From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to iptables-restore
Date: Wed, 07 Nov 2007 20:50:01 +0100
Message-ID: <473216E9.1040309@endian.com>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr> <4731C14F.50607@endian.com> <Pine.LNX.4.64.0711071737520.20249@fbirervta.pbzchgretzou.qr> <473200BD.10803@endian.com> <Pine.LNX.4.64.0711071931260.20249@fbirervta.pbzchgretzou.qr> <47320DFB.9000402@endian.com> <Pine.LNX.4.64.0711072026550.20249@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010704010202040408040303"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:54898 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbXKGTuY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:50:24 -0500
In-Reply-To: <Pine.LNX.4.64.0711072026550.20249@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010704010202040408040303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jan

Jan Engelhardt wrote:
> On Nov 7 2007 20:11, Peter Warasin wrote:
>> If you want me to change it to --dry-run, i will do that, so i can use
>> -t for --table.
> 
> be prepared to hear the 'that breaks compatibilty' argument.
> Though, since it's 1.4.0, I'd go for it :p

I imagine :)
Ok, i will try.

BTW: Is somewhere some sort of coding style documentation which i can
read in order to prevent such mistakes, or is it just the linux kernel
coding style?

Some of the malformed style you suggested to change are due to
copy&paste of current iptables code, which i used as reference in some
cases, so i am little confused now.

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------010704010202040408040303
Content-Type: text/x-vcard; charset=utf-8;
 name="peter.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="peter.vcf"

begin:vcard
fn:Peter Warasin
n:;Peter Warasin
org:Endian GmbH/Srl
adr:;;Pillhof 47;Frangart/Frangarto;BZ;I-39010;Italien/Italia
email;internet:peter@endian.com
tel;work:+39 0471 631763
tel;fax:+39 0471 631764
x-mozilla-html:FALSE
url:http://www.endian.com
version:2.1
end:vcard


--------------010704010202040408040303--
