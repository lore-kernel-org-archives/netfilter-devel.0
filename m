Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91417FAA4
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718208093; cv=none; b=pnLMxkDtiEMUA+87trnVHgR64wPNs9iW93yj74BgzNgVVxyEvJD9VaYC7d49MXi/21JqAppiSR4tSytv6lC2dJWlgaJJRe/DReYVT1QUvsm8+87GFkdZII9eJ/enAzKwjaxoTYKTDBx5vWpkkZrypCnYQooGvx+wmvmJ4Dl4PXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718208093; c=relaxed/simple;
	bh=EvM+KxCTjYPGu7xmOwxgvkiSs1Z5hRB1v+0Sv3GEgUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uW2ej+GAlYyc0mZZxDXPb4ro+q64KHr4HsuPXf488OLE0BvcgqpLLIvwvkjXSbq3eLlGaTA7pKYs5UWrJluKEoVFazAeD/fCzKUDXnytpFL37f7IHaPDgi2xAF41GXRaxmnCq6nV2Np6zgpzPqwK5vpNFYkIBCV1pIu1ocFrMcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSTbd1BQ; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSTbd1BQ"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dfac121b6a6so18121276.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 09:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718208091; x=1718812891; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=809Fu7vAw6oSMhpk0KmFqxPdDsAAmlJHgQGnumrnwM0=;
        b=WSTbd1BQbgAkJWt6v8HieXoCqZyjNUPyq657v9T45HtfSUflYj1GVeBFcuAWf7+xn5
         Ld5+aicEPsq64PdmdJ/a9Gfr60bwKxBqtc1tpYWQFuqHfIqOwMHFS/Iom7JQW++CEiKC
         qZV0nE3ysSNlV+LmArA0yZ0rXOekJZZmfZSZDb05YHnchmivv4BHE7+ErIldiGONLNQ0
         IZKe8bokg9O3QRwKjnrBamRlCfd8XekqWEZDGJJnQyaDfKBQ2FpddnUVk5854q7d/ArC
         i9G4tqMhPl18tNU9gfcsMXmsNN2ESGaO8SuF8z03EFAKFE4lASrf8c9xeHMJNdj6bXHq
         iZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718208091; x=1718812891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=809Fu7vAw6oSMhpk0KmFqxPdDsAAmlJHgQGnumrnwM0=;
        b=B+e7dAUdGaqlvmHzaU3fWpypCvv7y8Z1xIuvhhbzsqSqMhCP0T4PJua3ZwQv6jy3sY
         +BAZxx87eatIbJ+yQ9et8xnsFJzGWhlNryZEx1oC2dyzAl8ejR1HrQytVZDdrlus0wvD
         vWTrKxJu9ZW0XK1pjMaC5dKTT7Nrfob0xxmHryJplGDAI4N1nVXKA4jac1U3jJNmESN1
         cY6Mge2YCMb/5VevdpjDJlkGlGny6+cTiDRoBM+a8NthRk9kkLwgC69NTaizd/i2Ac3J
         FLNVlXq8FHHLDj6SAyj3YoF0XXXMPJvPVxnHcrR9hvqZsbsWm95qekOInqEk+PcqEUfg
         OEjA==
X-Gm-Message-State: AOJu0Yz1UD+u9vRmzVTzXeu7OliOIMHfrQ5+A/rjj6Q4ob0NsTQpd21G
	V7caRhUckTz5JaeJ8aiDvsyqtfEL0q9fGxuvWEmJEqJQidn8wSVjI1I/bZvNrg0MDdE18SV1la4
	nM5ltdNEVu3TBS8XD5zqkolc0g95N8kIg
X-Google-Smtp-Source: AGHT+IEw7pMTQSr1M6LyJmMTXTO0U2lwAZB60BT4mgvEuSdzBOWZcNE5SK82JLw0vDoW7tFJtheCyQ7v9bqdx96aOlo=
X-Received: by 2002:a25:dc49:0:b0:dfb:14c0:647d with SMTP id
 3f1490d57ef6-dfefec05cbemr47103276.6.1718208090875; Wed, 12 Jun 2024 09:01:30
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612151328.2193-1-phil@nwl.cc>
In-Reply-To: <20240612151328.2193-1-phil@nwl.cc>
From: Fabio Pedretti <pedretti.fabio@gmail.com>
Date: Wed, 12 Jun 2024 18:00:54 +0200
Message-ID: <CA+fnjVC2vZpowThMGEvRT=vuEHW5cdzxPTHgWkjO1o+TpZo5Cg@mail.gmail.com>
Subject: Re: [iptables PATCH] man: recent: Adjust to changes around
 ip_pkt_list_tot parameter
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"

Hi, thanks.
It looks like there is still a limit of 255 for hitcount (and
ip_pkt_list_tot), right?

Maybe leave:
The maximum value for the hitcount parameter is 255.

Even better, remove the limit? :)
That would improve usefulness of recent, similar to hashlimit which
for example has no restrictions on --hashlimit-above

[root@debian:~]# uname -a
Linux debian 6.7.12-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.7.12-1
(2024-04-24) x86_64 GNU/Linux

[root@debian:~]# iptables -A INPUT -m recent --name badguys --rcheck
--hitcount 255
[root@debian:~]# iptables -A INPUT -m recent --name badguys --rcheck
--hitcount 256
iptables v1.8.10 (nf_tables):  RULE_APPEND failed (Invalid argument):
rule in chain INPUT

And anyway:
[root@debian:~]# modprobe -r xt_recent ; modprobe xt_recent ip_pkt_list_tot=255
[root@debian:~]# modprobe -r xt_recent ; modprobe xt_recent ip_pkt_list_tot=256
modprobe: ERROR: could not insert 'xt_recent': Invalid argument


Il giorno mer 12 giu 2024 alle ore 17:13 Phil Sutter <phil@nwl.cc> ha scritto:
>
> The parameter became obsolete in kernel commit abc86d0f9924 ("netfilter:
> xt_recent: relax ip_pkt_list_tot restrictions").
>
> Reported-by: Fabio <pedretti.fabio@gmail.com>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
> Cc: Florian Westphal <fw@strlen.de>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  extensions/libxt_recent.man | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
> index 82537fab9846f..e0305f9857e29 100644
> --- a/extensions/libxt_recent.man
> +++ b/extensions/libxt_recent.man
> @@ -55,9 +55,7 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
>  address is in the list and packets had been received greater than or equal to
>  the given value. This option may be used along with \fB\-\-seconds\fP to create
>  an even narrower match requiring a certain number of hits within a specific
> -time frame. The maximum value for the hitcount parameter is given by the
> -"ip_pkt_list_tot" parameter of the xt_recent kernel module. Exceeding this
> -value on the command line will cause the rule to be rejected.
> +time frame.
>  .TP
>  \fB\-\-rttl\fP
>  This option may only be used in conjunction with one of \fB\-\-rcheck\fP or
> @@ -93,8 +91,10 @@ to flush the DEFAULT list (remove all entries).
>  \fBip_list_tot\fP=\fI100\fP
>  Number of addresses remembered per table.
>  .TP
> -\fBip_pkt_list_tot\fP=\fI20\fP
> -Number of packets per address remembered.
> +\fBip_pkt_list_tot\fP=\fI0\fP
> +Number of packets per address remembered. This parameter is obsolete since
> +kernel version 3.19 which started to calculate the table size based on given
> +\fB\-\-hitcount\fP parameter.
>  .TP
>  \fBip_list_hash_size\fP=\fI0\fP
>  Hash table size. 0 means to calculate it based on ip_list_tot by rounding it up
> --
> 2.43.0
>
