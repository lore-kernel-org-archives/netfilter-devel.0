Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFCF5C82
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jul 2024 01:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721440391; cv=none; b=oDpO60Y/4dDabBmkB9IkA3g/67eGnHCDOHHEoTPLdcC82V7UNDwa1enH5BYwdZKlpHddYMSVBOYSHxHSHq6H9bulkda2XJn0cE6kcQW6t4QxgLR0uXvf43Il+ctvLWWbUtjx7pfWsRuzgb5Q8xtH8zv2BFG59s2EbbmQiMrPIVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721440391; c=relaxed/simple;
	bh=wNwK7HBkWkhKAkroDGzDOXsAMzP3yZe+sTpoA2Jj8kw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EV8uvtvIV3dm+wTavFY4y70wiA6BndUxEfUF2CYtiZaD3np8NliuPUDqIoJldBlX5pXJe7dl0lav//GUz2zqR/ktaAzBJyW0JsUEqJNh4M8Q0vFn9k8ihUT9Jl+yUqNnxFfboe5y5Z905Q5bp+LAh8GWKBB3RA17dCFbQ0wQ6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7Kw1GeE; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7Kw1GeE"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d9e13ef8edso1504823b6e.2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2024 18:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721440388; x=1722045188; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=alclL72okXUtY7pg3TZWgAIPeIs5u9h76MLGk7NORR0=;
        b=T7Kw1GeEiQf9RpMUKUY20c8Kl6thZwszLpcPwjLNlAYgTAAt/Z8vwSfDUcJYhVJZp0
         lwGcNyasLiXV8taBDpeM5tCdWAY7fK3/6+tH6Mzg+xaEjegTHI7RnCvQk7S6VYAQAavk
         eEoVxBG3rAxWL11RokeoLAJsDYfyIsEfS3yAajcd4QhMorFVTXX3sLoLbTGXxAM8weuC
         /dvfb//8aRC9yl0CI/HuQeyqJxR0EthAdxxSsbGJHkJ+jjPOBGQShoAPZ+/qAZ3xhOeC
         2e7Y/d/6QhPqNn9FhhTsuPLxFZQ3Oo7VP7q3yGc+26B/pgxX2snZvljsdoJ5bt2f3w6W
         kpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721440388; x=1722045188;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=alclL72okXUtY7pg3TZWgAIPeIs5u9h76MLGk7NORR0=;
        b=HSOBsWr5BOaBAsQ3NmEkOzd5jQxcK8oYamyKF6bGXJ76DlE5wMLI01DimhkgaZyUJG
         ApqupnZLT8awx2CmQ/M6AMTq5dVRel7QSlxg5wNlv/PFTWPe8GDYh0Bweb46qYvr8m+D
         ZFu5UB60yUHFbOIAMi99gh/2qVvqgkQ26Zfks2raJuIk0WYVFyFvTt8OVJ2hpOi6ZVZB
         w+7WOB9j0hJYQDgz4CEdEvTHaHQBpWtM/FExoUGdW/ISVZDyajX3V9v4WBNCYtgYQqL9
         51aDcy3VhsR7nZ1OxWyvpADdasYVskwdjXqSbnF4uTpUkskkI3oyeTWrslSGxmn1SQP7
         j6fg==
X-Gm-Message-State: AOJu0Yw1Ig9vjrRfRPg9BCd2dMwX7IyqwSuxy9lo5Zi8qZPQQoi7LYCp
	xrWPhUd4Vh+yR8Mj5exUC+HP8CjXoZWZilGQiNVl6waSPvXJGNIOJNaFaQ==
X-Google-Smtp-Source: AGHT+IFd7qn5o5oBAC4ooH2JCVzMvTrbVPmnpLEZKMNlmAUE9oKVxKM+pfOgH3oHUKeG1k4fxc1j6Q==
X-Received: by 2002:a05:6358:7e14:b0:1a4:ea23:b5f3 with SMTP id e5c5f4694b2df-1acc5930615mr180457355d.0.1721440387935;
        Fri, 19 Jul 2024 18:53:07 -0700 (PDT)
Received: from slk15.local.net (n49-190-141-216.meb1.vic.optusnet.com.au. [49.190.141.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb772c2160sm3588696a91.8.2024.07.19.18.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 18:53:07 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 20 Jul 2024 11:53:04 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Speedup patch ping
Message-ID: <ZpsYgJxCwisjnqsX@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZpsUDF61Cld9g2jX@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="K908t/GJoPi2ZwcP"
Content-Disposition: inline
In-Reply-To: <ZpsUDF61Cld9g2jX@slk15.local.net>


--K908t/GJoPi2ZwcP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi again Pablo,

On Sat, Jul 20, 2024 at 11:34:04AM +1000, Duncan Roe wrote:
> Hi Pablo,
>
> Did you notice my build speedup patch
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240628040439.8501-1-duncan_roe@optusnet.com.au/
>
> The patch reduces the time taken by build_man.sh by about 10 times (on a
> system with 16+ cores) with overall CPU use being halved.
>
> I sent a single patch because only 1 file is changed. Would you rather have
> the development series? There are 17 patches: add time commands + 15
> speedups + remove time commands.
>
> You can run the attached script to verify doxygen/man/ is unchanged (and
> in libnetfilter_log as well).
>
> Cheers ... Duncan.

Sorry, diffdir as I posted used `glb` from my command-line toolbox. This one
doesn't.

Cheers ... Duncan.

--K908t/GJoPi2ZwcP
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
find "$1" -name CVS -prune -o -name .git -prune -o -type d ! -name RCS -exec sh -c "diff $opts \"{}\" \"\$(echo \"{}\" | sed s?^\"$1\"?\"$2\"?)\"" \; 2>&1|grep -E --line-buffered -v '^Common subdirectories: '

--K908t/GJoPi2ZwcP--
