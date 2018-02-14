From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: Make missing docbook2man an error if man
 build requested
Date: Wed, 14 Feb 2018 19:43:06 +0100
Message-ID: <20180214184306.kknd6wlxsotfuxhp@salvia>
References: <20180207094000.11494-1-ville.skytta@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Ville =?iso-8859-1?Q?Skytt=E4?= <ville.skytta@iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162101AbeBNSnK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 13:43:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 487B11A0991
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 19:43:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39667DA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 19:43:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207094000.11494-1-ville.skytta@iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 11:40:00AM +0200, Ville Skyttä wrote:
> Previously, if man page build was enabled but no suitable docbook2man or
> the like tool was found, build failed at a later stage with
> undescriptive error message. Fail early and explicitly at configure
> stage instead.

Applied, thanks.
