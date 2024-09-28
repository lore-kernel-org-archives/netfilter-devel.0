Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2272AD38
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 04:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727496753; cv=none; b=cyfw+cJn0TTZ/SNZvArFdRhUosmFSJdZYa6n8oQmxLqPXPrRpkGw+PxvsI8kr850jf3hyBTuZ97p7dLVa1e/WOAGpqgV+pDOl3F0MZnpy9asSbJDum6qcT3txgWVxVK0FCtZw7tvZnPzkUYUZ4Yy5SucquTMGccyXfyGg4SKfXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727496753; c=relaxed/simple;
	bh=cqHuGm1eBCyL6JNcrYNEHtQBECWY1Qf5tR2jsrgX6tI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=TNvMI3yYalLkdNPii397YpzOVbGX0QuC8zO8vba88Sk6/a1+czccOjHJ57F/ecukwZnOpZkecBlKq3ZYZVUushd5BV7/ifehMPDLZR2s4W+fLHIeTqFSCWzjwMkUcGwV5kgFY34FFzU99Q6BjsH5WbTo2jfCG7gX5HinFjsBBZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YPJLM2/F; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPJLM2/F"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7a99eee4a5bso223009385a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2024 21:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727496751; x=1728101551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k84L17OusYWxP+b53TJi2tBzIJGpyzHtP6jbznFpSsg=;
        b=YPJLM2/F/mBiYng5NZNxtGPbi9g57d/2lWEKlGoDYfuW+fODWDnokiLC9Nr3Y9Sjns
         zEkJTBDgMAjN0ajGcdjtu+tdCbiuUt9fmdAeXhGlZmN51Kp+bKnnzEbgeYqkgDsm2LCx
         fM7aemBrAPifkv5H9JY3qeHOZ6e3hFLzGWxSVgT4Cg37bjLAqyAtYUntfyo7V9kJKXl0
         Ngz1mp+40TSI4tMW49olSwa421qQM9AFOCG5Cd85AKCwGzYY6q3t9PtqzYoWrPjhwBuK
         URJoMh1oeA9uM9PDTFV4w0jnQUClgjTol4nH51tSDFwccaZC+nNXT+pxIFKVIeo6tdZ5
         1uYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727496751; x=1728101551;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k84L17OusYWxP+b53TJi2tBzIJGpyzHtP6jbznFpSsg=;
        b=ONpg4ifHfqo6fE5G5zTE06bzVGYEc3s97jtYwVGVLB6PYKy+kd9ARIZ/yRrIRXZWLq
         8SN+8XDJKbovLlgGyNdNY+CpwcgzUJqX7oNwdjtzvLGD1JIR+n1UBpY3joLW2IYV3lq7
         47xdCk+iJaCIB4ncV70fgzLY5T66mEC9QgN1pXD433k4xf9Xo1aVqvVmpdZjE8HlxuiH
         1AFJl1/iX8GfpcC3yH4mRSK+6ij9AJC49rGoD207AeB/xrSZfjIhAHiBRNRsLmzWTL36
         7OU5FJ0yr/7iBaQe8VlsgZBcSjZ7noJe+gFFuMd6rMFRqYaZ+VBO9ND9v4owNBoKghNd
         9hYg==
X-Gm-Message-State: AOJu0YypeNnkZdu1jy6zO9kHtiUdsCudHlNFqr6tiTeQajErxzqTHOQD
	IEYp+wO1K3T6fnj8EY7AgjojD83Sp8buhYF6YQcU+XU5NKcI8W4XOkkuwA==
X-Google-Smtp-Source: AGHT+IFI7v48ng6OB8eOGTblETHBJQ6oXjirrtpJ2d61MEwg8VC/2OpD2l5B2D4bBVKoZpcwU+zIxg==
X-Received: by 2002:a05:620a:1926:b0:79e:f850:e4de with SMTP id af79cd13be357-7ae3775ff2dmr809076285a.0.1727496750833;
        Fri, 27 Sep 2024 21:12:30 -0700 (PDT)
Received: from playground ([204.111.179.234])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae377b863asm153339785a.20.2024.09.27.21.12.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 21:12:30 -0700 (PDT)
Date: Sat, 28 Sep 2024 00:12:27 -0400
From: <imnozi@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: iptables 1.8.10 translate error
Message-ID: <20240928001227.2b9b7e76@playground>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

In iptables v1.8.10, iptables-translate has a small parse error; it doesn't like log prefix that has a trailing space:

----------------
[root@kvm64-62 sbin]# iptables-save|grep -- "^-.*LOG" |while read a; do echo -e "\n$a"; iptables-translate $a;done

-A invdrop -j LOG --log-prefix "Denied-by-mangle:invdrop "
Bad argument `"'
Try `iptables-translate -h' or 'iptables-translate --help' for more information.

-A INPUT -j LOG --log-prefix "Denied-by-filter:INPUT "
Bad argument `"'
Try `iptables-translate -h' or 'iptables-translate --help' for more information.

-A FORWARD -j LOG --log-prefix "Denied-by-filter:FORWARD "
Bad argument `"'
Try `iptables-translate -h' or 'iptables-translate --help' for more information.

-A lldrop -j LOG --log-prefix "Denied-by-filter:lldrop "
Bad argument `"'
Try `iptables-translate -h' or 'iptables-translate --help' for more information.

-A restrict_remote -j LOG --log-prefix "Denied-by-filter:rstr_rem "
Bad argument `"'
Try `iptables-translate -h' or 'iptables-translate --help' for more information.

-A tndrop -j LOG --log-prefix "Denied-by-filter:tndrop "
Bad argument `"'
Try `iptables-translate -h' or 'iptables-translate --help' for more information.
[root@kvm64-62 sbin]# 
----------------

It accepts the rest of the 345 rules without complaint.

Neal
