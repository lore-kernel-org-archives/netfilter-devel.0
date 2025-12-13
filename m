Received: from libra.cs.put.poznan.pl (libra.cs.put.poznan.pl [150.254.30.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DD05475B
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Dec 2025 12:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.254.30.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765629730; cv=none; b=DO6GrbTmOzjNtgH6FDDf9jBF9Z5XkOJPmFQh4tnqVGw98VsS2x2dzM/jaHqw8xt8D0r8ihjsXM2F6cxmNWXOfD5h3ABhDuKjvXTL5pYedVRn86MHhX4SMaKepLFGkc3slVJADNzBMFinFCaYEsUO8qUv0C82CwAdgKVJXIqMByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765629730; c=relaxed/simple;
	bh=aES+7h+0XE9iskl+xKthE4nDoZJmy8tz3xSIC0Iw70k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M083Fz7+JwoJwt7mkEvf98LHSoVkp8eqENW18C3OuTh2q6qX38rJLPGtmzvFq10VC4HsrsG+ktn87u5O2okH3AXDyK4IBhxqJlMpV3A1LmqX2J+2YHRYJqU0H2fniHo8lTeu2M88r8i/WrJHGGKkdeqmN4PvmbVnyRcxKhmaEVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl; spf=pass smtp.mailfrom=cs.put.poznan.pl; dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b=SKhipZTj; arc=none smtp.client-ip=150.254.30.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b="SKhipZTj"
X-Virus-Scanned: Debian amavis at cs.put.poznan.pl
Received: from libra.cs.put.poznan.pl ([150.254.30.30])
 by localhost (meduza.cs.put.poznan.pl [150.254.30.40]) (amavis, port 10024)
 with ESMTP id 5EnPZ9gFfPfH; Sat, 13 Dec 2025 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.put.poznan.pl;
	s=7168384; t=1765627870;
	bh=aES+7h+0XE9iskl+xKthE4nDoZJmy8tz3xSIC0Iw70k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKhipZTjHKDJWgBwwSgIYUToNXfZvRVTY7Pq3C4/w+g4CTQyog3DPCmIclTpkTRzy
	 hjzhG2h8LjSBxw5eEQ/THhE0Je2VWLVoD+7uOWBJcvAFlxKRWgcFtBQ9eB3n0rDvZ6
	 Ky9J/cDW1TpiuXOFVR/u8UPYzR6fqw8sQrNEHELL3AU/0xgNeSab5QAwLdIBGsf+fm
	 aglODQ7bhYQmCNdwHSxGFZe3dxn3nZmwv9wD1+LNk3czJaYnV5WIdEMtKOxJSfwpjk
	 QjTn9itpGLqetEjZvMangM1CVftYpkdH/Ai9zusPsXvC6A2Tx131abu6fPKhFDz9LY
	 iNWsrRAthh6yg==
Received: from imladris.localnet (83.8.88.36.ipv4.supernova.orange.pl [83.8.88.36])
	(Authenticated sender: jkonczak@libra.cs.put.poznan.pl)
	by libra.cs.put.poznan.pl (Postfix on VMS) with ESMTPSA id 604F563C95;
	Sat, 13 Dec 2025 13:32:46 +0100 (CET)
From: Jan =?UTF-8?B?S2/FhGN6YWs=?= <jan.konczak@cs.put.poznan.pl>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] parser_bison: on syntax errors,
 output expected tokens
Date: Sat, 13 Dec 2025 13:32:42 +0100
Message-ID: <6217966.lOV4Wx5bFT@imladris>
Organization: Institute of Computing Science,
 =?UTF-8?B?UG96bmHFhA==?= University of Technology
In-Reply-To: <aTINLRJlBUIox3pC@strlen.de>
References: <1950751.CQOukoFCf9@imladris> <aTINLRJlBUIox3pC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

> Just a note that there might be slight delay with this getting
> applied because we'd like to make a new release soon.

Regarding the patch to dump all expected tokens on syntax errors in
'nft' command: should I modify it somehow so that it gets applied?
Or just wait, or you decided it's not a good idea after all?

In the meantime, I toyed with what parser expects as the next token,
and I see surprises here and there.
=46or example, is it intended that 'add' and 'rule' keywords are
optional? Right now, to add a rule, it suffices:
   nft F I tcp dport ssh accept

Plus, bogon hints from parser occur on parsing expressions such as
   nft add rule ip F I ct state ?
   nft add rule ip F I tcp dport ?
Because all these are parsed by the same subset of grammar rules
(I guess starting at 'relational_expr'), the possible tokens are
the same for any such expr.
By "bogon hints" I mean that commands get parsed successfully but
raise an error later on. E.g., 'nft F I ct state missing' yields
datatype mismatch claiming that missing is a boolean, not a state.

Interestingly, by "abusing" the junk token which always triggers
a syntax error it is possible to create a bash autocompletion script
that tries to execute nft command typed in so far but appended with
junk, and parses expected tokens into completions. I feel ambivalent
if it makes sense to build autocompletion this way, but it speeds up
checking what the parser expects.

Simple autocompletion (obviously requiring the patch) follows.
=2D---------------------------
_nft(){
    expectedTokens=3D$(
        "${COMP_WORDS[@]:0:$COMP_CWORD}" $'\025' 2>&1 \
        | grep -A1 "unexpected junk"                   \
        | grep '^expected any of:'                      \
        | cut -d: -f2-                                   \
        | sed 's/, /\n/g'
    )
    [ "$expectedTokens" ] || return 1;
    EXPECTED=3D()   NONKEYWORD=3D()
    while read token; do
        [[ $token =3D=3D '<'*'>'       ]] && { NONKEYWORD+=3D("$token"); co=
ntinue; }
        [[ $token =3D=3D "end of file" ]] && continue
        [[ $token =3D=3D "newline"     ]] && continue=20
        [[ $token =3D=3D "colon"       ]] && { EXPECTED+=3D(':');   continu=
e; }
        [[ $token =3D=3D "semicolon"   ]] && { EXPECTED+=3D('\\;'); continu=
e; }
        [[ $token =3D=3D "comma"       ]] && { EXPECTED+=3D(',');   continu=
e; }
        [[ $token =3D=3D *[[:space:]]* ]] && { printf "\e[s\nautocompletion=
 problem: space in token \"$token\"\n\e[u" 1>&2; continue; }
        EXPECTED+=3D("$token")
    done <<< "$expectedTokens"
    COMPREPLY=3D( $(compgen -W "${EXPECTED[*]}" -- ${COMP_WORDS[$COMP_CWORD=
]}) )
    if [[ $NONKEYWORD ]]; then
        # TODO: logic for values (non-keyword tokens); either call some
        # 'nft list =E2=80=A6' to detect what shall be proposed here and ad=
d it to
        # COMPREPLY, or adjust COMPREPLY if the value is a new name / addre=
ss
        # / port etc. that cannot be completed / guessed.

        if [[ ${COMP_LINE:$COMP_POINT-1:1} =3D=3D [[:space:]] ]] ; then
            # append non-keyword placeholders after a whitespace character =
to
            # make them appear among completions, but be non-autocompletable
            for VAL in "${NONKEYWORD[@]}"; do
                COMPREPLY+=3D(" $VAL")
            done;
            # if there is only one possibility, then add an empty alternati=
ve
            # to prevent autocompleting the name of the non-keyword itself
            # (e.g. 'nft delete rule ip F T handle' expects only <number>)
            [[ ${#NONKEYWORD[@]} =3D=3D 1 && ${#COMPREPLY[@]} =3D=3D 1 ]] &=
& COMPREPLY+=3D("")
        fi
    fi
    return 0;
}
complete -F _nft nft
=2D---------------------------



