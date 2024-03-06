Received: from mail.bugwerft.de (mail.bugwerft.de [46.23.86.59])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFA01350FA
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.23.86.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709739785; cv=none; b=qnox1IyzuMSeCLoITuoJanNqMrRGvJ6jL6xojddcC8KBGMZi5cOmBsw21XyswuFeknQ+zRnzRCpZHrji/lMNDIiKLDMabGwIS7FIRrYc3Ls4Y8zTugBdNzqaHm4bdDttlecket+5sehgUSWG7yOzdeUPkQr93P8lqw3xChawf5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709739785; c=relaxed/simple;
	bh=MWjX+YsoW/4hef3vTOrIOiy9BvaZSm1/+lKc7TbaNc4=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=kaodGx5fXcXNAztDb2/q6u8k0z4jMj30gbps/nyASh7wbqfJP/nBNTCHITydH358OIU1AXNpo2knPL5gVbfa/Nt1lzmHCpOqiKG24OF0IZ/8wFl+Ujg4nUh9fNogzGJKsWPOPHqQy2UFdQZeCv7fPFlnVMHIsbYX23/ky5dydws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zonque.org; spf=pass smtp.mailfrom=zonque.org; arc=none smtp.client-ip=46.23.86.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zonque.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zonque.org
Received: from [192.168.100.26] (unknown [62.214.9.170])
	by mail.bugwerft.de (Postfix) with ESMTPSA id 6CB84281561
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 15:43:02 +0000 (UTC)
Message-ID: <ba22c8bd-4fff-40e5-81c3-50538b8c70b5@zonque.org>
Date: Wed, 6 Mar 2024 16:43:02 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Daniel Mack <daniel@zonque.org>
To: netfilter-devel@vger.kernel.org
Subject: Issues with netdev egress hooks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I am using the NFT egress hook in a netdev table with 'set' statements
to adjust the source MAC and IP addresses before duplicating packets to
another interface:

table netdev dummy {
  chain egress {
    type filter hook egress device "dummy" priority 0;
    ether type ip ether saddr set 01:02:03:04:05:06 ip saddr set 1.1.1.1
dup to "eth0"
  }
}

Does this rule look okay or am I holding it wrong?

The modification of the sender's MAC address works fine. However, the
adjustment of the source IP is applied at the wrong offset. The octets
in the raw packet that are being modified are 13 and 14, which would be
the correct offset within an IP header, but it seems that the prefixed
Ethernet header is not taken into account.

For the same reason, attempting to filter based on any details beyond
the Ethernet header also fails. The following rule does not match any
packets, even though there is a significant amount of UDP traffic:

table netdev dummy {
  chain egress {
    type filter hook egress device "dummy" priority 0;
    ether type ip ip protocol udp dup to "eth0"
  }
}

At this point, I'm not sure where to start digging to be honest and
would appreciate any guidance on how to resolve this issue.


Thanks,
Daniel
