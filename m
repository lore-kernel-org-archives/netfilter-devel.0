From: "Sven-Ola Tuecke" <sven-ola@gmx.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 09:40:07 +0200
Message-ID: <201010070940.08259.sven-ola@gmx.de>
References: <201010061842.20142.sven-ola@gmx.de> <201010070837.42018.sven-ola@gmx.de> <alpine.LNX.2.01.1010070913480.28056@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36876 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759980Ab0JGHkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:40:17 -0400
In-Reply-To: <alpine.LNX.2.01.1010070913480.28056@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Am Donnerstag, 7. Oktober 2010, um 09:16:59 schrieben Sie:

> 1.75 MB sounds like an older model, however, that "linux 2.4 use forced"
> statement is bogus for WRT54GL (4MB Flash) since at least openwrt
> 8.09/Linux 2.6.25.

Yep, e.g. WAP54Gv2/v3. Only 2.4 Watt. And no: OpenWrt Backfire still supports a 
brcm-2.4 target. You can use 2.6, but the opensourced WLAN driver does not 
work well. You loose e.g. IBSS, AP mode, distance setting and (more criticial) 
stability. Maybe the latest Broadcom code-drop may solve this but I don't 
expect this to show up in 2010...

> 
> >As Jan pointed out: copy of the addresses may be stored elsewhere in the
> >form of hash keys. At least, I will place a warning in the docs and check
> >for oopses if conntrack is active. You think about a single rule either
> >in POSTROUTING or PREROUTING. May overcome above conntrack hash prob...
> >Good point - I place it on the TODO.
> 
> RAWS/DNAT in Xtables-addons has this solved by using the raw and rawpost
> tables.

No RAW table in 2.4 AFAICT. But a good hint, I'll check that. As a first 
measure I placed a big fat warning at the start of the readme. Ref:

http://map66.svn.sourceforge.net/viewvc/map66/README.html

// Sven-Ola
