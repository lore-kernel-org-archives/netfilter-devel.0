Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC05A523D
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jul 2024 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721439252; cv=none; b=Z5+nFR8GTavXXPWHZHbulUVF3k11mTexVzmVPotJHeLVk8wGC3vwka0ZiGGPHOOS5AtixUc17mtH2oknfEKMyZ3K+pyuEmIInCe2AwKDtfrG1HR8j8Ktc3WFS4mSg014g9Qxh86uWFDgNMpgpiIZpxC4lV6vtobWB8WPkgf3iT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721439252; c=relaxed/simple;
	bh=J8bEoKEbGdLsxlrwpmnAIfDzJiU/fTzkk2JHLbEKEZQ=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DrhTDWmgqUfqm73JIda6rvQAlXNGAlen++1RPEf+x6zy70XF7m3GD7ekotYrRO2j9VwJyVSf8t3jQp/2C11eskudyhb5YWRSZJfsptVldIKvMI3bmLomXH5jISxQJeifMtoQ2GhWYCDjb4JJZHqsriIJu+djVTz1A3mBprTUmU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGA8Yjcl; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGA8Yjcl"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c9cc66c649so1355419b6e.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2024 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721439249; x=1722044049; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QsuumXsVCmnmRaZOX/pm8aqqHejw4gEz8xZcMnqtVI=;
        b=eGA8YjclmAxU3NMqqMZUdnLo7qhGOtek0oAHpJubMV5XArJJZJFE5wQBlgT85bbzg+
         NHj5anx7C0+OC0VAZrx245aGcoCi9H1XHjeYnDna1EKsLZFaa/OyTI8phZ8HpSj8YGnB
         wWNvZ4H0w1apO2KnCiJdnX1D2y5nviLO9bWxP0c21Muhkx8QWxPSO65PwVp0JhCYb8GK
         8E+OKja7ulG2Y+MIz2g0bm2fDL2b1xPOefdjb/OkosgwrQ9rEuGlSTMLaeXxQFZN8C+S
         jM/wWpQZbPl43fLIWyG60cPtD05UZj6KVX74mabzV2o76V0MZtErda4bXyeImZp/HWMS
         ollA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721439249; x=1722044049;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3QsuumXsVCmnmRaZOX/pm8aqqHejw4gEz8xZcMnqtVI=;
        b=JBZ2gu8L+HV9KKspNAcUNs0E+n7+QfQGWmKIsrT/pZA84I9oYubJFR6O52JeZfBzQp
         XTnLV4dYUvgXaHkH5Y4xnvJpwtoSgaBRkDk4QrkLM1Sp0/A2pdWuIc9X18CIiHGCMY6e
         oVKGF6O0iFCBryYpX/5N0JnqI6VqSpHuQMn3DMgO6HQyeVtFKZSthLYn0tC82593Fu/x
         fT2enHY8pz9TJYPtcFiH5F6MHETihl71W2U0FZiOXV9dGqiDJCExITTcyVkh3auJHQXc
         dEWd9en61ftaCXHRKRlQL/nHdzuZp7fSbinvCM3mJ9nfHcj8gQ9xLZpuRu4GqCTvhAaF
         45Pw==
X-Gm-Message-State: AOJu0YzXTJF9daCy+1+TRVTZFbq91F9DEqnWuv2FfGw4zPDqBGCjnVOt
	ES8e8ourXG/pq85Q3RDH7afrmAPk2QnHwFx5UGKvN81PkQ3KeavWydRnAg==
X-Google-Smtp-Source: AGHT+IEgKplvH5W6clvXSZWLXR672kpC2R8Wdkw1yXfFSExMSL4x1y5Dt5LebcEGUND8MIDT/siq8A==
X-Received: by 2002:a05:6808:2010:b0:3d9:da81:6d59 with SMTP id 5614622812f47-3dae607dc84mr2082233b6e.34.1721439249607;
        Fri, 19 Jul 2024 18:34:09 -0700 (PDT)
Received: from slk15.local.net (n49-190-141-216.meb1.vic.optusnet.com.au. [49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f97fsm11380885ad.75.2024.07.19.18.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 18:34:07 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 20 Jul 2024 11:34:04 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Speedup patch ping
Message-ID: <ZpsUDF61Cld9g2jX@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9/g4IfdvZ1GiUsPX"
Content-Disposition: inline


--9/g4IfdvZ1GiUsPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

Did you notice my build speedup patch
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240628040439.8501-1-duncan_roe@optusnet.com.au/

The patch reduces the time taken by build_man.sh by about 10 times (on a
system with 16+ cores) with overall CPU use being halved.

I sent a single patch because only 1 file is changed. Would you rather have
the development series? There are 17 patches: add time commands + 15
speedups + remove time commands.

You can run the attached script to verify doxygen/man/ is unchanged (and
in libnetfilter_log as well).

Cheers ... Duncan.

--9/g4IfdvZ1GiUsPX
Content-Type: text/plain; charset=us-ascii
Content-Description: diffdir: diff 2 dirs under under version control skipping vcs files
Content-Disposition: attachment; filename=diffdir

#!/bin/sh
#set -x
opts=""
while [ $(echo -- "$1"|cut -c4) = '-' ]
do
 opts="$opts $1"
 shift
done
if [ -z "$1" -o -z "$2" ];then
  echo "Usage:- $(basename "$0") [diff opts] <dir1> <dir to be compared to dir1>"
  exit 1
fi
find "$1" -name CVS -prune -o -name .git -prune -o -type d ! -name RCS -exec sh -c "diff $opts \"{}\" \"\$(echo \"{}\" | sed s?^\"$1\"?\"$2\"?)\"" \; 2>&1|glb -v '^Common subdirectories: '

--9/g4IfdvZ1GiUsPX--
