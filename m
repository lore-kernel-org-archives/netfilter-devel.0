From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to iptables-restore
Date: Wed, 07 Nov 2007 20:11:55 +0100
Message-ID: <47320DFB.9000402@endian.com>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr> <4731C14F.50607@endian.com> <Pine.LNX.4.64.0711071737520.20249@fbirervta.pbzchgretzou.qr> <473200BD.10803@endian.com> <Pine.LNX.4.64.0711071931260.20249@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050901070103000501020104"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:54822 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbXKGTMU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:12:20 -0500
In-Reply-To: <Pine.LNX.4.64.0711071931260.20249@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050901070103000501020104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jan

Jan Engelhardt wrote:
> On Nov 7 2007 19:15, Peter Warasin wrote:
>>> Is a dry-run option really needed? iptables-edit does not commit
>> Attention, this is a new option of iptables-restore, not of iptables-edit.

> -t means table for:
[..]
> iptables-restore having -t for test really seems out of place.

i agree.


> That said, iptables-restore does not have a -t, according to its help text
> ("iptables-restore -h") and its manpage.

Thats not true. The current subversion code uses -t for --test. Probably
you confuse with iptables-save ?

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/iptables-restore.c?rev=7087&view=markup
-------- snip -----------------------------------------------
			case 't':
				testing = 1;
				break;
-------- snap -----------------------------------------------

If you want me to change it to --dry-run, i will do that, so i can use
-t for --table.

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------050901070103000501020104
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


--------------050901070103000501020104--
