Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF984A35
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770139580; cv=pass; b=C6Jrh7rfSL7u7cRZp4GWI0g852N8ZvXZvBw/5ONYwKVfTQWPbUf9BsAxEarZ7WCfsduDuZ0rhAzRSD682oXvjqNm93d4N0EF0wuFtEpCf8XeObbCTzXQ+junR27EWVl6B8lF76ZNim1cmhQfarTrA9P6tspN5zE0180aLfA8ucc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770139580; c=relaxed/simple;
	bh=Cd6imsJZ0tucUZlfO4i0eVnmofzWEhLRaIUTAwwwYE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fijmWoBl41UTBSzT2u6r1HEBOh+r5YCvGoq01RX82uVWXJBPb3L9Hbuq6C6QwdIFX6qSRsIN9KPBKOySxxfWvOM9SVITXVCxC95V/lZjP5yq+58GG7GgEre8/ss6ZDZMX1g3ZJfhDEGuKFZNHNEthNQydUj7pAIbnWwKsiNeD20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwG7mAZI; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwG7mAZI"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-11f36012fb2so6898918c88.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 09:26:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770139578; cv=none;
        d=google.com; s=arc-20240605;
        b=SBXYE91cEWHZtsQ7ff4DAhH7a4tQ5OcNzJ7DBkX5DpJ9hdTZho7VjPZ9tT9S5XGbEs
         JV+FYtxlz2jTuL4dCjT1n8rp2n7K/J5BASklT8KEPhFA6ayQwmhfUClqQOOA+XraFshZ
         d4TstT4FcyhLFZcGgopes1yS/SLpfCztRUelRhjOu/nSb73xH+9rhIZEKtHXjK2rYPn6
         TKjVSpmYBcuk4Az5wgVPdbMEMJhXWcY2BMsBrUwhL3pmrMtSTwGKttr+GkhI5fepDaKj
         5Ck5i32sYMhwtinSHgY7RfXvDUcIAPAjtitf/o6GSeaNNfT8OhjydtyDiqPw9H7c7kDi
         G1xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Je6+aFnrki7tfkC50ZjSejlBZpp2E59wtL4ykex4gYo=;
        fh=4lXHK5DboDcARZENL1wrj4ADOP83rNTxw21qxQzHUPQ=;
        b=B2Rv+owrvXWItuC1JDmOtqZm//hVQChAyrdcGNtOYHD8WlUHxainDS8jvhi9E8+PrU
         zFEvAE3erJDLr+i8NtmznxI6XcTfCTfrGIjO6JbAtxc+1tHFYORQajTCnJ70uMnxaVmS
         DuOZ8AYQm0YM4J05Skb9n0e+H0UTPHTBcxTliU99ZTTmwS5gmh9Jwmrn8WPoyX1fZTlY
         OkvvffT+udGczmRuRhmTv8WLdyKPMlQ3MwIl66xURHXx9AbHkewn9YW4E3aZWtFng3gH
         VDkfcq20fweOwLkFqbefLQrz5D/NV/4rBnJ+/M34zzPBQ9mBgcM18xEvZPAgOOybzJUz
         dBaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770139578; x=1770744378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Je6+aFnrki7tfkC50ZjSejlBZpp2E59wtL4ykex4gYo=;
        b=NwG7mAZIGZFDf/65pHpDrDZxaIsjy2BhdehNA1YVpf/CHUtoagT2BXZ8InvcfUgCx2
         /gOls8idTaWBSsqvsY+aURXW1YPpoO1LQF2OR6RhtxL2aCwb41V/WzFPv2cjrUNVx1y5
         G3kYXu9vzZ+sVm8d91llen1ZN8YIRHkBxU1/Dbm0ZuBLApXuLkzdm0RvAsB20qWT5lFH
         pO+Yq6HrtOgyw4f4Dx5jrvUZQedXTI0mHgFhy5cj2qaXQbOy1tNPxQU+11KuZb6r+6aR
         BgTISolx8zctXKvj2H/PWGOIozAqaPg/4AMvgewHzZ940PCzjB8VsmGCD7VKJyYLUKG2
         4j2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770139578; x=1770744378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Je6+aFnrki7tfkC50ZjSejlBZpp2E59wtL4ykex4gYo=;
        b=K75cOH9Tqr06N5S1gAiTLxrVgB8+M1i2nJdMoAzXW1q+XrAMNF5g4rnFS9PC6aaE1s
         awuYUSBkcos4U3vWCthDTqhEUA0h6Yc4hyj7Voe/bmIlbgFwg1ec4iTBGI5kE/Z/rT+Y
         aBXmLyeBeuPxOiPG0iO7uzUL+AroTy5/PeGtOh0nF2EPfXcSAXCOaHAD1dxU2+leAUdf
         uDKUEJ1/7YwmyGy/b6JGky5tgKDH/PmR1EG4CHIx2JW9C9KFUgM0ozSRDGbVgko8iCnc
         Nkb7KlBxvQdsUBLe/7XIh9vEPvQD5/Ggx9X8keNB0HO0hvrZRFaGYCN/Ili78dZqS8Xn
         V7yw==
