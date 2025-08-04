Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093AD2475C3
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 10:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754302210; cv=none; b=AbYFWmn+4uRP8LID0jOUv9sddtO0n91N6gJjbriDVUFDuYJplO5iWZGhVftWj7PuZ+w6mEujbDoD14anF2RbTPmKMxZtYjV2I/CwAVJJuy2mVg47Jr4l8E1ownmoVnn2s0AqJYkNPrWQQTx7GBdh/NIR76KTTr32Vqy4hJ7nSkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754302210; c=relaxed/simple;
	bh=I5JOR1ntQyN9fwmAwup65i+K5QARAcuIdIqwv1ZeRpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2MNsPIXkOaXcsuRzzzPfHDZDAo33TzXMJaBBGcIhg1N9WzzfaOw/TcsRpwtxggtLltJKrZW9DaT8OEQI1lntnhSplsHWghdLdGUd6wN5dnUN7NelcRIelgR7/49dmq7Wi4Lt5FYkSJ5KtNjz+DLcA1n9CKweZGbe52iK+Zxzsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i/LapP3f; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i/LapP3f"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b78315ff04so3374192f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2025 03:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754302207; x=1754907007; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PiuVm8BC6EUJm4jbzs13IJ67uJz5wPZlLAvhuLssFWg=;
        b=i/LapP3fyStIU6gpUQZ8Jr0zTKv90h6y8VCOHmd1s2SK/T7cL3hrQ/07oui1sBvSQa
         F69sVGQRdLFSYeXP19xSb+m0Tg0Wejc3ok/UrpyuIwQoE3uNEiB0obR8LU1/FK4IEILc
         T3A678bO5aFk6iuswKNd1vFPJHzLU7dVuk13AD2Oh7I+CVcQIEhV2vjYWcFDI4AtAbZV
         DZuM083ilU61ugfhJ3aUIJuxzkHyoqsji6CUijXlp74hDjaiMiAwKgcgO2narwXyEQkX
         qKA9JTrbTOtKCKFPHYdSneMq9wyp5nnBBEeKWgC4Z03pXO78km2WIf96J3VOBcOCN22e
         LG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754302207; x=1754907007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PiuVm8BC6EUJm4jbzs13IJ67uJz5wPZlLAvhuLssFWg=;
        b=g6vmZUBAjnaBITv/hWBuStje/z5wYJUjTyzEXXDgqJU2PzPISE9M1xna6xhOKF4r7Y
         7w6ix6p1cGA5Dk/1gKaJazQwCWxwDCytl2wGdGn8qVptR86zxvcR6BzCDifC5wuvWO6C
         8jCadqHFkhz6hOdr5idV4JGpb77jJQvLscWfzl8VIX8Fn/3j7SNuVz5j1Zx5KwaZ2Wr/
         wKioqXnODZofwTa9H5UyRitUvX26BJxCYYu66OdFqfhuv2214pQqnbAB8p9zfxysDhqT
         Ei1R8eyWYxJEuklKxAQWidrOzK/vJbpQR6QsoRSwfgG6TYYm7CdNTtfJm3XORqYmNHUH
         mL7g==
X-Gm-Message-State: AOJu0YxmuFov4etnLbGuO5A2vmo4QDn4wFmO6LAM7iMjEbF+ISoPw4lg
	AZoA9PCkTezZUYosGLl7C8SxibCIewPHN60AljCanutz7oG5hEr3/x0GGgfKaFqWZkQ=
X-Gm-Gg: ASbGncsayjR7XL0AU8RBikv6mHq4143la12MhdTE5HAOkELCYVxxrvjnLhyoI3sJvV3
	vemJf/W6M2OB8nRXrD2n/Och2jtUrX00o8TaHtFZpm3nFVFOBnZQKQf/X7La7IIk2aUc8MwqafA
	id7octwKSSl9xDsZQwdyanuqV9ekBfhVqTCDvjBS7mJWeyvmqEwjZyYl+WB9tzuFpFvUvjpV+7Y
	p812OgZDQbahbByGzjM6Xzwfq+33S9fkZikw9Cke3C1/JshihWYEzff2XQn5oMjSvK5p7E/S1oW
	3mzQHA+IsjQJA9dgeAMMRy78ku3Ra+zkVaemDG5LxMd49z5fW1zL+mZVv12O7r2e4LomyBR9HDW
	9le76zNu9RwWR54i8NheGDNG1n1E=
