Received: from smtpfb1-g21.free.fr (smtpfb1-g21.free.fr [212.27.42.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377ED2343B6
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 21:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760302806; cv=none; b=R0iLluAxyZL97v5kR+mCUTx4JufmZ3bjyhGWaO2pw4mmWYPxPkWQXMCmyyXbHD/oNo/ZQiUyFbbsNEEpCmKwleQm+goUHfs1HZkLAXw4bXZ51c/rWdPk0hZtlTqXAAM11KqBBiKgG/jd9yAQ+LSWZUu2OW3KWYLJUp6VjhxWcyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760302806; c=relaxed/simple;
	bh=EdRTsQHlz0s3B2bNaorLiuNzxgXKgNQmmva2s+eHj10=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=ayZj5BiqWKK9J7vC9xEW6n8YU/H0vhO9oSXTk0BmVhj1DFa+YNs1teDobL4gfVaEyRRGA3b1WpSgZp9mHrDWmOhxyAkoqXXSQwfuB//EZtpAQxXQYfPf2WIzRXSxLrXyrzX1p9DlCvzdj6/l+Modqa9iOfWiD4WFbFAZ2kery1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=rp+f7Fna; arc=none smtp.client-ip=212.27.42.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="rp+f7Fna"
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 8AA1DDF8872
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 22:59:53 +0200 (CEST)
Received: from zimbra62-e11.priv.proxad.net (unknown [172.20.243.212])
	by smtp1-g21.free.fr (Postfix) with ESMTP id A66C7B00539
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 22:59:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1760302786;
	bh=EdRTsQHlz0s3B2bNaorLiuNzxgXKgNQmmva2s+eHj10=;
	h=Date:From:To:Subject:From;
	b=rp+f7Fna8rmypB0AjR1AvkT1NP9SjgFgfJH6pFv2FzNwQTCSPGGafAXHABPasyJOD
	 9W+cYMGrbP6Fh0KNpn57ANWgKtLe5YFaBGUR1SXnKTRu6nf5B5yzif+bn1jISa/pIY
	 Dz5OeiuH7ZyaTB8Lr8BFBa791x4khJRBSkHIoUb9LIee5jTL7NSrMzfOXoDnLuiYYo
	 mHUd/w82pWRUmqDp+Bv/18kF+bhhXbhRgM4xr4tivNZnwA9MD9Ce9zcacbPr5X7Mke
	 iRq1z/iESYcbLRDJXCw01+QLMCvoOa0FHh58951aWLoMVxmUwAtzrNxqSOb0mpIqRd
	 X5KTYEeOTtnkw==
Date: Sun, 12 Oct 2025 22:59:46 +0200 (CEST)
From: "Antoine C." <acalando@free.fr>
To: netfilter-devel@vger.kernel.org
Message-ID: <2093285391.1388199126.1760302786604.JavaMail.root@zimbra62-e11.priv.proxad.net>
Subject: bug report: MAC src + protocol optiomization failing with 802.1Q
 frames
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.2.0-GA2598 (zclient/7.2.0-GA2598)
X-Authenticated-User: acalando@free.fr

Hello,

Following the mails I sent on the user mailing list, it seems that
there is a bug occurring with the first rule below (the second is
fine):

# nft list table netdev t
table netdev t {
        chain c {
              ether saddr aa:bb:cc:dd:00:38 ip saddr 192.168.140.56 \
log prefix "--tests 1&2 --"
              ip saddr 192.168.140.56 ether saddr aa:bb:cc:dd:00:38 \
log prefix "--tests 2&1 --"
        }
}

It is translated this way:
netdev t c
  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 8b @ link header + 6 => reg 1 ]
  [ cmp eq reg 1 0xddccbbaa 0x00083800 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x388ca8c0 ]
  [ log prefix --tests 1&2 -- ]

The MAC source and the protocol are loaded at the same time
then checked... but with an 802.1Q packet, it is actually 
wrong: the ethertype will be 0x8100 and the protocol (here 
IPv4, 0x0800), will be 4 bytes further. And it that case,
the second test above will succeed because the protocol 
is loaded independently.

I just tested with latest versions of libmnl/libnftnl/nft 
and I get the same behavior.

The mail on the netfilter-user ML:
https://marc.info/?l=netfilter&m=176011821517829

Regards,
Antoine
