From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ipset and interfaces
Date: Tue, 24 May 2011 13:43:07 +0100
Message-ID: <4DDBA7DB.9010102@googlemail.com>
References: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com> <alpine.DEB.2.00.1105241344200.1846@blackhole.kfki.hu> <BANLkTi=drvnwAiXk-Js+1Dw0wxWGNsT1xA@mail.gmail.com> <alpine.DEB.2.00.1105241433030.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Oskar Berggren <oskar.berggren@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49049 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1EXMnL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:43:11 -0400
Received: by wwk4 with SMTP id 4so2398277wwk.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 05:43:10 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241433030.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> So it looks like a valid case, for a new set type with interfaces and IP 
> addresses/networks ;-) I'll work on it.
>   
Keep in mind though, that interfaces can be specified in "-i" as well as 
"-o" (i.e. input as well as output) - so you need to create some sort of 
matching mechanism which distinguishes between these. Obviously this is 
currently resolved in iptables with the "-i" and -"o" options respectively.

