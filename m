Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288E018DB2A
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739714493; cv=none; b=sRN6duaxeRgRycCFGwrixPJOISBny7xRJGSfOdZPYG8JD11Uw1FvRfC5bEFhsJrBiWQKwAhq78+zcPufMlHFTRBkOqtANr1HNxwqZgqYQ9K47l4p1skDDynNlCNXnNV4lyPqsVdPwS6aA/V1mzt2M7mzhGdLy1XSgppIUYyabb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739714493; c=relaxed/simple;
	bh=PtJgE3D2789A38LVe6FLN59wv114qecs5ydqPmePBk0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=j2nnRvkYLPi0+ZqaO94eIRqci41/8YjKf5puQG/X3AqR2Wks5l0/4EoLPljCYCbB4H9TOUlOulFYYhpQU+e0yO8uq/+IRaIyNtCq9gzsFQMteOBHeMkrpSTphtoBdBf8P5BaphT1nw45K1e9FE9rGos5aHIPe7ebzRG86H3cJLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=nVyaaqbK; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="nVyaaqbK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739714488; x=1740319288; i=corubba@gmx.de;
	bh=mPvG4vFWSrzfIxjLlCfMBtToFS0epEFW3aF0UDUYSwo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=nVyaaqbK1kQS3sRtn3pds83MOvZ55IMyXN8sKFYAkJBnq5I1YNXnA1JiuvvQm6zq
	 0fz53pTHXn8Irl6+dilNBYZXk/lGG08TQrfpsH8H6LfEeTQ/nF/Gpf9RxKvX7Mwyo
	 q37ziUCwD9usmVK37Ok4TSos7PayjJBfz1JKpcbLg1yIuWsGAA07TtuNS1uxQLmNP
	 DHSTaegwnbkNJr6ayWqhdlxwSGEQaRH5sj/9bO65RSQ91sko+v4X1PpbaPitWdLa8
	 34ZBZ+wFTMjS1ZB3NB8NtAMIixqupv7TuVLoA+kuDTFGIlKbIP6/PrWioaITvFAE/
	 CqQ6TZvIPB2cpkZCCQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.182]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MXGr8-1troQA0Une-00OIq3 for
 <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 15:01:28 +0100
Message-ID: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
Date: Sun, 16 Feb 2025 15:01:04 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2 v2 0/3] Three small bugfixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uBslqZMZpF0abFHYU+78nzvhxk4aumsCNXuy5AKz/MSu3MGob2D
 8yQGpWPIhBfQDYZGyjJhe/MsqXoUngR0Nh2DOm6AQobDVwHWp8X6+D2eIhZbviTJk5TT7Dm
 WeBT0Htq5DUi2KNKz1HyxsV3tf2k845UoErwvj2/IWRmi8UpmKkYILAJdlv1c30TcSZ9/22
 hNiLtQ+lNtnzmpZPXPJeQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vtARUHdfmHs=;ZqbQB3sYNE8DaDZfeGLSp9udaaO
 8WOLK/LahkkNkMzuxyqkaItIJBHu/gzC+Ug0PBeB+lI7iSTEH7QpQ3wgeIgZ/9+2ucVsmpgar
 M3FvIibDNS97Kd6gh1v183s3sZwuI+iNkBN/2cq6y2BV2N1wtCyUfH0XqqPDlVslhBOnMpYrx
 PjN0eNP+1Hd0s9nTc/Pvjc94PoDtj74Nfg4N89AfC4OT4bvruzFB7HXf+O3xEqW0g9lkW0Ota
 DmRQxGXLGFntku9VY3JxYLKMsBvCkD6pUZhODSD9cSsUozAAMosmHVhtyW/RNYMDqg5xGh+6P
 T6zXQs3VHnJkNUiBDZ1A15tHW/AoiOHCrnCKLAlipSGZk4itCLrAu6rprd4Is4w6F8oZ+YFW9
 j1qT5j56XnVTzFaAJ9e0Mw0NBdd92TkoXlL5QrE9t5VpZ+UDbZGVfBdDAn0C3l2rLgMumgdAB
 UqiZNMZZGtvFDk1XX1TGb+I8OUo5xXqx6Id9+zqgzXnmkDFOvbessOVU5kz/F/7kK0KTx6uCp
 h19koz2tadIoqyLcOY0Ypumr130QidRZeNeItniOjd+HCXoaFwP7ZJoBiMqUfpm2amJu6byVF
 o2zPb07qa0vaflsPRYbUrD7nMkB6hAyzkS3pWrOCYrGHLj4zcUkw6kXTRW0VlMS8GV69Wl2mK
 8BX9jFWlHU1Tb3DsUKTWl9ROUni8i4zLE07KBys+83hffoidSRSa2YKsyv93Um4HGHynTxJgH
 JgLn1bqCpjCh6vYZTbQKYQi8Ur4XrH5/SL3/jg+VcFqccoLwiRIlU3kRFdFylvy1Tsy12buO2
 0TYwqVUaCxdKqbI1x9vAkoI3Hqykx2iQysYvvPA6+E2aixhdd9ieJCNpe942WW+k3A0mpCY2Q
 J9xGNxALHMQ0ESrx0Y/4pHYwpMbO7aO76tl1jvEkzQlHpEGjnJXBpv5cOtyiVnUEQfGraftV0
 HOmOq+NjcTrp2IIHYu20kwdhVQIhgRHC/2HdZt37D0eM/dEz21/75x816CbnksOhN26mT4Rf/
 4o3fSISMsqo6RIH4fQUV0Hzm5/hpvrzbm4j1fQGLylHJjPpwq5b1i+ayE7bxo1tdUojqYyvIg
 9GwKV4Lyhr82WqqDW83af3/1h2JRqmK9Vdt8MYSWPZXR2IUC/f37dHMYeatcVm/liZwV/H7WP
 zl/tGrCyu+lUrUo3wFaDLwA5HWvDIuE4jG7iALiRo25TcAIB+UrtDb/SBdL131pOGv7dGoVDo
 9DrmTb4LRKnHnHo0pYD5wMdBm+Fij3Ce5aKdRSF2kOIANhpVgJmwpfZsbJl7H8Y5c5LilJ6+I
 NiB6+wvC47tPavVuwufAiIyXtfCYsW/v7ds2RCP7F1clwSghzJW8+KOrCRjOHOzeahP0znrLn
 brTw5k/0s4a5OC0LoYEoRHFD0wtuVQ0MYeL1KirgeF4PM1p8gAkm50OmPVIbd7M39LSdTbXfD
 PFvKnhQ==

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

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - Like OPRINT, GPRINT now uses an intermediate buffer (Jeremy Sowden)
  - Reword/Reformat commit messages
  - Link to v1: https://lore.kernel.org/netfilter-devel/0a983b51-9a51-47a7=
-bbdc-9bf163a88bbd@gmx.de/

Corubba Smith (3):
  nfct: add newline to reliable log message
  gprint: fix comma after ip addresses
  ipfix: re-arm send timer

 input/flow/ulogd_inpflow_NFCT.c   | 2 +-
 output/ipfix/ulogd_output_IPFIX.c | 8 ++++++--
 output/ulogd_output_GPRINT.c      | 7 +++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

=2D-
2.48.1
