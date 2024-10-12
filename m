Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66897DDAB
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 01:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728696621; cv=none; b=M4MESDuGYtWuDozyj/nsbHbeLPFydNXLrgNOZVczqBrS3eDFlhRekGvpoyZ8pR7jacXYEHkwZORt7Fij7FAiG1K4OYWFNY2w5RUjZKy6UprwlldCxbwL7hoKCL2jCbTkp5Ku4dlu2uFe9wTQ8+299hgozkVd5sDmlmTvb12Cq2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728696621; c=relaxed/simple;
	bh=yR0cZavi31forZPCUv8N1llGxre8NbH3sc9o5jZZZKU=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TU2OJ3BQ5lK76HZisXtREHu52ZPN4uPk2/OcoDPe/IFfvB9i5Jn81pcJPfGkXH1xDcOx7xxI3wHqaMKY6aM4ysg2FQKsakN15Kygur7MC1+z5UQmL1+OWhLDxrEEhVSk4/9EQf/YD0ylV6h9n8BFO9fBoT/LgD7ZDEXq4O9vqJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DF4eD5mw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DF4eD5mw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20bb610be6aso27244245ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 18:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728696618; x=1729301418; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9Y2Tzg1D2kBZfXj3D/39407vacvG/N+ASA/h5QSgxM=;
        b=DF4eD5mw7IWPadm59CqQd14Gr1Slj5KcqmtQEBJ7UD0ilgSAzB8p3wF+jsO131ympT
         NpBX20K0cKvsiHlGzoeGqR/vF1bGi9rCrvCPmPwp6GyP5JdZ8Sl3C5NKCAu9y5ivwE7K
         bkX3/t1jI/mDxS+obud8uf5udYL5Ykigm9eoEHz+2VK7jVHLysaWUsY827Xn0WhLozgc
         FgLwNmqYtILHNdNDhvQvuCPGLD7VDX+6p5ynouL5juDoQR6AiRIvKPrqF5/Uwvi2AvpE
         ODnpLtwc2jcCf3C19yUfVKa5gxSc0hv0uiPXS2Ad8MjLF5D0FFVsY8+qSYx6YwCbaF60
         p4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728696618; x=1729301418;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e9Y2Tzg1D2kBZfXj3D/39407vacvG/N+ASA/h5QSgxM=;
        b=mW5RCGXbatQS/8K5eqD9Pndp0sf+yJ6DBND79jwNNGOZGIz3MyYpfox8byWSKCCSGk
         /KWl3mE+ykn/emZPjPglPcTW+MgF1BWYsFhZSCNqS7tji6+l93KgT4ndGO0lduBtIWAE
         c7wNic9ZCHD108i3VuuSZgJzQqU3rrusYEwqN5yNe4HatGs4gq9C5/v+8V+1m19zkjc1
         NuzagWtK/oeSzip2gskhIznqTRK8xHEx/tXk6ZNqGHGl2yXp/4L+wFeRxz787LN1eJj6
         sdF2BXFQnYJ5GTArGkwEIC2gLMgz5wOXNN1sKU4V0gIuiAadY2oj3KNOL6hm5h48Y5i+
         KCIw==
X-Gm-Message-State: AOJu0YyByIwoT1XuC4hQWd/YbD7DIA1Eyf+J/kv5uTkfGxpUPyxMy5dw
	hhZ+uOQMWfpT+yH23zsgnK4FdQ3u+WANC+Ob6wO91O45t16VadYYkhWOQA==
X-Google-Smtp-Source: AGHT+IE5zf4nMD9Cgm5gD+t0+Y0uWdERCXFyVMXVmBvQ2CRZzvlmHsHNS2gVcfKAafShOZujbvewuA==
X-Received: by 2002:a17:903:2985:b0:20c:5263:247a with SMTP id d9443c01a7336-20ca16bdcb4mr62526655ad.38.1728696618386;
        Fri, 11 Oct 2024 18:30:18 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8bc1c692sm29687105ad.110.2024.10.11.18.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 18:30:17 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 12 Oct 2024 12:30:14 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Building libnetfilter_queue has required kernel headers for some time
Message-ID: <ZwnRJreuOMiQqU0A@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

Just to clear up a misconception:

On Tue, Aug 10, 2021 at 06:09:06PM +0200, Pablo Neira Ayuso wrote:
> To ensure that a project compiles standalone (without the need for the
> system kernel header files), you can cache a copy of the header in
> your software tree (we use this trick for a while in userspace
> netfilter software).

The concept of a standalone build without kernel headers might have been valid
once, but is invalid nowadays.

I tried uninstalling the `kernel-headers` package and building.
I got the following 2 errors from multiple source files:
| In file included from /usr/include/errno.h:28,
|                  from libnetfilter_queue.c:29:
| /usr/include/bits/errno.h:26:11: fatal error: linux/errno.h: No such file or directory
|    26 | # include <linux/errno.h>
|       |           ^~~~~~~~~~~~~~~
| In file included from /usr/include/sys/socket.h:33,
|                  from /usr/include/netinet/in.h:23,
|                  from /usr/include/arpa/inet.h:22,
|                  from nlmsg.c:9:
| /usr/include/bits/socket.h:354:11: fatal error: asm/socket.h: No such file or directory
|   354 | # include <asm/socket.h>
|       |           ^~~~~~~~~~~~~~

To see if an older version of glibc didn't use kernel headers, I tried a build
from my Slackware 14.2 VM (2016-06-30). It failed in ./configure:
| checking how to run the C preprocessor... /lib/cpp
| configure: error: in `/dimstar/usr/src/libnetfilter_queue':
| configure: error: C preprocessor "/lib/cpp" fails sanity check
| See `config.log' for more details
config.log shows:
| | /* end confdefs.h.  */
| | #ifdef __STDC__
| | # include <limits.h>
| | #else
| | # include <assert.h>
| | #endif
| |                    Syntax error
| configure:8489: /lib/cpp  conftest.c
| In file included from /usr/include/bits/posix1_lim.h:160:0,
|                  from /usr/include/limits.h:143,
|                  from /usr/lib64/gcc/x86_64-slackware-linux/5.3.0/include-fixed/limits.h:168,
|                  from /usr/lib64/gcc/x86_64-slackware-linux/5.3.0/include-fixed/syslimits.h:7,
|                  from /usr/lib64/gcc/x86_64-slackware-linux/5.3.0/include-fixed/limits.h:34,
|                  from conftest.c:12:
| /usr/include/bits/local_lim.h:38:26: fatal error: linux/limits.h: No such file or directory

Cheers ... Duncan.
