Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD2F170A31
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2024 23:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728258781; cv=none; b=p61a0hnzFHnkZbamExKHke0fN+LpKqp8kj1eM6mIxakhnj2wG2zCYWbGwMCIwbmtaKeHxfI64mfsZJ9sAO3V0Fu5EmFk8rHEWDtUx/20+x63OgJxkUw3CmbvaBU+LJyoLjyoy+CmUUkPinu+pSTjWNlSIdOnys+i2f6dpWrkNoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728258781; c=relaxed/simple;
	bh=Y/ONB+T3NWRuVwHOmYNQ1IlC/ZeJfolz9wfYnVYUkH0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8YRwN+tzR/wp4OUt1nUd3CqBAERsG6NDpt5FUHHF8VkYcfcZyQQVU4hLwg7t+EjDXUWLQiZvxxcNOtqXW/kkBtfyvspSnFLA/UUDol65Ee8t/hG6dVmL3Pt11lxHVHEg/43Udz0SweflMACgL0chQI9i+9Vyn56fVDlVnKV25Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RjIWF4rJ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjIWF4rJ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20b78ee6298so24230315ad.2
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Oct 2024 16:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728258778; x=1728863578; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/ONB+T3NWRuVwHOmYNQ1IlC/ZeJfolz9wfYnVYUkH0=;
        b=RjIWF4rJmEBLRXCp5e+SSn12+dQQv767YRBV+HM1FlM/VxWDa4h9/PmnsPw/3u1Y6K
         ayCUZ6p/j+prNNDxW4u2JJtR6AVHjEyOWHa76ykCnUbwDyQaUDJNg17hyZG/wiGvIVse
         tQ3V2UWFKAFEsYNedY7IyHxymGRHKXniMy3+rj7ps07WUmP60RRLfZpdkNZ8BT3x8E/D
         a0cULoaizk2EQQA+sOa7Ym8r7eCpVICflsUFo+Y3+/8RmaVVAVeqjOgWWJNRvhMm6WuA
         1zZl+5W8p2Dy+oVaTS17moB4DjLI1Yl8Sb/0dUWHOmaU8b4g5PqaOZR04p9ytVXKQH5E
         0iBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728258778; x=1728863578;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/ONB+T3NWRuVwHOmYNQ1IlC/ZeJfolz9wfYnVYUkH0=;
        b=bJwQTcBo4XiVbD7EsZoWEulgRIkV4h3H5DxEzg5IrH2AfXgbY9GmBhdKYQpmjFbDp9
         EWs6fD9yfOmYkCdLFtgLB4vVH81q89ISH7N6UdwNABT36u4Ns0wbbGcnD2pcgUsjb2gH
         b0iwHluI3HuAEQTE5+/G5v8L/JSD9lB+uCSbsXKfIiatzaRalZah3fNsxz4CXrkoFs/Y
         KOVjcM4+xDmqodIn9IwMOBCM4/lMZwr4ddDGhNTwcD51R+B5TP0s8DBNvZmy3CracySF
         8oZo7p/PcsDfvxJMHrULehEHWJc75BpPHCNr3WOOBH6t21JOStU0Y7ILkPd8N+DBMGRi
         DL2A==
X-Forwarded-Encrypted: i=1; AJvYcCXrTz9AUgIolM81igPZM0eNODWmSgcKGkt+vQRSe1Ot6Yeu8ZmCymdunNr4Aer2DtyRbozZaQXGQ5deXMpRGw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKaOEOh8wK8Nbn0Z9iIdoj3RL3+KrtcgBD6hQY+Zlqzh7s6J9g
	q7O9wSxxQLQ6t0hw24uty+PF7L51i5aE7sqK2SVRN6Vvpu3LAUZokWvVFg==
X-Google-Smtp-Source: AGHT+IFuANbAgxHMF01ifKhqoesZzGVUw5sEONiTwBky6VNJnQtBH26SIfBSrNJhfLuW5Cp2lyEbXA==
X-Received: by 2002:a17:902:f691:b0:20b:65a8:917c with SMTP id d9443c01a7336-20bfde55505mr131302765ad.10.1728258778446;
        Sun, 06 Oct 2024 16:52:58 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c1396890esm29336485ad.197.2024.10.06.16.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2024 16:52:57 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 7 Oct 2024 10:52:54 +1100
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: add missing backslash to
 build_man.sh
Message-ID: <ZwMi1knK7rqs+iEy@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
 <Zv_rJM6_dyCVA7KU@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv_rJM6_dyCVA7KU@orbyte.nwl.cc>

Hi Phil,

On Fri, Oct 04, 2024 at 03:18:28PM +0200, Phil Sutter wrote:
> This holds another interesting detail, though: By quoting your
> delimiter, you may disable expansion entirely which might improve
> readability in those ed commands?

I did try quoting the delimiter when I was working on speeding up build_man.sh.
Rather to my surprise, the used CPU went up albeit by a tiny amount. I was
absolutely focussed on speed so left the delimiter unquoted.

The CPU increase was so small that you might consider the improvement in
readability to be worth it.

But there is another possible downside to quoting the delimiter. Some of the
here documents in build_man contain actual parameter substitution so would have
to be left as_is, leading to inconsistent appearance of here documents.

I'm happy to do it either way, LMK your preference.

Cheers ... Duncan.
