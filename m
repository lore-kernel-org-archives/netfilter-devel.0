Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A24D528
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752683968; cv=none; b=VKGhKxD+eI1tV89hWDTYXyhBnu2yblU0bfL2ATL+0R1DqNQkcxZDZupArAmgb2B5B8FbuJ3ihdNqsGlsj/zsITvbZSBh6GiFjQCLcW97XGOQ4zdP0nRW/fc6ZE6o5IAH11gpoFOdxCrIldNgGqeqfIgJLcLYp5BQwpKcouDD6X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752683968; c=relaxed/simple;
	bh=QuEBk/HQPKOPVCsj0HjQ5d4bXji4PLGBgBSZhEpNzfE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=GTSBcHcZkvF2kv4lle9Gg7GJxnLnX5JXyClyzaz4ufJLphQiqZsd/RtBP8D8w4/SGKBlUuNiUx3vlUEClnnrtq1uNJA5+38NZrD8Q1TA4R96igs3+Tqf8WyqTzGLYQ+YG9gTMg5N27lILA+dO/PjibbpzX7zfGN4sQyNpAfhIMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O36g0MIe; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O36g0MIe"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae36e88a5daso9778066b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 09:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752683965; x=1753288765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QuEBk/HQPKOPVCsj0HjQ5d4bXji4PLGBgBSZhEpNzfE=;
        b=O36g0MIeJbwJCvejFgJ7qwgSzBC2Y0yUVzqX05+hzG47+Y16GgrezloTKUIPBMEDzC
         KMW8GqihbgGw0Id0J09AFfkZSumIGCo7NySZIKdZR0k+LuLRZP95IZ8G74ek7toniYW6
         N21C0tQEZ1eewpAcWXvxAS557HDTzC5LnvnwaCBkXcmlyLs0Bs5cVE6vcgbKup+vjDov
         p3smNrJHoORy0feHtDzkTTa4OM1yy3XtKXcbVNOqZH/LvnwxbNaeuKNDXU4cSOJ/GNpk
         Rc1bKO5rqgJkEh6jy4p+QgUl1jF9kQpwujCEOSZOYm6aYEBPOPZcpiTgnfYEcLdtlaie
         af7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752683965; x=1753288765;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QuEBk/HQPKOPVCsj0HjQ5d4bXji4PLGBgBSZhEpNzfE=;
        b=nab0L+y5+3RS//u/iHlYZrwrIUjM0ltgRr+BBkllRvRXCJA8N1pA0jdVP26rvhhI6Z
         oVsLlopW8wrbw1dAILnsrgO4F/zqG/Fdwnq32IW4l3MpkLRTd9aO9NwJuxZMYmqUpOrU
         v7G+zjmIWaMceBMZknav0D5m8Vh3xVhvEAZnkX8FaxSf27rcGptSdiZsxmJko+apGbpd
         syhSa/iJUE/VpVDt5/WAttEQGeXpBDO5MXoZPJKK2PIDXwLypTpg/29aZGcu3L6qfuMs
         iuppcD057h1KTrhc0o7krubD1ieRGt8o+TAiTwIN5STabMytAFUn7LXVlR0XZgZ5nNh0
         bexw==
X-Gm-Message-State: AOJu0Ywz3dlapmFFp+uGHvIVR2BTh6kHMNTihMrHVPFFCovIZ9zOFf50
	CZJ4TKkKrGi/PQUldKLzc/Y27R6BZ2F2w4kyXKQ84KnTFWOQ5Cso9sbLBPXluFg1
X-Gm-Gg: ASbGncvfOVdnHowRBzRVSBQvpw9G2PsLv+R2ljOQ5pnS9wG0mat3UM7wVVGJ3oEychx
	FsrXd5L3yPWogQWRkkiYRBZAR3yTgtFUdvGPKbbtoViuGE/4EssnBZyPLHUEbY0MuNmA/fUMoo3
	VG5YHRv31VtBKMMIncfTAjkSM5WRUFaO2ul9uJ+SSVnkROwxBbtos6J9x9pZiy7elvlZrpCBOmK
	pHiRWsrLpYKRPdiyPmx7Cvfwja9XK5YNqlG0rVcwbCCrrl1jIEat7jPflOJ6BmMxvUi0A8SO2Lv
	VvU5cfMk7syCp3Ahf53/QQvBWM+S/x20vCyhZ35kfYfFulX+JDOgViKUJ/aqGbtS6ElghUqHgaf
	o3AgvlNKd/d2OXnGzZvsOQIRQuBHQxNPY
