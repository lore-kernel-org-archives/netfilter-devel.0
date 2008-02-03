From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 16/34]  Introduce IP2STR module which convert IP to string.
Date: Sun, 03 Feb 2008 12:55:23 +0100
Message-ID: <47A5ABAB.4030608@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <12019874692227-git-send-email-eric@inl.fr> <12019874701613-git-send-email-eric@inl.fr> <12019874702005-git-send-email-eric@inl.fr> <12019874703998-git-send-email-eric@inl.fr> <12019874701589-git-send-email-eric@inl.fr> <12019874701366-git-send-email-eric@inl.fr> <12019874704144-git-send-email-eric@inl.fr> <12019874703136-git-send-email-eric@inl.fr> <12019874701552-git-send-email-eric@inl.fr> <12019874701370-git-send-email-eric@inl.fr> <12019874702349-git-send-email-eric@inl.fr> <12019874703504-git-send-email-eric@inl.fr> <12019874704067-git-send-email-eric@inl.fr> <12019874703897-git-send-email-eric@inl.fr> <12019874712066-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44471 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758675AbYBCLzi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:55:38 -0500
In-Reply-To: <12019874712066-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: Eric leblond <eric@inl.fr>
> 
> This module is a generic module which is used to convert an IP from internal
> representation to string representation. This is a task needed by several modules
> like printpkt or pgsql. This module factorizes the code.

Applied with minor glitches. Thanks.

> +static int ip2str_start(struct ulogd_pluginstance *upi)
> +{
> +	return 0;
> +}
> +
> +static int ip2str_fini(struct ulogd_pluginstance *upi)
> +{
> +	return 0;
> +}

Removed this since they are not required.

> +static struct ulogd_plugin ifindex_plugin = {
                                 ^^^

Mind the copy and paste ;)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
