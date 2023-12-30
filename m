Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FB02561
	for <netfilter-devel@vger.kernel.org>; Sat, 30 Dec 2023 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMk4ttba"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3bbbf5a59b7so3043292b6e.3
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Dec 2023 02:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703932389; x=1704537189; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nrWtgCp3dapajb2ZHlJCibmgxgwUZ+UVqguVnQ2XS6k=;
        b=FMk4ttba1+rZnFoCnXzQVTxerQhAaNnroWbY4IBZG7SLVJvII94jDrkcN4LR9ZS6Cv
         hk0Whn62OArbfcLXhzNjdgmJ/R5tXN3plRmKSpzaeAObT1t2qVa+4fh17bhvOsCnl2XJ
         KXyaeh5zdR7FmYX23HuDNxaXDuKS/zvfkzlIMMMphsdeWKHBDpxa0W2+fZtHwIV02THb
         WK1Lc2ozHss2LV09/sDFY+3xPR7ioSQEnXyshjjN3c8aFDTYrMXtTuXDxZAN6lMluL+V
         fZ6DhrogUPBJ5jttoXraPqrDKpEvdtCbTpIWEIRabq9sDKBquYjR9mkxBZuOPhEZw5hG
         xCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703932389; x=1704537189;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nrWtgCp3dapajb2ZHlJCibmgxgwUZ+UVqguVnQ2XS6k=;
        b=IocYYQ0EpKMvWCrImVENxm5u8VSuC3hpuO7UyDJTy9HoPl8++GQNPWUz5J+LY8ce2K
         RfPlHekJ66zv4sZv3EJdYmiwWbzCERAHB+3NDmviIgiQfae2FsJSiynlooGSdsgBiG8F
         +N8CKyZUVnAJwVNqvox/qDOrcjgf6/FDtSJ2m5DyXxIw657Vq65uzj7LLQR0MfT/d0g6
         J4kjr9o4rZsiENom2O/VFd4697sJbptvTeHtPQ5WVDiozgON/e8nefuF7GsvHLCG9LcM
         JcRPiNcYV9WdIe7SEmXlJ1xIunJ8tjiWerliIMKj6z7XznRigYIY38uUctHRCcsevnMj
         PWsw==
X-Gm-Message-State: AOJu0Yz4xWTAXFGaRCJlmeqV+4Fjo8WcEJ7RPqwGYbK/2cyAvohZwAXd
	e5icK3opkfsSgP5JSGC9S77w7RnV/GgcpavFs0+c/IOhd1U=
X-Google-Smtp-Source: AGHT+IE7+U/wbv4ZM8EkmdRLDa9OReAU2mH/ikJH9UKx8mez9+tAsIHl7sJlSwXT+1872iV5i/7Ij3BF7TeEwpn57eM=
X-Received: by 2002:a05:6808:f89:b0:3bb:f8c2:d56e with SMTP id
 o9-20020a0568080f8900b003bbf8c2d56emr62598oiw.81.1703932388840; Sat, 30 Dec
 2023 02:33:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Han Boetes <hboetes@gmail.com>
Date: Sat, 30 Dec 2023 11:32:57 +0100
Message-ID: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>
Subject: feature request: list elements of table for scripting
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi there,

for the purpose of a brute-forcers script, I'd like to get a list of
elements of a table.

The best I get so far is: "nft list set sshd_blacklist sshd_blacklist"

Which produces the whole table, with entries like
"xxx.xxx.103.115-xxx.xxx.103.116, xxx.xxx.103.118/31" which are very nice
for human readability, but rather clumsy for scripting.

Therefore, my feature request: please add an option to produce the elements
of a list one by one. Something like:

nft -e list set sshd_blacklist sshd_blacklist
xxx.xxx.103.115
xxx.xxx.103.116
xxx.xxx.103.118
xxx.xxx.103.119


Thanks
Han
