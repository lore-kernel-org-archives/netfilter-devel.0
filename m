From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ulogd2 on valgrind
Date: Fri, 25 Nov 2011 22:47:57 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111252247420.8862@frira.zrqbmnf.qr>
References: <4ECD09DB.2060808@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45623 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab1KYVr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Nov 2011 16:47:58 -0500
In-Reply-To: <4ECD09DB.2060808@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-11-23 15:57, marty wrote:

> Ulogd2 was compiled from current Git using recent x86 toolchain.
>
> # valgrind --leak-check=yes  /usr/sbin/ulogd -d
> ==22245== Memcheck, a memory error detector
> ==22245== Copyright (C) 2002-2011, and GNU GPL'd, by Julian Seward et al.
> ==22245== Using Valgrind-3.8.0.SVN and LibVEX; rerun with -h for copyright info
> ==22245== Command: /usr/sbin/ulogd -d
> ==22245==
> ==22245== Invalid read of size 4
> ==22245==    at 0x804A012: create_stack (ulogd.c:536)
> ==22245==    by 0x804C83D: config_parse_file (conffile.c:198)
> ==22245==    by 0x804B4DC: main (ulogd.c:949)
> ==22245==  Address 0x28 is not stack'd, malloc'd or (recently) free'd

Can you provide the config file?
