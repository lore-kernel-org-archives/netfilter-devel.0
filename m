From: Tihomir Katic <tihomir.katic@gmail.com>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 15:39:55 +0200
Message-ID: <BANLkTim994oFbnN-ef06kUdooaiU9tOJJA@mail.gmail.com>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
	<20110609133323.GG8745@mail.wzdftpd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@wzdftpd.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39297 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab1FINj4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:39:56 -0400
Received: by iyb14 with SMTP id 14so1311185iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 06:39:55 -0700 (PDT)
In-Reply-To: <20110609133323.GG8745@mail.wzdftpd.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pierre

Thank you

You are right, my mistake with .rar (please use unrar until I change
it on web server)

Makefile should have only
# g++ -o FIRO FIRO.cpp
g++ (GCC) 3.4.6
Copyright (C) 2006

which is pretty old version, I didn't try it with newer...

Br
Tihomir



2011/6/9 Pierre Chifflier <chifflier@wzdftpd.net>:
> On Thu, Jun 09, 2011 at 03:18:38PM +0200, Tihomir Katic wrote:
>> Hi
>>
>> I developed some firewall optimizer for iptables optimization.
>>
>> FIRO is parsing output of iptables-save command and removes redundan=
t
>> rules from it. Rules in each chain and table are optimized separatel=
y.
>> Optimization procedure continues until there are no more rules to
>> remove or to modify. As a result, FIRO generates new file with new s=
et
>> of rules for every successful optimization procedure. Also, it logs
>> all actions and changes in separated files.
>>
>> List of optimization procedures:
>> =A0- =A0Remove irrelevant rules
>> =A0- =A0Remove redundant "shadowed after" rules
>> =A0- =A0Remove redundant "shadowed before" rules
>> =A0- =A0Remove last rules with same action as chain
>> =A0- =A0Merge rules
>> =A0- =A0Remove redundant parameters from rules
>> =A0- =A0Remove redundant elements from parameters
>> =A0- =A0Reposition of "logging" rules in chain
>>
>> This is free software, 1st published version, and I would appreciate
>> every download, every test, every reported bug, suggestion, etc.
>>
>> Link to FIRO:
>> http://valeria.zesoi.fer.hr/~tkatic
>
> Hi,
>
> There are some problems with the download link:
> - as Patrick said, please do not use a rar file, tar.gz is better
> - please package it as a directory (and not unpack all files in curre=
nt
> =A0directory)
> - please provide a build system (a Makefile)
>
> There are many build errors:
> CharField.cpp: In destructor =91cCharField::~cCharField()=92:
> CharField.cpp:37:12: error: =91free=92 was not declared in this scope
> ..
> Configuration.cpp: In member function =91void cConfiguration::LogDebu=
gData(int, std::string)=92:
> Configuration.cpp:160:38: error: =91fopen=92 was not declared in this=
 scope.
>
> Pierre
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
