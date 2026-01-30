Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F5137F748
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769797619; cv=pass; b=kRzuJy3+HS4tkJ2Ts0IjywDlFSmJpXbazvPZUutL6WI4GSue32zoDNnLOd9KBZ/rIL7wzPbtILMKqi5QrHpBk3AohcXGVBsKMIVtrQeKiqov8UYwTXHPY3ZnZW/thIIvlWN8As3/c85blfUmpjTocX+jYGbfQaycNhOuxzDpcwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769797619; c=relaxed/simple;
	bh=lrisY20fT7QX6UmUAc2LUce1JjCkcfWnzvbUQF3ofeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=kcjHoGEZbrFHiO+2403zprfyz8Zf7SsLZYvFEHp+asKHS1lOdWQPrpz3dmkLGshumpN3WFHMrK/QXXg2rNtV95xspNTwdC3uDt2+abb8Q4EW+N6kS/nvTJR4ZZDKTs5SgSb+mJvH/INrakMOSRQE5zzU0GD+2qrn1/SbZRbf3MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bp2TPHrn; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bp2TPHrn"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b73112ab62so2595200eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 10:26:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769797617; cv=none;
        d=google.com; s=arc-20240605;
        b=gidOjt0PR6RwSJF4AWHM7CfF1N+Slu6UNhWfwdnIqq7Km2Bia7Mkjz4111rkjLcOD+
         rszZ4IYFFZDrV6GIU3GM8gYX1SRIB57X77QXqVtQocbNstTXjlKv4fqClItRmXQdrfSX
         Z+GUZe9L4hlkLJ7sHq6Id3C+5C2FOGTn4Uf4EmWLfoJYr7ckt/F7qCcwXkyNy2yFNMQ1
         XNdzjwiAR6I9IAcfCFGc66YKcJ0EYHNCVg/eNWawYiDIJNUM6gMgekpYrnXfyM+w6dnY
         ExEiQvIe/ELtjTuc8ln65i6zUf6tYzNhIqSKNR8/Oj6L93/+vDvGr9ulEs5PitDICvnx
         4QNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v46KrKZc/31XyBaqi2kT503b2pKK0uKhy2ynP7NXTE4=;
        fh=w1P3cW1UJo+3uROoV9aYQSUNp+/BP3GwBjN46SfiWQc=;
        b=CH32gK/Q2rEqH2spr+nwKzYjl/opxBWZ1x2+vttAEPSDITfCn4FHajv4BxfUFr3JLc
         vUB9s3aphHwTTWqfsfi/cmh0YDqIVMOOdifeHOPYo2403+ImF/Wziz9cyrGaQwScBBdx
         LzUDpMs3ieW8Pli5Nw72zm/Kzj3GF2A3IdpvYkbHsQBHtSt5hiX6PLvGVxVhokHd5Yun
         OWWh0Zt34PSIiU97gKpUmbMsg2xB+TJxD03OcLBWKg9k146inl0/FFHOsBwfU5fKnihe
         jArZHwhKss5c2zXMCLY8ohqbJQ4YmLtX6WhNjlBJcZBSXiIeKvkdbfaIlFqzaRmPO/32
         qoYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769797617; x=1770402417; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v46KrKZc/31XyBaqi2kT503b2pKK0uKhy2ynP7NXTE4=;
        b=bp2TPHrnlGQoMbtFM4YuTxPYx42QiFHxKpKxCEZzUZIKr9TR4aY/opQ9ZSRJOEIp/r
         yx75teYwGGA3E6H8LuHf10BNMGZhEsV0XQ0xPwoGdgIJXj8B2l7Vr8rze1Qoeab2Z/EC
         VaQaeQsAX5shepifXLO7VTOa6B5Dm7IfQmyZKd8cDXTzj5YdGhpqX9LKivUOFHszoC5I
         BD9/c6nfGdsitz2qfuGwS7F1U5SYFJ7lBPUjVzZrAqzTPmttf1a4Bm5BPaPkyWB2KgIf
         vJ43rqQECLEMIzwZ4FEl8KNhQ9hIhuTDTFZTUjAAXUiyupggvvOa2KoGw8Nnv8FY3dtn
         ALdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769797617; x=1770402417;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v46KrKZc/31XyBaqi2kT503b2pKK0uKhy2ynP7NXTE4=;
        b=G15k764x/Znvi8gLaKqj3nq9GT50XJnhfgVjbPH0HvCSOV8vI1V3E6BTivrQ7/qxb8
         dg8BgNIa+/1UVI7yLaO9yqDMJ3+SNo48AiU/ZuSxJftIuGKMj69B0FmgH6CNIdHhsrSv
         lMAhdpyTvPl0mMrqQCOHNmF/NCixEoYQRLpLo4xUK91q3KICI6NNJgoNeO8pL4++ZNW1
         tZhOm9dd7elVhF/D6vvillpkTAHYVOU/a0Nad77p9IwYFfxMZPpG2sjmNS2plu2P8Las
         Ci0nJvbIYPaCrAg6iXrzMvxwq3iik+QrQzgQNwp6U4kGGtFUzCOjxAbwtxUH8y5xy0/A
         eE1w==
