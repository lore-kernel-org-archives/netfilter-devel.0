From: Peter Warasin <peter@endian.com>
Subject: Re: [ULOGD PATCH 1/3] Do not set oob.family in config as it can be
 found in packet.
Date: Fri, 08 Feb 2008 18:49:14 +0100
Message-ID: <47AC961A.3090204@endian.com>
References: <12023725412-git-send-email-eric@inl.fr> <1202372541106-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060102040801060906040309"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:36176 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476AbYBHRti (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:49:38 -0500
In-Reply-To: <1202372541106-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060102040801060906040309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Eric

Eric Leblond wrote:
> WHen using NFLOG or ULOG, obb.family (protocol IPv4 or IPv6) has
> to be setup manually in ulogd.conf configuration file. This was
> used to have the BASE filter parse accordingly the packet. This
> patch suppress oob.family as output keys of NFLOG and ULOG and let
> the BASE filter determine the family of the packet by itself (by
> parsing the raw header).

That field is necessary if NFLOG logging should also work from within
ebtables (I sent ebtables patches recently).
Sending from ebtables oob.family is AF_BRIDGE, since there could also
come arp packets to be logged.

Configuring the addressfamily manually within the configuration file
is how you then register the log handler for AF_BRIDGE. It is not
always necessary to have that handler registered, so it's good
practice to decide this by configuration file, i think.

What you say?

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------060102040801060906040309
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


--------------060102040801060906040309--
