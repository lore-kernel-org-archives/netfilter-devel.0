From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables crashed
Date: Sun, 15 Nov 2009 11:09:10 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911151108530.21283@obet.zrqbmnf.qr>
References: <328fe7150911131753x38a1b46dg5e16e2cf08efc357@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: basteon <basteon@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48164 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZKOKJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:09:05 -0500
In-Reply-To: <328fe7150911131753x38a1b46dg5e16e2cf08efc357@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2009-11-14 02:53, basteon wrote:

>hello every1,
>why if I tried to use this code, I've got segfault everytime?
>int main(void){
>printf("AFTER\n");
>xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
>printf("BEFORE\n");
>exit(1);
>}

You are not allowed to just call xtables_error without the 
initialization that iptables.c etc. do.
