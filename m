From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 02/11] added struct local_server
Date: Wed, 23 Jan 2008 11:36:50 +0100
Message-ID: <479718C2.9060606@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.5800.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34101 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbYAWKiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:38:05 -0500
In-Reply-To: <20080122141051.30077.5800.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  include/conntrackd.h |    2 +-
>  include/local.h      |   11 ++++++++---
>  src/local.c          |   17 ++++++++++-------
>  src/run.c            |   16 +++++++++-------
>  4 files changed, 28 insertions(+), 18 deletions(-)

Applied with some minor changes. Split one wraparound line (over 80
chars per column). Reserve space for the string in local_server struct.
I know, this duplicates the space used since now we have two array of
UNIX_PATH_MAX size in ct_conf and ct_state, however I prefer it to avoid
dependencies between structures.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