X-Forwarded-Encrypted: i=1; AJvYcCXDTHlMIDtQ0akMt3AFl2Msf81+cHgaJZBCQoqsMoVloKPaPeL7syr8GkuMM5JX/RYpz36diV4J/epMyx3w3BA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlAaFJRi5KMaPZYRkb5BT7s/NvxKD+qOOEl4rxKZhn5uyoWPIH
	fI+0YYy51IP34NPdSogU4AchdEKN2DcJqpnFIPKGay8HRtEJlwcel8r1qAPsJFEvUYVa4scAb+0
	CBf67x5GHsOEjqtmp2lF18ygCMDzzBCs=
X-Gm-Gg: AZuq6aLamYaZef+uwtv5zFfyHSu1qznv9oaf7X6xD3uN90k1xzDprxiwfI/6FTtqaME
	dJm2RkLdB1/caZsmtRYBOPcG/lUK43Ab9YRc2UvQ8Pb+D9pEnkg/UdQFCWo62QBuzJxI7eYhN1/
	v01I8FKkaSLQ6/rkl+RVBTsIFRTpBoRIBObQbL9AQrDm8ftqQVvJ/o7okpvNCibB5RaJphbeTmE
	LF1iXa/f49pU7K7k4fhxFyfFKDWzMYCt+KkfuUXkGi33Z8pCmMp98NAsSzQnn56kAqbdoSnpsG0
	QmIMBck+9sdTYe16rFKPdc9e2w==
X-Received: by 2002:a05:693c:2b13:b0:2b7:2551:502f with SMTP id
 5a478bee46e88-2b7c8902836mr1963854eec.35.1769797616404; Fri, 30 Jan 2026
 10:26:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJ-1uKHCK_yGx7WUAyOpoTn5QJFhu5khG4W17Foj_3ovgTjPwQ@mail.gmail.com>
 <aXzV1cB0zHqe4wwl@orbyte.nwl.cc>
In-Reply-To: <aXzV1cB0zHqe4wwl@orbyte.nwl.cc>
From: Mathieu Patenaude <mpatenaude@gmail.com>
Date: Fri, 30 Jan 2026 13:26:43 -0500
X-Gm-Features: AZwV_QgO2bmQJ5BhIS_njV6YIi4trtaNs_zuCDirQjH6Q5KRXQIev8QC4X9lSHU
Message-ID: <CAJ-1uKFUx4zi-g71kKzphzRQJFH36M6SwGwdLpAMjYivbqWmXg@mail.gmail.com>
Subject: Re: nft bash completion
To: Phil Sutter <phil@nwl.cc>, Mathieu Patenaude <mpatenaude@gmail.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Phil,

Thanks for looking into this, hopefully it's a small break from the
complex nftables c code ;-)

The current code gets you up to the point where you need to define the
"object" specifics.  At the shell, the problem I see is the escaping
of special characters ( { } ; ) and basically not wanting to reproduce
the entire nft parser in bash.

I can be very wrong on this, my observation is that most users define
things using a file (or file "like" or automation) method and mostly
use shell command line to do "simpler" things.   I guess if we wanted
to auto complete everything at the shell without having to maintain
the equivalent of the nft option parser in bash, the autocomplete
would need to be in the nft command itself, i.e. it would be great if
the "nft --interactive" mode had auto-completion, we could somehow
find an efficient way to leverage it from bash, removing most of the
need for the Bash'i'ism ;-)  But then again, there is the "escaping
special characters" fun part.

I realize I posted a link to the nft completion itself, but I had a
note about sudo at the "project" (two files!) level here
https://github.com/mpatenaude/bash-nft-completion/tree/main
The use of sudo / root is required for viewing the current ruleset, so
as soon as you need to auto complete an actual "object name", yes root
privileges are needed.  The no password OR cached sudo creds (via sudo
-v) is a requirement of the former, otherwise it would make the "auto
completion" pretty awkward, like, a  [tab] "enter your password", each
time you need to get a list of defined "objects".

For my use, this was initially put together for the "list" command so
it allowed the completion of the top most objects, like table, set,
chain, names.  I based the current version on this  "spec", not very
technical, but from the man page:
https://github.com/mpatenaude/bash-nft-completion/blob/main/positional-args=
-schema.txt.

