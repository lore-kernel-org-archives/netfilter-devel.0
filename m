From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 05/34]  Add --info option which displays information about
 plugin.
Date: Sun, 03 Feb 2008 12:30:13 +0100
Message-ID: <47A5A5C5.8030701@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <12019874692227-git-send-email-eric@inl.fr> <12019874701613-git-send-email-eric@inl.fr> <12019874702005-git-send-email-eric@inl.fr> <12019874703998-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46028 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754300AbYBCLad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:30:33 -0500
In-Reply-To: <12019874703998-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> It is difficult to find how to configure a plugin. This patch adds an info
> option which can be used to display:
> * Name
> * Configuration variables
> * Input keys
> * Output keys
> 
> Output exemple:
> /opt/ulogd2/sbin/ulogd --info /opt/ulogd2/lib/ulogd/ulogd_filter_IFINDEX.so
> Name: IFINDEX
> Input keys:
>         Key: oob.ifindex_in (unsigned int 32)
>         Key: oob.ifindex_out (unsigned int 32)
> Output keys:
>         Key: oob.in (string)
>         Key: oob.out (string)

Applied. Thanks. BTW, please break lines at 80 chars. I have fix this
myself.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
