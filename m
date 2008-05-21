From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 17:10:46 +0200
Message-ID: <48343B76.4090404@netfilter.org>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>	 <4833F119.7080206@netfilter.org>	 <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>	 <48342C03.10204@netfilter.org> <dd45289d0805210725r4409b860if06bc8adb68059be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52083 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764845AbYEUPK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 11:10:57 -0400
In-Reply-To: <dd45289d0805210725r4409b860if06bc8adb68059be@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NICOLAS BOULIANE wrote:
> Pablo,
> 
> It fixed the strdup(). But now:
> 
> cc1: warnings being treated as errors
> read_config_lex.c: In function 'yylex':
> read_config_lex.c:3846: warning: label 'find_rule' defined but not used
> make[1]: *** [read_config_lex.o] Error 1
> 
> 
> if I strip this label (find_rule), then I get:
> 
> read_config_lex.c:3593: warning: 'yy_full_match' defined but not used
> make[1]: *** [read_config_lex.o] Error 1
> make[1]: Leaving directory `/usr/local/src/conntrack-tools/src'
> make: *** [all-recursive] Error 1
> 
> 
> If I remove this function (yy_full_match), then I get:
> 
> cc1: warnings being treated as errors
> read_config_lex.c: In function 'yylex':
> read_config_lex.c:3782: warning: 'yy_act' may be used uninitialized in
> this function
> make[1]: *** [read_config_lex.o] Error 1
> 
> If I initialize this var (register int yy_act = 0;), then I get:
> 
> everything compile now.

This report is really strange, your flex implementation is generating
useless code. What version are you using? Here I'm using flex 2.5.33.

> I'm using a version I compiled without the -Werror flag, it was more clean.

The -Werror is there to catch this sort of problems and force users to
report them ;), I plan to keep it there until conntrack-tools hits 1.0
at least.

Probably we have to check for a specific version of flex.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
