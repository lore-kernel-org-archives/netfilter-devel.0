From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/3] Do not set oob.family in config as it can be
 found in packet.
Date: Sat, 09 Feb 2008 18:21:29 +0100
Message-ID: <47ADE119.7070606@netfilter.org>
References: <12023725412-git-send-email-eric@inl.fr> <1202372541106-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40615 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754125AbYBIRVm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:21:42 -0500
In-Reply-To: <1202372541106-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> WHen using NFLOG or ULOG, obb.family (protocol IPv4 or IPv6) has
> to be setup manually in ulogd.conf configuration file. This was
> used to have the BASE filter parse accordingly the packet. This
> patch suppress oob.family as output keys of NFLOG and ULOG and let
> the BASE filter determine the family of the packet by itself (by
> parsing the raw header).
> 
> A good side effect is to be able to log in IPv6 and IPv4 in the
> same group. Before that, two loggers have to be setup separatly.

Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
