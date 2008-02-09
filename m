From: Peter Warasin <peter@endian.com>
Subject: Re: [ULOGD PATCH 1/3] Do not set oob.family in config as it can be
 found in packet.
Date: Sat, 09 Feb 2008 19:13:33 +0100
Message-ID: <47ADED4D.5010102@endian.com>
References: <12023725412-git-send-email-eric@inl.fr> <1202372541106-git-send-email-eric@inl.fr> <47ADE119.7070606@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000707080808030603000809"
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:38167 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYBISNp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:13:45 -0500
In-Reply-To: <47ADE119.7070606@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000707080808030603000809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Pablo

Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
>> WHen using NFLOG or ULOG, obb.family (protocol IPv4 or IPv6) has
>> to be setup manually in ulogd.conf configuration file. This was
..
> Applied. Thanks Eric.

Attention, what's with AF_BRIDGE then?
It's not more possible to register a log handler for AF_BRIDGE with
this patch applied.
Packets coming from ebtables will use that protocol.

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------000707080808030603000809
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


--------------000707080808030603000809--
