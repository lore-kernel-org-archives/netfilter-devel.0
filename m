Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7521C5D7A
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Mar 2025 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740866687; cv=none; b=XZjHEwK4ZsFQ+N5HPbWrZ35G84TOE5Rfjy6cPadTJVPq0fIfG0b0gSpcyDL8lMGdXeqRbAVcQBw7gTnuVPhEqJurGwoQBPtRU5P4Yl0kylCzC/9ebBzHx5neCP4ggGdUEwnNDzjAjSf64XqnYxxaFOCtJGV84NANMQXzQqxVSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740866687; c=relaxed/simple;
	bh=CzY6viouTmFtrht2CZWVyaEAKbKkDvDGOa6Xu/gAov0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NNSEPIWeeiFlEuifmr0KKH40Lh2bicXWjTvRNIp6fAz1vOYrHI/W8x61i94kMtAqAbFOFGBMn4fPsas2xKTjbkJC/VlaSLBF/nxZwJGzlrNOUCagM6pHpE4mT7N45/1CpmYSnGkD11ZhUDicM1faQWSmmmac1YhR5iuInfUzzLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RV1O/90a; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RV1O/90a"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5494cb8c2e7so2241169e87.0
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Mar 2025 14:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740866683; x=1741471483; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzY6viouTmFtrht2CZWVyaEAKbKkDvDGOa6Xu/gAov0=;
        b=RV1O/90aC/7NjdMqHFlFWWtResAbNrlKzL+gIg1ZtN+90Q03VneHdDJIHWlde8Xgm9
         NsQzXl0r1UxLCA8+xClOlyqdI/3YPXzyMDNMfjTTfd1/pnucU75f1pylW+gAX/FG2qCt
         0sKNZF4NHe05mt1wFRMEpfZq3WxAefm5L6VozzSGVRSNYNQe8r1xMAZIPNz0FV84okCd
         txJZGpnB4I20zVAR1aS8P1so28X+Vvm/Zgsgtoke4pYaDUYn51UUOIyYX/ldEpPy3+oa
         8DcNXiS3xswsXx6u9LDsq9Jng+VplKemxA6U6/uSMjf77DktPMjgEvF5Gl6oMxXgGKWY
         ASjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740866683; x=1741471483;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CzY6viouTmFtrht2CZWVyaEAKbKkDvDGOa6Xu/gAov0=;
        b=pDu5tLhAlvPqSwm31y5VHsQLlBZCCz4Aa6tROaSBeBUKlj+Kb6lFEy+eo3ukEBgcXJ
         jBGCAaD14aJ+v9ZOw6l2X3nvp9lUS88IbQx75XbmEJYtk87M76UtBK0F2UFABLOEGkk9
         WPHVzfDuWdBOqlFZQHib/xc73TK/1ADYC2QaD8MxrB+2veN+imy5QmqVsCsVg/ACsuae
         08CG7tZY0ZV18IsqcYnqxFkh0QUMiGHiKN8kBXGdguLW0B7kJjKlL6BDoS27ebzO2etS
         6Y3cg5kDFk0ou9QD6nXY3AV1ad+QKXhO53vfXNQj30pHJH6hDK6KuFyxa1zzLRr/3V85
         zHhA==
X-Gm-Message-State: AOJu0YzErufEIRdcgiT+h8MptrxmVj9egZXMBsMHe5lmtrcZdNNBx+WP
	DIqa3jXViKTbVYjhBnhuGP2OY/cEksGZD2l5Vrxcmc/LbAn3uKOfuQMLzm/C
X-Gm-Gg: ASbGnctoGMM3cpoARSSlxRqHkfOjvSgO/jkUDJ5B5dqi7CALMo4QHbufZNKyac2QRNe
	lMcBt8Voo6HQyw0CF5LO9GwrwB9iK/6tcxXl5FZH4Oq+Q4wU3/dNvrTx7AO3xDtf7OHRpwEMZYT
	11mPkBIjbWQ7kxbsVRm4MsFikXIiudbEhTu003/PoIwGjfxyDvYEd4lN6faqN3W5NrF+HVQThaJ
	UmbwfvX6eb8R6YIGuDBFY8NT0++mrZBwEZwPRJAg0ALcBGvz0ndPif7j5XAOg4OkyPJh5En9a9P
	bRSHqIZWzY+RUEFT+4eD6Dq3KLI4+aFH8c4rBRoO4T2mxG7Vjdkv3WX4vYId06s=
X-Google-Smtp-Source: AGHT+IGuPciK5gBBoYsrQ5YDbah5SEuiJ6+SzZj4HbR7gIaO2HLl7+ZseKVZqMXinNrUki3FmNAbTw==
X-Received: by 2002:a05:6512:3406:b0:545:c89:2bb4 with SMTP id 2adb3069b0e04-5494c330ab6mr3264936e87.23.1740866683119;
        Sat, 01 Mar 2025 14:04:43 -0800 (PST)
Received: from smtpclient.apple ([213.87.159.115])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5495d268a42sm157116e87.175.2025.03.01.14.04.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Mar 2025 14:04:42 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
From: Alexey Kashavkin <akashavkin@gmail.com>
In-Reply-To: <20250301211436.2207-1-akashavkin@gmail.com>
Date: Sun, 2 Mar 2025 01:04:31 +0300
Cc: Alexey Kashavkin <akashavkin@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B89DC7E1-9DA1-4B38-96EF-F2AB021F62C9@gmail.com>
References: <20250301211436.2207-1-akashavkin@gmail.com>
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3776.700.51)

Rules such as the following will always result in the NFT_BREAK verdict =
code:

# filter input ip option rr ptr 4 counter

Because the function nft_skb_copy_to_reg() returns -EFAULT. This happens =
because in the skb_copy_bits() function the 'offset > (int)skb->len - =
len' condition causes a jump to the fault part of the code.

You can verify this with two virtual machines and the python scapy =
library.

Configure the nftables rule on some virtual machine. =46rom another =
virtual machine, use scapy to send packet with IP option:

# python3 -m scapy
# >>> send(IP(dst=3D'x.x.x.x', options=3DIPOption_RR())/ICMP())
# .
# Sent 1 packets.

The 'rr exists counter' rule will show the receiving of one packet, and =
the 'rr ptr 4 counter' rule will not increment the counter. After =
applying the patch from the previous email, the 'rr ptr 4 counter' rule =
will increment the counter. This will happen with other options as well. =
But for lsrr and ssrr, you must send the packet with the routers =
parameter filled in. This is due to checks in __ip_options_compile() =
function.

# send(IP(dst=3D=E2=80=98x.x.x.x', =
options=3DIPOption_LSRR(routers=3D[=E2=80=98x.x.x.x']))/ICMP())=
