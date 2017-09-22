From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ulog2 PATCH] Non-arbitrary malloc for SQL queries + string
 length limit
Date: Fri, 22 Sep 2017 08:44:21 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1709220841540.12548@n3.vanv.qr>
References: <bcadb7a2-d429-af84-e871-167da12e0819@phpnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Jean Weisbuch <jean@phpnet.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:34322 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdIVGoX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2017 02:44:23 -0400
In-Reply-To: <bcadb7a2-d429-af84-e871-167da12e0819@phpnet.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2017-09-21 19:00, Jean Weisbuch wrote:
>
>   - For strings, SQL_STRINGSIZE now defines the max length of values (before
> being escaped), longer values will be truncated and the double of
> SQL_STRINGSIZE is allocated in case all characters would have to be escaped
>
> I am not sure that truncating values is the best course of action, maybe
> replacing the string with NULL or an empty string would be better?

Silent truncation is really bad. If the currenty query length can be externally
influenced (and I have no doubt that it can), you may end up executing a
different statement than what was intended.

Return an error code from the function, abort() the entire program, or
something. But don't silently truncate.
