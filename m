From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 0/3] cleaning and build feature
Date: Fri, 12 Sep 2008 01:49:40 +0200
Message-ID: <48C9AE94.1000208@netfilter.org>
References: <> <1221166085-23435-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52920 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753839AbYIKX4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:56:09 -0400
In-Reply-To: <1221166085-23435-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> This small patchset contains some cleaning and implement conditionnal compilation
> of NFLOG and NFCT input plugins. This feature was contained in the TODO list and I
> think it could be useful on system where one of the NFCT or NFLOG plugin can not
> be used.
> 
> Las tpatch update the TODO list.  The remaining item in this TODO list are:
>  - add support for capabilities to run as non-root: It could be interesting but
>  I don't know if we could achieve it with libnetfilter_log or libnetfilter_conntrack.

The binding and the sending requires CAP_NET_ADMIN, so we can initially
bind as root and them change to a non-root user to receiver messages,
this seem feasiable with libnetfilter_log. However, the problem here is
the resynchronize routine that I have introduced in NFCT: we request a
dump when we hit ENOBUFS and that's a sending.

Let me think about, maybe we can do something with a fork and a pipe.

>  - support for static linking: As ulogd2 is plugin based, it may be strange but some
>  embedded system could use it.
>  - issues with ulogd_BASE and partially copied packets (--ulog-cprange): Has somebody
>  encounter the problem ?
>  - problem with ulogd_BASE and fragments:  same remark

Probably outdated comment? We can ask Harald during workshop days.

>  - port SQLITE3 plugin: Holger's work could be reused but the code was not really clean.

We can recover that work. We also have to add a change to db.c since
SQLITE3 has no procedures IIRC.

>  - convert db layer and pgsql + mysql plugin to a 'parameter bind' scheme for efficiency:
>  I don't understand the point.

Probably Harald can put some light on it.

>  - autoconf detection of SCTP / DCCP support: Well, why not ;)
> 
> From my point of view, there is no other thing in the TODO list before a RC release.
> 
> Am I missing something ?

I have added BSF support to libnetfilter_conntrack. This could be
interesting to filter ctnetlink event messages from kernel-space. You
can find an example in the configuration file of conntrackd, see the
Filter clause.

The problem is the current configuration file format which is quite
cryptic. Using something flex/bison-based would be more flexible, but we
have to think about the file format before.

I have other concerns, I'm willing to schedule some time for ulogd to
make a new TODO list, we can probably discuss them during the workshop.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
