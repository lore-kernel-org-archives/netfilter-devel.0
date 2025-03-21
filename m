Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4524022ACC6
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742563792; cv=none; b=p7nBVuLN6bNj69JiXMq1Q+LLJ65E7whLVJhSQ/qwZI6m3tOnFRwRaifZlfeapUk3Y8L1/Yz0O9MI8MqmLCiDR3pk2NigkFP5QeH7wGhGpwF6EUKJHnis3kUPAeaDiU55JJVXVKp9hIeZML1TxLAdH3g92F3ttbd1M1gyRKzldYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742563792; c=relaxed/simple;
	bh=MeznKH96UhvIHwz03fBc2xAI0vRMyFW2NhR1w5KfCDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ik0RA2dOlh5L5+0uWBYL5bNYg5i7+9awR5I+9moeR8Qt1QbWxYH7+5u8TjQkxruLf6qmDCAYJLaEgG9vqRAZfiCGfgCQ0G+nJ6XopYEthTUcCGT4ScG5g6deMv19kTUwC9bPAsFF88qOaystqhs4BqoZ5Um5djti5s4i8T0DOT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3912c09be7dso1274315f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 06:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742563788; x=1743168588;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nUDivYeD/DTpP6wnLxZ4n6X62OuuJWoV8YmST96wudA=;
        b=MjTqb83xsmXg+CTLwmBFWj42pitsjUFmJesVW6HR6Nbsa8htK7FtMpdV8YzoDEu++n
         40d3HqoU7miegC0m3z/yHaL8TasYJFjH8zafxVvCNnypg7tBe9jUl2chVBgrHwIX7L8l
         6U/8URv287o+jEZ9BiGNCq/xtc7qxs7tAKW+rClaJmdfcTyhtvZbdS8NCizlyml1qV2B
         1vMPHh7gQHnLCmTkheF5cCez8kXUfizoCwpnJj9NFWTlkPMmAcq40/B+IiL/eia2a4qa
         WOHbtyLnX2KMQLzT4Sfk5AHn14K3bh5cc+lfnP4wgI+I6AsPom1UxwgB+Hu9vRuVW20Z
         Vn9g==
X-Gm-Message-State: AOJu0YyuqWh7Q63IgSr8b61cNzq9VZI4mwWaRTIOBxiFqxaHj0bh7AY0
	VzWT56cyOZ8x30QeWHaTFvHYL4lFKmVO+3iChgkbqtryaTbYAu70TbZcEg==
X-Gm-Gg: ASbGncsQCiBKeYdad0QP2lCpFTBPBdffNb/RJlrd5wLxlvcBDSS8j1/mSz6oRZlRQWR
	PE9L6ROislGmqzc7pZPOVqGEcGlRYV3d+h5niTO1dh164tERVC/ypApAmwEnp/sIR+q/b3CQjXj
	TLJX53voOayeXqfwx9I/jsUA13NNZcxzKmK7YM2h1qcJsr3LS/NhHOEw7eathO7BnlKAHCWZtWr
	WTWXVs1Q4N/HVgaMSF+FKIyl8Jw7OkvxlULJfnWlQPOzKT+P8IqiBdywQCHT+HTqjDJdFWjccnI
	1YrT/zobdsJELD5XMj/R9UJhiDOEmx+nUYmS+nD5Euqsk9DgsHXojGgDDltNkbo+1Faln/mznTf
	8tZvyBQZYJcNkrRax
X-Google-Smtp-Source: AGHT+IEHHGFip+4bQSLu7gi9rKk2REpZ/E9dikyIz4eS7RpG/ihWFX8uPkCIyDDy0lbuXGj0FuLLkg==
X-Received: by 2002:a05:6000:400a:b0:391:3b70:2dab with SMTP id ffacd0b85a97d-3997f8fe9f0mr2951878f8f.17.1742563788295;
        Fri, 21 Mar 2025 06:29:48 -0700 (PDT)