X-Forwarded-Encrypted: i=1; AJvYcCVUL5zlQYOUEYirU5k6931RxK6j6v0kpcz/dMrCl/E+zSFlpyX4mR+MTsMcT0Q5UxkGkv86HBp0hnx49GAqvs0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOZChISbjGtiPxgIFeJkPQXXe2t/f3/qPTTxnoQFzg4RDWcro3
	A8PHJtSRvCG0J6uzz/I2yTwQ6/cQYQbTWcAmC3V+mUZBiINNnPfz0pj2ViNHA+oK7DYH4LzMq5Y
	8/IWMdhWfi4utYnAikRMCOLTECOqzv17EJswL
X-Gm-Gg: AZuq6aK8JeB3bOoZaJBWr11ZL1+KzuPVlPNxtt8mqqhEQ9IEC9iF6uA3XwWRvFoaNeO
	EAUREj0RJOR4lzR93Q7MFtXCrK2VHNvLOSbacwLmYvQBLBraFhNMOa/a+bzxdneT1BkJloq/K0o
	gBmmnkoxREUthGG8D0J5POvkLuXBV7skqKeKAoDrGkwA/4SEtp5koEAtAWHsbE3mNwpGsASJfWX
	Us1P5Iu4wHayEEshb2WQCU0DPtboJYdh2EnWu3vcJywnxQRv1xhLSRHWOwZmkpwY5qBy7o2x3bi
	zUkWN1QWEudfsh8hqrANwVrCkQ==
X-Received: by 2002:a05:7300:6d03:b0:2b7:3538:ce5c with SMTP id
 5a478bee46e88-2b832875f28mr114831eec.2.1770139577608; Tue, 03 Feb 2026
 09:26:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJ-1uKHCK_yGx7WUAyOpoTn5QJFhu5khG4W17Foj_3ovgTjPwQ@mail.gmail.com>
 <aXzV1cB0zHqe4wwl@orbyte.nwl.cc> <CAJ-1uKFUx4zi-g71kKzphzRQJFH36M6SwGwdLpAMjYivbqWmXg@mail.gmail.com>
 <aYE--kfgDkYzASQm@chamomile>
In-Reply-To: <aYE--kfgDkYzASQm@chamomile>
From: Mathieu Patenaude <mpatenaude@gmail.com>
Date: Tue, 3 Feb 2026 12:26:06 -0500
X-Gm-Features: AZwV_QgmhKRPsGPNTSVNk9Vjf0_svLuJWFmqFPvj9z0WWD3pydviYkDlkakaers
Message-ID: <CAJ-1uKGPCcXtQ3q1nGq=nOjzQZs3bqod6jAvK2_Y2dY58wG6yg@mail.gmail.com>
Subject: Re: nft bash completion
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Like you said, the script I wrote gets part of the job done, it at
least takes care of the completion of the -*/--* options and the
defined object names like set, chain, map, flowtable, counter, quota,
limit, ct helper, ct expectation, ct timeout.  It currently completes
these names in basic operations like "list" or "add", but not when
used within the definition of a rule, i.e. @set_name for example.  I
just thought it would be a good starting point.

The current version of the script is based on the position of the
parameters.  That said, if we wanted to auto-complete every @set_name
(regardless of the rule syntax correctness), that would be easy to
implement.  But to auto complete a "named limit", like in: 'limit name
"my_limit_name" log prefix ...' that would probably mean understanding
what comes after "limit name".  I haven't looked at this issue beyond
what is currently implemented in the script.

1. Sudo / root.  Question: are there any plans to add the "table name"
as an argument to most plurals, so when you type "nft list limits
inet", you could write "nft list limits inet test_table" to get the
limit defined only in the test_table?  That would remove the need for
sudo in  https://github.com/mpatenaude/bash-nft-completion/blob/main/nft#L1=
4
and make this much cleaner.

2. For the command line "escaping", here are two examples of the same resul=
ts:

nft add table inet test_table { limit global_log_limit { rate 1/second \; }=
 \; }
  or
nft add table inet test_table '{ limit global_log_limit { rate 1/second ; }=
 ; }'

