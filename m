From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCHv2] extensions: libxt_CHECKSUM extension
Date: Sun, 11 Jul 2010 17:57:07 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007111755250.22644@obet.zrqbmnf.qr>
References: <20100711151453.GA7563@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: mst@redhat.com,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49674 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0GKP5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 11:57:11 -0400
In-Reply-To: <20100711151453.GA7563@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>This adds a `CHECKSUM' target, which can be used in the iptables mangle 
>table.
>
>You can use this target to compute and fill in the checksum in a packet 
>that lacks a checksum.  This is particularly useful, if you need to 
>work around old applications such as dhcp clients, that do not work 
>well with checksum offloads, but don't want to disable checksum offload 
>in your device.
>
>The problem happens in the field with virtualized applications. For 
>reference, see Red Hat bz 605555, as well as 
>http://www.spinics.net/lists/kvm/msg37660.html

Added to Xtables-addons.
