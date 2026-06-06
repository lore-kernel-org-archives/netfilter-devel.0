Received: from libra.cs.put.poznan.pl (libra.cs.put.poznan.pl [150.254.30.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4652931355D
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jun 2026 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.254.30.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780745840; cv=none; b=CRdvtdnfxTHxleyTpbKG05T4QSUXnhJft2mplaaJqGrWm8Y/H2eNuRA35x7ulIaufhDPwHHAMtqzEB9z2MYmw1iSdeDZ7Uiq0Hi0qRxMev985aJlnaOQNGmeofyqku2YOvcAMtOIEv1qXear/Kt/Zq3LYnUGJjkXD0WAzp1cEOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780745840; c=relaxed/simple;
	bh=TsaC9FVIMN1AYAzZOqp4H4tH1+5j18RHuJcQnM3lfDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEOGlWefcWspAdB3agXms16M4alplehKqPwVpoP3Vw5pr0FmJ9Liti/0sWlciOkH6lM4oDI26yHAu0HFwY3Om5vb8s8cTAnowbHA7HrlgDx7B275gFYJuc0hBfmHgNuhfr2CSo+XnzUO7K4GgGjp4PCu+LcoS3PTNhjzoVYbR+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl; spf=pass smtp.mailfrom=cs.put.poznan.pl; dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b=V+8Zrfdr; arc=none smtp.client-ip=150.254.30.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b="V+8Zrfdr"
X-Virus-Scanned: Debian amavis at cs.put.poznan.pl
Received: from libra.cs.put.poznan.pl ([150.254.30.30])
 by localhost (meduza.cs.put.poznan.pl [150.254.30.40]) (amavis, port 10024)
 with ESMTP id cCJc_Y0EJ4Rs; Sat,  6 Jun 2026 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.put.poznan.pl;
	s=7168384; t=1780745176;
	bh=TsaC9FVIMN1AYAzZOqp4H4tH1+5j18RHuJcQnM3lfDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+8ZrfdrFrWSUFJrLyzhzUOJ+Z617z1YYiasdfgm2iXp/BuGdBd+Gm9vjlCMhkb+o
	 u46oU2MxLJuAlyIgAfLQI8fxJdO4ASlULevX5F6/hcjERP44bhi0AGoMwiq8/y2J+l
	 ZL1eZsWHRNMn+NAT/LaCg/CG0iX6oQdDZ1rvNxd0ulTK+OKUdjNd1B+XWGRjBmG1QV
	 Wokfxu9+lVbezazbimDLBAvTJgoqx9VdSzU6AhttRCWRExCeid2pYHgNylOMsAxidD
	 mmAG43l2LXInfNY5HwswTW+lQT/rSniluBL3RhOMvCBAJ8+FC01ATZ4fWkZrLx2L8I
	 yDmbyWWESA5Tg==
Received: from imladris.localnet (83.8.102.235.ipv4.supernova.orange.pl [83.8.102.235])
	(Authenticated sender: jkonczak@libra.cs.put.poznan.pl)
	by libra.cs.put.poznan.pl (Postfix on VMS) with ESMTPSA id 2C6F863F08;
	Sat,  6 Jun 2026 13:37:05 +0200 (CEST)
From: Jan =?UTF-8?B?S2/FhGN6YWs=?= <jan.konczak@cs.put.poznan.pl>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] parser_bison: on syntax errors,
 output expected tokens
Date: Sat, 06 Jun 2026 13:37:01 +0200
Message-ID: <2063352.yKVeVyVuyW@imladris>
Organization: Institute of Computing Science,
 =?UTF-8?B?UG96bmHFhA==?= University of Technology
In-Reply-To: <aiLr1JDG6oWbg7hS@orbyte.nwl.cc>
References:
 <20260120122954.18909-1-fw@strlen.de> <3901884.MHq7AAxBmi@imladris>
 <aiLr1JDG6oWbg7hS@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

> Or am I missing some detail about YYBISON?

No, I don't think you're missing any detail there. I considered this
less intrusive than forcing a define in the configure.ac. Adding a C
macro BISON_CUSTOM_ERROR from configure is actually more versatile.


I just discovered that while autotools forbid conditional AM_YFLAGS,
they allow conditional YACC. It's counterintuitive to me why.
Yet, the following works in Makefile.am:

| if BISON_CUSTOM_ERROR
| YACC += -D parse.error=custom -D parse.lac=full
| AM_CFLAGS += -DBISON_CUSTOM_ERROR
| else
| YACC += -D parse.error=verbose
| endif

Then, the configure.ac has just to set the BISON_CUSTOM_ERROR, without
putting there the flags/define which nobody expects to be there.
To me this looks cleaner.


I guess adding a AC_ARG_ENABLE on that might be worthwhile, too.
Running "nft --debug parser ..." with parse.lac=full yields extra
output which one may or may not prefer if one wishes to debug
parser_bison.y. I mean, something akin to this:

| AC_ARG_ENABLE([custom_parser_errors],
|        AS_HELP_STRING(
|                [--disable-custom-parser-errors],
|                [Disable use of parse.error=custom and LAC in Bison]
|        ),[
|                # keeping the user choice for custom-parser-errors
|        ],[
|                enable_custom_parser_errors=no
|                AC_SUBST([BISON],[$ac_cv_prog_YACC])
|                AX_PROG_BISON_VERSION([3.6],
|                    [enable_custom_parser_errors=yes])
|        ]
| )
| AM_CONDITIONAL([BISON_CUSTOM_ERROR],
|                [test "x$enable_custom_parser_errors" != xno])


Regards, Jan


