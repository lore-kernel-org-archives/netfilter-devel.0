Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6529F9DA
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739022411; cv=none; b=PmYtacPseoYUhqYcUbDOE2TeKJ/Z4eCpPjJ1wrmmFj/gTWO2EwNkfb98EJtFUQfYG6V8Sr0B0naKM57iOBdoBN+e5Z3JGtSTLhSkIg7veDynq52kMoGroRFR0eW+HHjxujovqQGuglwhn4kQ5/9Xx+i4bSrqWT4FmUEGJBmwrZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739022411; c=relaxed/simple;
	bh=KyGnZOLtGsZvXUZ5F/+gyc2V4bIh39o2C7MehqYnbG0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=VyoT96eObSdsvh8rR8mX/93YYaBWFBisKHbMs/57LHJg0i3jWxKH622fHH5LYdHhk3WGYNUqxSjUmuRfZhUw85tUoSy+9e8Es3mUl9KXS2mtm/Cxz2lJwf08fNVwg0azH9NgHVAHsdfZ0WorNHvWwhBSZIvbaX109fqYTIHyrrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=kv5Y1ro7; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="kv5Y1ro7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739022407; x=1739627207; i=corubba@gmx.de;
	bh=pz6ebX/T0ReqTxEzliA5xwhinAd8cFd9disN8aWR90A=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kv5Y1ro7uQ7maU3Qcw/7n4n8WLDXLyOFuNvK82NBS3WDspqLBcI9xH5U/b/1FxdI
	 lnR7IcwhK38vkkKjOZ+d3uaG9PushA4lijC7pShUGexo8fTMfEPoXBSjX+XfZf0BS
	 pEzjZpOHFaL3RNKvq/jGoSQWj6nSSjdI6mj9ZtJq9UIFqlWuvQX5/CiEn+/NYI3nc
	 PrQ+qttHseXPsLWl9Zw4fvHHcGqOQJOS11CL/8wlw10EI+ZHZFO40kKbMWmDqSONm
	 5xw2dXxqmlK/+0swsTGVD1Tnk69a8Q54e/BitLA2Pnnwvo7PdhjMrZx/k0IahhtII
	 evMNrdLMTC+vRkK4iw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.92]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mq2nK-1t2jfI4B6o-00ZkgI for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Feb 2025 14:46:47 +0100
