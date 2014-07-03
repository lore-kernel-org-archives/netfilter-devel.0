From: Patrick McHardy <kaber@trash.net>
Subject: Re: [linux PATCH v3 2/5] netfilter: nf_nat_masquerade_ipv4: code factorization
Date: Thu, 03 Jul 2014 14:23:20 +0200
Message-ID: <698ea380-0754-47de-a4a1-9023ebf8388c@email.android.com>
References: <20140701162801.2847.14389.stgit@nfdev.cica.es> <20140701163034.2847.53931.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49494 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaGCMXd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:23:33 -0400
In-Reply-To: <20140701163034.2847.53931.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1. Juli 2014 18:30:54 MESZ, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>Let's refactor the code so we can reach the masquerade functionality
>from
>outside the xt context (ie, nftables).
>
>The patch includes adding an atomic counter to the masquerade notifier:
>the
>stuff to be done by the notifier is the same in any case, and agnostic
>about who called it. Only one notification handler is needed.
>
>This factorization only involves IPv4; a similar patch will follow to
>handle
>IPv6.

Just a suggestion, the NAT support is parameterizable at  runtime.
An alternative would be an expression to load the local address.


-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
