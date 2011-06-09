From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 15:33:23 +0200
Message-ID: <20110609133323.GG8745@mail.wzdftpd.net>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Tihomir Katic <tihomir.katic@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.wzdftpd.net ([91.121.80.151]:50796 "EHLO mail.wzdftpd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab1FINip (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:38:45 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 09, 2011 at 03:18:38PM +0200, Tihomir Katic wrote:
> Hi
>=20
> I developed some firewall optimizer for iptables optimization.
>=20
> FIRO is parsing output of iptables-save command and removes redundant
> rules from it. Rules in each chain and table are optimized separately=
=2E
> Optimization procedure continues until there are no more rules to
> remove or to modify. As a result, FIRO generates new file with new se=
t
> of rules for every successful optimization procedure. Also, it logs
> all actions and changes in separated files.
>=20
> List of optimization procedures:
>  -  Remove irrelevant rules
>  -  Remove redundant "shadowed after" rules
>  -  Remove redundant "shadowed before" rules
>  -  Remove last rules with same action as chain
>  -  Merge rules
>  -  Remove redundant parameters from rules
>  -  Remove redundant elements from parameters
>  -  Reposition of "logging" rules in chain
>=20
> This is free software, 1st published version, and I would appreciate
> every download, every test, every reported bug, suggestion, etc.
>=20
> Link to FIRO:
> http://valeria.zesoi.fer.hr/~tkatic

Hi,

There are some problems with the download link:
- as Patrick said, please do not use a rar file, tar.gz is better
- please package it as a directory (and not unpack all files in current
  directory)
- please provide a build system (a Makefile)

There are many build errors:
CharField.cpp: In destructor =E2=80=98cCharField::~cCharField()=E2=80=99=
:
CharField.cpp:37:12: error: =E2=80=98free=E2=80=99 was not declared in =
this scope
=2E.
Configuration.cpp: In member function =E2=80=98void cConfiguration::Log=
DebugData(int, std::string)=E2=80=99:
Configuration.cpp:160:38: error: =E2=80=98fopen=E2=80=99 was not declar=
ed in this scope.

Pierre
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