Message-ID: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Date: Sat, 8 Feb 2025 14:46:46 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-CH, en-GB
From: corubba <corubba@gmx.de>
Subject: [PATCH ulogd2 0/3] Three small bugfixes
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tR4pD8ll1X3ybZGczhcMbUGBVh45T+w8/PL5LNxRIXhalDgKWM1
 +mmiJvy+44XA/Hx27fbU7d3oy/rlrIFQdPXAwVwZtSbiEhLia81zr6MUk6Y3gkzAninzSeZ
 hhPuqeY8WUWC7fOq1YcUItPDMgvUkX3PYoZnbnFJdRt5ezeejozJCvjLz7tEGP/XlZFOPb/
 oH6idsbclVK6kWVs4wR8g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Z016DyB/m5M=;cBN6HnTQO4xPBrw7bOYPiQ84NXm
 Ew7faIZNpba1k8AzaYpmtmu9jqkYfsRoVsG3L8146HBUUa4yjTAXS1rydzs0tA/bTt8QAK6nF
 mxoJ3WkiPcaP8BK4jIp6LDSe0r0HIIXaIBpt9ld3XvND0CaHATzxeU3Ct+znXIAp2qXJZjMsn
 WyipA5rHYg1HgNSU49Y7FGOE/ArpXSYwNUWBsH5CQ1rMcdZIkrPS4a6D2/uAEmoqUo0JzthMT
 vK/Rws3SxF3jdlxCM9rFvNSiLZyNrlYqQjgTRIDmttSeRT8QIUTjbRzzHHpnmkFGByU+WX2x8
 7kQzKSHTe+d0eFF0CTtmJ7Gnb9pcfVU0trPxKlofi/hok7TQoohDWayQJcSGkaLoHz2VPxh8B
 Wd8f71I3Vrhtj8gDVQ2Z8I651KFUL8eS4PRfPqLy+Y4SZS7gYAaHtl7p5hUDab+vOkMe9NBCR
 meRyuw73k6VTtmgCq7k/+b26sIfuJTPb/z9Qkj+H6E4bzFTatdl+xF5R4niiCicCzu5GhJBHl
 m/3ahlsSHc0vSo2S35L/qCCNMAzJ+7ghkg22ZaO+Qg3l5r54LJFXhgbU6gs4ZLdg2RX9FK5Ll
 FKlQcgRKEHRn/jJIqSkv9BNcx3KgXVkWG6ZIoNQuEEtMEl2tRR2VtBj+XsaeAWk59VQE7rV0D
 6NankQ1d9iHzs+ZCIiSdWGybfJrGi4mmhQiZoEjUxAlTPcoG0trSzeQ66nKlyBG7+jXLucItu
 mHopnsRyYvhi2pmS1xYfadx1/aeo88nDwTljRHuiDm+d1sDu+Ci+C18VbdmqkUfhHJNYqVikQ
 BAt77e0ek2ju2pjRDPvlapW4D5husNCHXWNBxM5Rq3pEBcLWSmhKXpxx6G+ACuXoK2FsHN2WU
 vjwPuU2erz6/9ggolUsuEZPKjhIpPwrgta03fIG3DKQGytaJIQXaGOYRqBu4kScfDIb5bVnpE
 t1C7Af+mwi9HutKVqRSyDmh9YmYKVnVfdieiBGGaB0Pxl26VSeiVx6Kkf1tAx4seDmJjA7zMe
 X1rN3zxID9JK4NvobPcqzHPcMk8pk4s+jHcEkmEm0TRsg0OZxgpWmS/OZ++REr/oxXoEUytvK
 3yWGT66VqTsYlgvFIyN6T5N/pggHpLziKNzL5faPX30BUBUhzMx+/XA505z8Hmz9vieq259H9
 S+cZgpWj76k5o255XYweKGY+hrKeMghIPrTHLMxkF6fJTrYG/UZ3XkDUyrYq7NcHiE3unuZ0y
 dTm017hVtToLBCq7NPxHShnr+5Utog5u4PN8UqAhWnSR+VMo2VBoVNIrVRNeqPo1jfrqhSy4I
 bcp3gbOxMOdNLtdGI6KownJ8H09uDOmC+s6bbd/hc5B+sAQbori8NVhmZ+FWF6zZNCYD7fWXK
 sUosyK7yD5V5prj0Bft57aSlJkk0zv5JLKmBsmZ6CL3k6KIYD1IV90EzRQt2wVVMFgPak15zH
 KysUqag==

This patchset contains three small bugfixes for the NFCT, GPRINT and
IPFIX plugins of ulogd2.

The first patch adds a missing newline to a log message of the NFCT
input plugin. The seconds patch adds the missing comma separator after
an ip address in the output of the GRPINT output plugin. The third patch
fixes the timer in the IPFIX output plugin, which (I assume) is meant to
ensure the messages are sent out in a timely manner.

The first two patches are pretty trivial and self-explanatory. The third
patch is based on my interpretation of how the plugin is supposed to
work, because this architectural detail isn't explained in the original
patchset nor discussed in their mailinglist-threads [0] [1]. I was also
unable to locate the original 2009 code from Holger Eitzenberger that
this is based on for comparison. I may have drawn the wrong conclusion,
so please feel free to form your own opinion if it is correct.


[0] https://lore.kernel.org/netfilter-devel/523542b5-d629-54d9-2a90-468a9c=
b3aba7@juaristi.eus/
[1] https://lore.kernel.org/netfilter-devel/20190426075807.7528-1-a@juaris=
ti.eus/


Corubba Smith (3):
  nfct: add newline to reliable log message
  gprint: fix comma after ip addresses
  ipfix: re-arm send timer

 input/flow/ulogd_inpflow_NFCT.c   | 2 +-
 output/ipfix/ulogd_output_IPFIX.c | 8 ++++++--
 output/ulogd_output_GPRINT.c      | 6 ++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

=2D-
2.48.1