Since we're talking about autocompleting, should it suggest the
closing ";" if so is it best to escape it, or what if the user escapes
the entire "definition", like in the second example above?  Should it
even suggest the starting {, since the command is also valid if it
stops after the table_name? etc.

3. In my environment, rule changes are versioned and deployed by
automation.  If deployed manually, they are still versioned (in git)
so we can keep track of what was done when.  The only time an admin
actually use nft live at the command prompt is to test new rules and
debug, mostly ending up just listing stuff, counters, etc.  Very
rarely typing an entire rule and even less expecting every rule syntax
element to auto complete.

4.  traditionally bash completions implemented in "scripts" like this
one always become out-of-sync with the command they are completing.
Having the script collocated with the command project is the best
approach, but still poses a maintenance burden. It is up to the
project committer to decide the level of complexity they want into the
"script" vs allocating time to replace it with something integrated
into the command itself.

For full coverage, having the completion integrated in the nftables
command itself would be ideal, but it's been 30+ years since I've
coded in C, so I'll leave this to the experts! ;-)

Cheers!
Math.

On Mon, Feb 2, 2026 at 7:19=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> Hi,
>
> On Fri, Jan 30, 2026 at 01:26:43PM -0500, Mathieu Patenaude wrote:
> > Hi Phil,
> >
> > Thanks for looking into this, hopefully it's a small break from the
> > complex nftables c code ;-)
>
> ... interfering in this discussion.
>
> > The current code gets you up to the point where you need to define the
> > "object" specifics.  At the shell, the problem I see is the escaping
> > of special characters ( { } ; ) and basically not wanting to reproduce
> > the entire nft parser in bash.
> >
> > I can be very wrong on this, my observation is that most users define
> > things using a file (or file "like" or automation) method and mostly
> > use shell command line to do "simpler" things. I guess if we wanted
> > to auto complete everything at the shell without having to maintain
> > the equivalent of the nft option parser in bash, the autocomplete
> > would need to be in the nft command itself, i.e. it would be great
> > if the "nft --interactive" mode had auto-completion, we could
> > somehow find an efficient way to leverage it from bash, removing
> > most of the need for the Bash'i'ism ;-)
>
> It would be really good to have this consolidated, then expose a new
> option that tells what is possible from an incomplete command.
>
> > But then again, there is the "escaping special characters" fun part.
>
> What is the issue specifically? Would providing some context to the
> autocomplete feature help? ie. "autocomplete, but this is bash". Or,
> are you already seeing scenarios in which this approach will lead to
> ambiguous autocomplete results that are difficult to address?
>
> Or is it just the complexity associate to dealing with the bison
> parser, I understand consolidated approach is harder.
>
> > I realize I posted a link to the nft completion itself, but I had a
> > note about sudo at the "project" (two files!) level here
> > https://github.com/mpatenaude/bash-nft-completion/tree/main
>
> But short term / easier approach that can be replaced by the
> consolidated autocompletion in nft later on should also be fine, which
> is what I think you're proposing: a script. Given such script can be
> simplified later on once the nft consolidated autocompletion is
> available.
>
> Are you planning to explore adding support for more complex stuff such
> as concatenations and maps?
>
> > The use of sudo / root is required for viewing the current ruleset, so
> > as soon as you need to auto complete an actual "object name", yes root
> > privileges are needed.  The no password OR cached sudo creds (via sudo
> > -v) is a requirement of the former, otherwise it would make the "auto
> > completion" pretty awkward, like, a  [tab] "enter your password", each
> > time you need to get a list of defined "objects".
> >
> > For my use, this was initially put together for the "list" command so
> > it allowed the completion of the top most objects, like table, set,
> > chain, names.  I based the current version on this  "spec", not very
> > technical, but from the man page:
> > https://github.com/mpatenaude/bash-nft-completion/blob/main/positional-=
args-schema.txt.
> >
> > Just to be sure I explain this correctly, for example:  nft list set
> > <family> <table> <set> will go like this:
> >
> > # Prerequisites: cache the sudo credential if you don't have sudo
> > configured for NOPASSWD for the /usr/sbin/nft command, or just become
> > root...
> > [mathp@dev01 /]$ sudo -v
> > [sudo] password for mathp:
> >
> > # Lists all top level options
> > [mathp@dev01 /]$ nft
> > -v                  --handle            --numeric           --file
> >          delete
> > -V                  -s                  -y                  -D
> >          create
> > --version           --stateless         --numeric-priority  --define
> >          get
> > -h                  -t                  -p                  -I
> >          replace
> > --help              --terse             --numeric-protocol
> > --includepath       rename
> > -i                  -S                  -T                  -d
> >          monitor
> > --interactive       --service           --numeric-time      --debug
> >          list
> > -c                  -N                  -e                  reset
> >          insert
> > --check             --reversedns        --echo              destroy
> > -o                  -u                  -j                  flush
> > --optimize          --guid              --json              add
> > -a                  -n                  -f                  describe
> >
> > # once you start the positional options (ex. list) it no longer
> > propose -/--flags, will also only propose what can be "listed" or
> > "added", etc.
> > # If you start typing f[tab] it does auto-complete until "flowtable"
> > and propose flowtable and flowtables for example.
> > [mathp@dev01 /]$ nft --handle list
> > chain       flowtable   quota       table       flowtables  maps       =
 tables
