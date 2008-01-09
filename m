From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH] Fix CONNMARK mask value demolition
Date: Wed, 09 Jan 2008 14:37:12 +0100
Message-ID: <4784CE08.1060908@endian.com>
References: <4780454E.3050803@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000001020709070009070208"
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:57029 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYAINhg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:37:36 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id C4B06598336
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jan 2008 14:37:29 +0100 (CET)
In-Reply-To: <4780454E.3050803@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000001020709070009070208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi

I would not like to create the impression trying to do any pressure on
this topic but i recognized that my patch description maybe was a little
bit poor.
In order to make sure the patch is understood correctly, here the bug
report, of which that patch is the fix:

If you use the CONNMARK target, it makes a difference if you have the -j
option as last option or before the matches.


iptables -t mangle -N test

This works:
iptables -v -t mangle -I test -m connmark --mark 7 -j CONNMARK
--set-mark 0x7/0xf
CONNMARK  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  CONNMARK match
0x7 CONNMARK set 0x7/0xf

This not:
iptables -v -t mangle -I test -j CONNMARK --set-mark 0x7/0xf -m connmark
--mark 7
CONNMARK  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  CONNMARK match
0x7 CONNMARK set 0x7

In the second call, the CONNMARK mask (0xf) will be eaten.

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------000001020709070009070208
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


--------------000001020709070009070208--
