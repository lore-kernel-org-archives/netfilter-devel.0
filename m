From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 12:13:29 -0400
Message-ID: <dd45289d0805210913j766083e2m3ae50d846320f09c@mail.gmail.com>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
	 <4833F119.7080206@netfilter.org>
	 <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>
	 <48342C03.10204@netfilter.org>
	 <dd45289d0805210725r4409b860if06bc8adb68059be@mail.gmail.com>
	 <48343B76.4090404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:31400 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYEUQNd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 12:13:33 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1465338tic.23
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2008 09:13:31 -0700 (PDT)
In-Reply-To: <48343B76.4090404@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

On Wed, May 21, 2008 at 11:10 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> NICOLAS BOULIANE wrote:
>> Pablo,
>>
>> It fixed the strdup(). But now:
>>
>> cc1: warnings being treated as errors
>> read_config_lex.c: In function 'yylex':
>> read_config_lex.c:3846: warning: label 'find_rule' defined but not used
>> make[1]: *** [read_config_lex.o] Error 1
>>
>>
>> if I strip this label (find_rule), then I get:
>>
>> read_config_lex.c:3593: warning: 'yy_full_match' defined but not used
>> make[1]: *** [read_config_lex.o] Error 1
>> make[1]: Leaving directory `/usr/local/src/conntrack-tools/src'
>> make: *** [all-recursive] Error 1
>>
>>
>> If I remove this function (yy_full_match), then I get:
>>
>> cc1: warnings being treated as errors
>> read_config_lex.c: In function 'yylex':
>> read_config_lex.c:3782: warning: 'yy_act' may be used uninitialized in
>> this function
>> make[1]: *** [read_config_lex.o] Error 1
>>
>> If I initialize this var (register int yy_act = 0;), then I get:
>>
>> everything compile now.
>
> This report is really strange, your flex implementation is generating
> useless code. What version are you using? Here I'm using flex 2.5.33.
>


[nib@bwm ~]$ flex --version
flex version 2.5.4
[nib@bwm ~]$

[nib@bwm ~]$ yum info flex
Loading "installonlyn" plugin
Setting up repositories
Reading repository metadata in from local files
Installed Packages
Name   : flex
Arch   : i386
Version: 2.5.4a
Release: 41.fc6
Size   : 239 k
Repo   : installed
...

Centos is running on this machine.

>> I'm using a version I compiled without the -Werror flag, it was more clean.
>
> The -Werror is there to catch this sort of problems and force users to
> report them ;), I plan to keep it there until conntrack-tools hits 1.0
> at least.

It's a good idea :)

>
> Probably we have to check for a specific version of flex.
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>

Nick