Just to be sure I explain this correctly, for example:  nft list set
<family> <table> <set> will go like this:

# Prerequisites: cache the sudo credential if you don't have sudo
configured for NOPASSWD for the /usr/sbin/nft command, or just become
root...
[mathp@dev01 /]$ sudo -v
[sudo] password for mathp:

# Lists all top level options
[mathp@dev01 /]$ nft
-v                  --handle            --numeric           --file
         delete
-V                  -s                  -y                  -D
         create
--version           --stateless         --numeric-priority  --define
         get
-h                  -t                  -p                  -I
         replace
--help              --terse             --numeric-protocol
--includepath       rename
-i                  -S                  -T                  -d
         monitor
--interactive       --service           --numeric-time      --debug
         list
-c                  -N                  -e                  reset
         insert
--check             --reversedns        --echo              destroy
-o                  -u                  -j                  flush
--optimize          --guid              --json              add
-a                  -n                  -f                  describe

# once you start the positional options (ex. list) it no longer
propose -/--flags, will also only propose what can be "listed" or
"added", etc.
# If you start typing f[tab] it does auto-complete until "flowtable"
and propose flowtable and flowtables for example.
[mathp@dev01 /]$ nft --handle list
chain       flowtable   quota       table       flowtables  maps        tab=
les
counter     limit       ruleset     chains      hooks       quotas
ct          map         set         counters    limits      sets

# This is where the auto completion is opinionated, it currently
requires that you select the family, if you skip it, then it stops
proposing completion
[mathp@dev01 /]$ nft --handle list set
arp     bridge  inet    ip      ip6     netdev

# This is where "root" (sudo) is required, to list the actual table
names and propose them
[mathp@dev01 /]$ sudo nft --handle list set inet
firewalld                  systemd_cgroups_isolation

# Sudo  required to propose the defined set names for auto complete:
[mathp@dev01 /]$ sudo nft --handle list set inet systemd_cgroups_isolation
inbound_only_cgroups  test_set

# Auto complete the set name.
[mathp@dev01 /]$ sudo nft --handle list set inet
systemd_cgroups_isolation inbound_only_cgroups
table inet systemd_cgroups_isolation {
        set inbound_only_cgroups { # handle 4
                type cgroupsv2
                elements =3D { 48026 }
        }
}

# Adding a set for example, auto completion "propose stuff" until
"test_set" is entered.
[mathp@dev01 /]$ sudo nft add set inet systemd_cgroups_isolation
test_set '{ type ipv4_addr; }'

# lots of chains, yes it helps auto complete any one of those names ;-)
[mathp@dev01 /]$ nft list chain inet firewalld
Display all 117 possibilities? (y or n)

[mathp@dev01 /]$ nft list chain inet firewalld mangle_PRE
mangle_PREROUTING                        mangle_PRE_acme_log
mangle_PREROUTING_POLICIES               mangle_PRE_acme_deny
mangle_PRE_drop                          mangle_PRE_acme_allow
mangle_PRE_drop_pre                      mangle_PRE_acme_post
mangle_PRE_drop_log                      mangle_PRE_policy_allow-host-ipv6
mangle_PRE_drop_deny                     mangle_PRE_policy_allow-host-ipv6_=
pre
mangle_PRE_drop_allow                    mangle_PRE_policy_allow-host-ipv6_=
log
mangle_PRE_drop_post                     mangle_PRE_policy_allow-host-ipv6_=
deny
mangle_PRE_acme                      mangle_PRE_policy_allow-host-ipv6_allo=
w
mangle_PRE_acme_pre                  mangle_PRE_policy_allow-host-ipv6_post

Best,
Math.


On Fri, Jan 30, 2026 at 11:01=E2=80=AFAM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Mathieu,
>
> On Mon, Jan 26, 2026 at 10:26:16PM -0500, Mathieu Patenaude wrote:
> > Just inquiring to see if there is any interest in adding nft bash
> > completion to the nftables project tree?  I only found a reference to
> > it dating back to 2016 (patchwork RFC), but I'm unclear if this was
> > ever merged or if I'm just looking in the wrong place.
>
> AFAIK nothing exists yet.
>
> > I wrote something that works:
> > https://github.com/mpatenaude/bash-nft-completion/blob/main/nft
> >
> > Let me know if that can be helpful.
>
> Just to clarify:
>
> | # - Provides completions up to the start of a statement (until a '{' is=
 needed).
>
> So this does not complete statements/expressions when adding a rule, and
> completing the initial part is limited since it can't find out which
> ruleset elements exist already unless sudo does not require a password.
>
> Is the latter a requirement for the former? I.e., could it continue to
> complete something like 'nft add rule t c ip ' despite it does not know
> what "t" or "c" is supposed to be?
>
> Cheers, Phil