Received: from ?IPV6:2a0c:5a81:d217:7f00:3710:a1fe:6212:2fba? ([2a0c:5a81:d217:7f00:3710:a1fe:6212:2fba])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3f76sm2421525f8f.37.2025.03.21.06.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 06:29:47 -0700 (PDT)
Message-ID: <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>
Date: Fri, 21 Mar 2025 14:29:46 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
 matthias.gerstner@suse.com, phil@nwl.cc, eric@garver.life
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8jDjlJcehMB_Z9F@calendula>
Content-Language: en-US
From: Arturo Borrero Gonzalez <arturo@debian.org>
Autocrypt: addr=arturo@debian.org; keydata=
 xsFNBFD+Z5kBEADBJXuDQP41sQ/ANmzCCR/joRBgunGhAMnXgS1IlJe7NdX5yZ7+dOM8Lhe3
 UmZF6wYT/+ZA/NQ0XeXTlzyiuCJF0Fms/01huYfzNydx4StSO+/bpRvbrN0MNU1xQYKES9Ap
 v/ZjIO8F7Y4VIi/RoeJYFOVDpnOUAB9h9TSRNFR1KRL7OBFiGfd3YuIwPG1bymGt5CIRzi07
 GYV3Vpp8aiuoAyl6cGxahnxtO1nvOj6Nv+2j+kWnOsRxoXx5s5Gnh5zhdiN0MooztXpVQOS/
 zdTzJhnPpvhc7qac+0D0GdV1EL8ydaqbyFbm6xG/TlJp96w0ql2SEeW5zIrAa+Nu6pEMqK+q
 tT7sttRvecfr48wKVcbP57hsE7Cffmd4Sr4gNf5sE+1N09eHCZKPQaHyN3JRgJBbX1YZ0KPa
 FfUvGfehxA5BfDnJuVqhJ/aK6at6wWOdFMit2DH5rklpapBoux8CJ9HYKFHbwj60C4s1umU3
 FdpRfgI3KDzKYic6h2xGNrCfu7eO3x93ONAVQ9amGSDDY07SgO/ubx/t3jSvo3LDYrfAGmR0
 E2OlS94jOUoZWAoTRHOCyFJukFvliGu1OX6NBtDn4q3w42flBjFSGyPPfDUybXNvpmu3jUAe
 DwTVgDsrFIhsrQK83o/L4JjHzQDSzr32lVC0DyW7Bs2/it7qEwARAQABzStBcnR1cm8gQm9y
 cmVybyBHb256YWxleiA8YXJ0dXJvQGRlYmlhbi5vcmc+wsGRBBMBCgA7AhsDBQsJCAcDBRUK
 CQgLBRYCAwEAAh4BAheAFiEE3ZhhqyPcMzOJLgepaOcTmB0VFfgFAlnbgAICGQEACgkQaOcT
 mB0VFfik4RAAuizv/JAa0AGvXMn9GeDCkzZ8OlHTTHz1NWwkKa2FMqd2bvEkZh7TWE029QWu
 szyeshmCp0DFFa8F8mX6uQVnqOldJzS7En/nXQE1FbP2ivXdcJ7qcTBh09yOhpBq5wHI33Ox
 HiPI3BxNQ1opzhur1jz/mLRFPdfxM9kgK0afW9C96iIERYTO9B4TAjC+A434YODhesIrJAHo
 MJra4ty7EocpJiFlcL2/pA+vERezhh+JN274YVsaf1Bz93BwbS9g52ls6HE/mYYPOtIwxleZ
 rKWcev1W7qx0jvN9UoxH9gkS/GlBIAh1T/JU/d2K2oM8pXJUwMILVyVnsp9i3iwhPSGmVQuI
 3Ds+nOHShn6z7H7HZFi+RawIP8l1aHWk9iZSt6N3/ZM9yYNqcQ7Sm/nK72ppYa4WDEzAl7c8
 jO7KnfEfanXXjx4h4J+wdVG7Ch5yl4lYA0jdSy0UU+ZjKtHf1AssFCM5VAsKZG9Fm9OFhWNf
 fyb2CGsYvPUQCINWLR3tIxtKu1c6EkaTuUAd26yKQ/G5mrNlo9xble5A/RnwQPkH8/jr4o3M
 7ky+xYWoJx5t117TPUi8Xr9HBtakYyf5JiV6SJNHpigOx4jyWPY0uZqHgXnYCtryVTj3czQU
 EmISLQTGoAVEgobnXA62pjCPCjOtacYKsGh7H2uRjy1jkdbOwU0EUP5nmQEQAKGi1l6t/HTn
 r0Et+EFNxVinDgS/RFgZIoUElFERhCFLspLAeYSbiA7LJzWk+ba/0LXQSPWSmRfu2egP6R+z
 4EV0TZE/HNp/rJi6k2PcuBb0WDwKaEQWIhfbmdM0cvURr9QWFBMy+Ehxq/4TrSXqBN2xmgk4
 aZVro+czobalGjpuSF+JRI/FQgHgpyOweuXMAW5O0QrC9BUq/yU/zKpVMeXdO3Jc0pk82Rx/
 Qy0bbxQzEp6jRWqVsJmG3x06PRxeX9YLa9/nRMsRiRbT1sgR9mmqV8FQg2op09rc7nF9B36T
 jZNu6KRhsCcHhykMPAz+ZJMMSgi4p9dumhyYSRX/vBU7wAxq40IegTZiDGnoEKMf4grOR0Vt
 NBBNQmWUneRzm22P5mwL5bt1PNPZG7Fyo0lKgbkgX5CMgVcLfCxyTeCOvIKy73oJ/Nf2o5S1
 GcHfQaWxPbHO0Vrk4ZhR0FoewC2vwKAv+ytwskMmROIRoJIK6DmK0Ljqid/q0IE8UX4sZY90
 wK1YgxK2ie+VamOWUt6FUg91aMPOq2KKt8h4PJ7evPgB1z8jdFwd9K7QJDAJ6W0L5QFof+FK
 EgMtppumttzC95d13x15DTUSg1ScHcnMTnznsud3a+OX9XnaU6E9W4dzZRvujvVTann2rKoA
 qaRD/3F7MOkkTnGJGMGAI1YPABEBAAHCwV8EGAECAAkFAlD+Z5kCGwwACgkQaOcTmB0VFfhl
 zg/+IDM1i4QG5oZeyBPAJhcCkkrF/GjU/ZiwtPy4VdgnQ0aselKY51b5x5v7s9aKRYl0UruV
 d52JpYgNLpICsi8ASwYaAnKaPSIkQP0S7ISAH1JQy/to3k7dsCVpob591dlvxbwpuPzub+oG
 KIngqDdG/kfvUMpSGDaIZrROb/3BiN/HAqJNkzSCKMg6M7EBbvg35mMIRFL6wo8iV7qK62sE
 /W6MjpV2qJaBAFL0ToExL26KUkcGZGmgPo1somT9tn7Jt1uVsKWpwgS4A/DeOnsBEuUBNNbW
 HWHRxk/aO98Yuu5sXv2ucBcOeRW9WIdUbPiWFs+Zfa0vHZFV9AshaN3NrWCvVLPb0P9Oiq2p
 MhUHa4T0UiAbzQoUWxcVm7EpA402HZMCiKtNYetum61UI/h2o9PDDpahyyPZ27fqb9CId4X0
 pMwJFsrgrpeJeyxdmazIweEHtQ6/VdRUXcpX26Ra98anHjtRMCsDRsi8Tk1tf7p5XDCG+66W
 /rJNIF3K5uGoI9ikF00swEWL0yTWvv3rvD0OiVOuptrUNHPbxACHzlw4UGVqvAxSvFIoXUOd
 BzQBnObBvPcu14uTb5C19hUP4xwOsds5BlYlUdV4IJjufE71Xz56DDV8h8pV4d6UY5MlLcfk
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
In-Reply-To: <Z8jDjlJcehMB_Z9F@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/5/25 22:35, Pablo Neira Ayuso wrote:
> Hi Jan,
> 
> I added a few more people to Cc.
> 
> On Fri, Feb 28, 2025 at 09:59:35PM +0100, Jan Engelhardt wrote:
>> There is a customer request (bugreport) for wanting to trivially load a ruleset
>> from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
>> service unit is hereby added to provide that functionality. This is based on
>> various distributions attempting to do same, cf.
>>
>> https://src.fedoraproject.org/rpms/nftables/tree/rawhide
>> https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/ 
>> nftables.initd
>> https://gitlab.archlinux.org/archlinux/packaging/packages/nftables
> Any chance to Cc these maintainers too? Given this is closer to
> downstream than upstream, I would like to understand if this could
> cause any hypothetical interference with distro packagers.
> 
> Only subtle nitpick I see with this patch is that INSTALL file is not
> updated to provide information on how to use --with-unitdir=.
> 

I have mixed feelings about having this systemd service file in this repository.
Will this file be maintained wrt. systemd ecosystem updates? Or will it be 
outdated and neglected after a few years?

For most folks, I assume they will run nftables via firewalld or any other 
ruleset manager, unless they know what they are doing. And if they know what 
they are doing (i.e, they have crafted their own firewalling system), then most 
likely the systemd config in this repo is ignored.

