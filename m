From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 08 Nov 2007 11:07:04 +0100
Message-ID: <4732DFC8.9000901@endian.com>
References: <47322D4A.3090201@endian.com> <20071107230852.GA3206@eychenne.org> <Pine.LNX.4.64.0711081001180.4330@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010302050004000809000700"
Cc: =?ISO-8859-1?Q?Herv=E9_Eychenne?= <rv@wallfire.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:55919 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXKHKHV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:07:21 -0500
In-Reply-To: <Pine.LNX.4.64.0711081001180.4330@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010302050004000809000700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Jan Engelhardt wrote:
> On Nov 8 2007 00:08, Hervé Eychenne wrote:
>> - the -d option is generally used (as a debug switch). The one-letter
>>  equivalent of --dry-run is generally -n.

i agree

> -n is commonly used for "numeric", e.g. 134.76.13.21 for output
> rather than linux01.org

-n is currently used for --noflush, probably renaming to -f (?)

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------010302050004000809000700
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


--------------010302050004000809000700--