X-Google-Smtp-Source: AGHT+IHYvzPrlQVa/n86s9K/3nrADmQUV4izXgWlz+BPzdGPgOvQUjWTAnLOz627/aQcP1wNZ0wkZQ==
X-Received: by 2002:a05:6000:2c0c:b0:3b8:d2e1:7889 with SMTP id ffacd0b85a97d-3b8d946ac7fmr5972636f8f.12.1754302207114;
        Mon, 04 Aug 2025 03:10:07 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac158sm15277953f8f.4.2025.08.04.03.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 03:10:06 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:10:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [bug report] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <4bf4576a-e790-470a-a86f-329472ace9f6@suswa.mountain>
References: <aJBtpniVz8dIRDYf@stanley.mountain>
 <0e275ffe-e475-40eb-ac19-d0122ba847ae@linux.dev>
 <cd3b87dd-9f6f-48f0-b2f2-586d60d9a365@suswa.mountain>
 <c401288b-e2de-42a7-8e04-abd08daa112a@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c401288b-e2de-42a7-8e04-abd08daa112a@linux.dev>

On Mon, Aug 04, 2025 at 05:57:09PM +0800, Lance Yang wrote:
> 
> 
> On 2025/8/4 17:24, Dan Carpenter wrote:
> > On Mon, Aug 04, 2025 at 05:05:32PM +0800, Lance Yang wrote:
> > > 
> > > 
> > > On 2025/8/4 16:21, Dan Carpenter wrote:
> > > > Hello Lance Yang,
> > > > 
> > > > Commit e89a68046687 ("netfilter: load nf_log_syslog on enabling
> > > > nf_conntrack_log_invalid") from May 26, 2025 (linux-next), leads to
> > > > the following Smatch static checker warning:
> > > > 
> > > > 	net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
> > > > 	warn: missing error code? 'ret'
> > > 
> > > Thanks for pointing this out!
> > > 
> > > > 
> > > > net/netfilter/nf_conntrack_standalone.c
> > > >       559 static int
> > > >       560 nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
> > > >       561                                 void *buffer, size_t *lenp, loff_t *ppos)
> > > >       562 {
> > > >       563         int ret, i;
> > > >       564
> > > >       565         ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
> > > >       566         if (ret < 0 || !write)
> > > >       567                 return ret;
> > > >       568
> > > >       569         if (*(u8 *)table->data == 0)
> > > >       570                 return ret;
> > > > 
> > > > return 0?
> > > 
> > > That's a good question. proc_dou8vec_minmax() returns 0 on a successful
> > > write. So when a user writes '0' to disable the feature, ret is already 0.
> > > Returning it is the correct behavior to signal success.
> > > 
> > > > 
> > > >       571
> > > >       572         /* Load nf_log_syslog only if no logger is currently registered */
> > > >       573         for (i = 0; i < NFPROTO_NUMPROTO; i++) {
> > > >       574                 if (nf_log_is_registered(i))
> > > > --> 575                         return ret;
> > > > 
> > > > This feels like it should be return -EBUSY?  Or potentially return 0.
> > > 
> > > We simply return ret (which is 0) to signal success, as no further action
> > > (like loading the nf_log_syslog module) is needed.
> > > 
> > > > 
> > > >       576         }
> > > >       577         request_module("%s", "nf_log_syslog");
> > > >       578
> > > >       579         return ret;
> > > > 
> > > > return 0.
> > > 
> > > It's 0 as well.
> > > 
> > > Emm... do you know a way to make the Smatch static checker happy?
> > > 
> > 
> > Returning 0 would make the code so much more clear.  Readers probably
> 
> Yep, I see your point ;)
> 
> > assume that proc_dou8vec_minmax() returns positive values on success
> 
> IIUC, proc_dou8vec_minmax only returns 0 for success or a negative
> error code, so there's no positive value case here ...
> 
> > and that's why we are returning ret.  I know that I had to check.
> > 
> 
> It should make the code clearer and also make the Smatch checker happy:
> 
> 	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
> 	- if (ret < 0 || !write)
> 	+ if (ret != 0 || !write)
> 		return ret;
> 
> By checking for "ret != 0", it becomes explicit that ret can only be
> zero after that. wdyt?

The ret check there should either be the way you wrote it or:

	if (ret || !write)

either one is fine.  Adding a "!= 0" is not really idiomatic because
ret is not a number, it's an error code.

If you have the cross function database, then Smatch knows that ret
can't be positive...  I build with the DB on my desktop but the cross
function DB doesn't scale well enough to be usable by the zero-day bot
so I see this warning on my desktop but the zero-day bot will not
print a warning.

regards,
dan carpenter