X-Google-Smtp-Source: AGHT+IHiQYHmU10vOOF6zBuLJ3cAitdxjNWFMwMDmGH1A+Z9q4sCxQOwZ1n0cUwn9etcOkBneG5s7Q==
X-Received: by 2002:a17:907:1c9f:b0:ae6:d421:a745 with SMTP id a640c23a62f3a-ae9ce16602amr358972666b.57.1752683964663;
        Wed, 16 Jul 2025 09:39:24 -0700 (PDT)
Received: from [192.168.1.212] ([188.27.87.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7ee47a2sm1231636766b.58.2025.07.16.09.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:39:23 -0700 (PDT)
Message-ID: <e195eb19-56b0-4892-a1e4-75c81bd2137b@gmail.com>
Date: Wed, 16 Jul 2025 19:39:52 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: __nf_ct_delete_from_lists crash, with bisected guilty commit
 found
Content-Language: en-US
From: Razvan Cojocaru <rzvncj@gmail.com>
To: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <4239da15-83ff-4ca4-939d-faef283471bb@gmail.com>
Autocrypt: addr=rzvncj@gmail.com; keydata=
 xsFNBGWqt8kBEADLmNlYzdRCm/MruY0ZFdCq4RxkR3JbaGJYylJcK9kvFLSpM5A6d04eXybm
 SrqfBKKmbk9Jx9T+VFEeqgD6PoCTxEntEj+dbq5T2q2nLRU8ZQ4oZW/rnmx+r2k4ypT+AQ/j
 8UMR0YKIXKSvQmTg/Ty/+c7bkXsslnEIsEiQBm6rMbD8n9gPH0vP11w6zDCwW8mD7D2LxLDG
 XbVcJYmOmYhUG1hH0kgsZ9N1GTyLIeCSwxyyFKcJIv1sPQukBPdkfzMCunoQd8DY7fSlAbB4
 dIYhb6gGLTSLVJg6/aj1/g4zFI5Y17t60QuFqcYT/HqJTTk5IvVf73owTKY1o03Bxk4lkd1C
 I/7bX4LkaOilTiee1HxBYo4/IflrbXk2Jod14JRkZz9OzV/+/49f0O3C0DJD+0AbwOfK0Wa5
 ed3t1pvR6Vh0Vrrt1wYgm0E1lZI5knXFGKs7s0rC2zMSm+LMG/dgnNjINEN8rQDCOLYEOkgu
 QV1hbBOvuLPP68UR1lk+0oGFXOlsbjvBs1pRgs+imEcip8id9oFFlRn754ppAJgEoIs4PJE9
 W2fGV1N6rYAYiHKJTqU2dfHzkO8IoVN/vnBivQ8B5zTZ+tPKYuea6PYAKglp79vhlg1Xu2Gr
 siNI6AZWIWc0ky6S1E1I+Ls2kk2Hv+i/dXp5bnEprEAw7koC6QARAQABzSJSYXp2YW4gQ29q
 b2NhcnUgPHJ6dm5jakBnbWFpbC5jb20+wsGXBBMBCABBFiEEbDEG3y0gupTsSQQAyGpMbgSq
 tPoFAmWqt8kCGwMFCQPCZwAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQyGpMbgSq
 tPp0Kg/+J8uoqUnuwTiW3YGJxnn+mtzH+eSEpUKD5quYVBpxVrBa1Xgvz1FnKdNmSiyvLzG8
 A50R86PU7gRYWvYxvobFksIgKySQuVR9y7bJrfs7FLWos8e9ILphTWEC10to+03gi8OkKYiU
 nOvSoYdd6R4az7l1eWYwGxxlxVwi5a+Dp11hWZ9TUYp3YTvSeKg53Zjf+qF9qE5FmQvDaI+M
 fXt0G8yFgL/vUn7FXlV8NvjkO0CfBcYf4Wo/+jk2aMgBexmqG//I2D1MvW/qwbDzMBg6jpwr
 fPoIfjUhN9TDS4v12GZBoHUTb5b5CU8VXo+Uuf6TA+H3iZTfAuwNOFpu5sO60xfY3dhP6v4Z
 aro9bwlAgQ+9+smA6i6I83RIsTJNn/dtJrL4vuDtK5ovDWWGO+OirisEvOgq1JcRwRLoyGdO
 o7xPWWJGWW+kztDydh6b2Xsf/bzOJ5iKSEfnZBBvEftlOPhvkd/fSGTvR8o7f7JF70xkPMLo
 h21ufoTWeQFfA4zKc8hrylGEZMHHLx2DZnj0z3HPpFhgMLBDtLd40UPRUxFL3xdHtij6iCll
 idsnI76VAUm06i6DubwovyLNbxxFPHzDt1MtRGbY1Lj624P6W2KqvDvZkDNqt77G8CjPn2Je
 MBRDy160VbB5YoRhm9GmsLpwqgkrjkiRtlod9hpZM5fOwU0EZaq3yQEQAOl0IplFz93ciaNV
 M5fkiHH2+yfDia1iiQtD8gv7O4nS8OY7H4eaQyPCS1bnHJUKqYFfwdepFM5gNgCWl+ZK9JAk
 P5lhz3/i12/fWK3vOOE8Uytdal0WTvgVnMHpKCG/NDbRoKPSzLyReNiFdY6TxS2rNjwXYGll
 F1R8wSIKJU5PQOSTGnJRAFrx3FtkTv4dbJi/c3GmWMVC5x816nt1dMOhFibyDHQSmIaA8Pu0
 ZHqzW7Gn15M6N3IWU6pRb9C9b6XEqLBg2zRmQ9AUJgj0nhoNSSfCVp7O09d+waB3wDoyTKti
 zWPXRRYxhuJwwEynjSYrb4aIcJXxX/FnMpMiYa7zTJn+HuUwE8Jso+ajLGh4J5QL2adDZjxM
 qtG8+D9KsEVi1PDXfql5uI/+H6S6r7eR7XanOmCa2Gb1sz4mTJzyYB9kFSMJ1iL8sVXtzf/M
 E9q6GM3r2Ng3NrcnX0B24jmji7HU9TbNa/fK5KhqdC6lzRQdnoHhGpkLcid4ltakRg0Z+ozj
 7grrclrwoFcT5ccxkSpKwOSEm4Aqrwp4jBIdpyUKDxuaCwafhoLSUlEJPoauzImP80HeZD+Y
 gj1ZAzU1cEpN1qZSKI7OvMnx+wFDjnalyyNWfhaH+witE4JfB9sLBmEzF5oBRpXWub+Pd+0G
 0l+KQbWCPuJfEYJcVZ2hABEBAAHCwXwEGAEIACYWIQRsMQbfLSC6lOxJBADIakxuBKq0+gUC
 Zaq3yQIbDAUJA8JnAAAKCRDIakxuBKq0+l3AEADFymFGDYcd/glmaCtLrsxrPH4H7oCclMeG
 5tldu9IyfddBfV9qTdGFMlMXAwhhlk1/UYFNNJEsPyoZLo4TIQFqmiHvl4fNnfz01ajpVf0n
 ot+nvVamm6D0dv0XqmqxfAcbuPm2cY8s/3yFahQ5O0ivaXCo4tZIat8zPWamKQ+Obf3XR3S6
 5rtPJbregkJDhZT6zpqh/UYsCyel3aM7+cGWp62XbpAxoR/BK6QCPAk2dBJgMKz34s75Aaba
 rnjaYhjU86OftTYAz9l95sIn0tPWAHHoLL1akVfDflciRTmxfK7A14FBqNhNn1vTRlF9rnVb
 Mcj5qXN4nlln0nkoYPGnZVi6TogiLoUdtGWie5saqfvTmGrQaxvhfqhfzjKjfUITwPc48DOl
 6q+ALHjVZ7GH00UiZbCN3lyl1hSM7ytw/hF5yswsBsVZYFhJPNSBnFKQVF5IfZMX0U57toTG
 ReKQZsPOrzBLGPWtNtI2OaeTwm+AD06cPA3I4KOHshAHLE5HN95Z0OPam3qer7KFNmAh0t4+
 q7wFIpxHIXe09TmQTtxIq7Znjxm32lM2wasr6voagSRHKhlUB4v6EIuUdKXFiWIO0VKuourX
 Cpyogs1kk21VoUTqg7tYLH74SLlsrSeVA+7TpfGJtWsIf4rm+Qadbf5JkXm1pYiaUUcOZyPU Hw==
In-Reply-To: <4239da15-83ff-4ca4-939d-faef283471bb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Apologies, forgot to mention the bisected commit that makes this happen.

It is 1397af5 "netfilter: conntrack: remove the percpu dying list".