> > counter     limit       ruleset     chains      hooks       quotas
> > ct          map         set         counters    limits      sets
> >
> > # This is where the auto completion is opinionated, it currently
> > requires that you select the family, if you skip it, then it stops
> > proposing completion
> > [mathp@dev01 /]$ nft --handle list set
> > arp     bridge  inet    ip      ip6     netdev
> >
> > # This is where "root" (sudo) is required, to list the actual table
> > names and propose them
> > [mathp@dev01 /]$ sudo nft --handle list set inet
> > firewalld                  systemd_cgroups_isolation
> >
> > # Sudo  required to propose the defined set names for auto complete:
> > [mathp@dev01 /]$ sudo nft --handle list set inet systemd_cgroups_isolat=
ion
> > inbound_only_cgroups  test_set
> >
> > # Auto complete the set name.
> > [mathp@dev01 /]$ sudo nft --handle list set inet
> > systemd_cgroups_isolation inbound_only_cgroups
> > table inet systemd_cgroups_isolation {
> >         set inbound_only_cgroups { # handle 4
> >                 type cgroupsv2
> >                 elements =3D { 48026 }
> >         }
> > }
> >
> > # Adding a set for example, auto completion "propose stuff" until
> > "test_set" is entered.
> > [mathp@dev01 /]$ sudo nft add set inet systemd_cgroups_isolation
> > test_set '{ type ipv4_addr; }'
> >
> > # lots of chains, yes it helps auto complete any one of those names ;-)
> > [mathp@dev01 /]$ nft list chain inet firewalld
> > Display all 117 possibilities? (y or n)
> >
> > [mathp@dev01 /]$ nft list chain inet firewalld mangle_PRE
> > mangle_PREROUTING                        mangle_PRE_acme_log
> > mangle_PREROUTING_POLICIES               mangle_PRE_acme_deny
> > mangle_PRE_drop                          mangle_PRE_acme_allow
> > mangle_PRE_drop_pre                      mangle_PRE_acme_post
> > mangle_PRE_drop_log                      mangle_PRE_policy_allow-host-i=
pv6
> > mangle_PRE_drop_deny                     mangle_PRE_policy_allow-host-i=
pv6_pre
> > mangle_PRE_drop_allow                    mangle_PRE_policy_allow-host-i=
pv6_log
> > mangle_PRE_drop_post                     mangle_PRE_policy_allow-host-i=
pv6_deny
> > mangle_PRE_acme                      mangle_PRE_policy_allow-host-ipv6_=
allow
> > mangle_PRE_acme_pre                  mangle_PRE_policy_allow-host-ipv6_=
post
> >
> > Best,
> > Math.
> >
> >
> > On Fri, Jan 30, 2026 at 11:01=E2=80=AFAM Phil Sutter <phil@nwl.cc> wrot=
e:
> > >
> > > Hi Mathieu,
> > >
> > > On Mon, Jan 26, 2026 at 10:26:16PM -0500, Mathieu Patenaude wrote:
> > > > Just inquiring to see if there is any interest in adding nft bash
> > > > completion to the nftables project tree?  I only found a reference =
to
> > > > it dating back to 2016 (patchwork RFC), but I'm unclear if this was
> > > > ever merged or if I'm just looking in the wrong place.
> > >
> > > AFAIK nothing exists yet.
> > >
> > > > I wrote something that works:
> > > > https://github.com/mpatenaude/bash-nft-completion/blob/main/nft
> > > >
> > > > Let me know if that can be helpful.
> > >
> > > Just to clarify:
> > >
> > > | # - Provides completions up to the start of a statement (until a '{=
' is needed).
> > >
> > > So this does not complete statements/expressions when adding a rule, =
and
> > > completing the initial part is limited since it can't find out which
> > > ruleset elements exist already unless sudo does not require a passwor=
d.
> > >
> > > Is the latter a requirement for the former? I.e., could it continue t=
o
> > > complete something like 'nft add rule t c ip ' despite it does not kn=
ow
> > > what "t" or "c" is supposed to be?
> > >
> > > Cheers, Phil
> >
