From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [nft RFC PATCH] expression: print sets and maps in pretty format
Date: Wed, 26 Apr 2017 00:00:12 +0200
Message-ID: <CAAaDf4sLCNeR6re98yNOcrvi=6RkPKb-O9ROU+8F3ZyGhWjPUA@mail.gmail.com>
References: <149312374138.17592.11887464748028997707.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33243 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1955009AbdDYWAP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 18:00:15 -0400
Received: by mail-io0-f169.google.com with SMTP id k87so226516049ioi.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 15:00:14 -0700 (PDT)
In-Reply-To: <149312374138.17592.11887464748028997707.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-04-25 14:35 GMT+02:00 Arturo Borrero Gonzalez <arturo@debian.org>:
> Print elements per line instead of all in a single line.
> The elements which can be 'short' are printed 5 per line,
> and others, like IPv4 addresses are printed 2 per line.

The default terminfo tab size is 8. Why not align the first column of
elements for this case? It is only needed to replace the last tab of
"newline" with five spaces.

-       const char *newline = ",\n\t\t\t\t";
+       const char *newline = ",\n\t\t\t     ";
