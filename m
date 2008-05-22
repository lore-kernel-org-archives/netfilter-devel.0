From: Anton <anton.vazir@gmail.com>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 15:00:35 +0500
Message-ID: <200805221500.35587.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DRUNI3UGauA1uSv"
Cc: Eric Leblond <eric@inl.fr>
To: Netfilter Mailinglist <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:50778 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760956AbYEVKAe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 06:00:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--Boundary-00=_DRUNI3UGauA1uSv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


> The attached patch should fix the memory leak issue.
> Could you test it ?

Accordingly to "top", it's still leaking.

We used modified libnfnetlink-0.0.33/utils/iftest.c 
(attached)

THe following compile line was used:
gcc -o  iftest  iftest.c  -lnetfilter_queue -lnfnetlink

-------------------------------------------------------

--Boundary-00=_DRUNI3UGauA1uSv
Content-Type: text/x-csrc;
  name="iftest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iftest.c"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include <libnfnetlink/libnfnetlink.h>

#include <signal.h>

static int TERM=0;

void sig_term(int s) {
 TERM=1;
}

int main() {
        int i;
        struct nlif_handle *h;

        signal(SIGTERM,sig_term);
        signal(SIGINT,sig_term);

         while(!TERM) {
            h = nlif_open();
            if (h == NULL) {
                perror("nlif_open");
                exit(EXIT_FAILURE);
            }

            nlif_query(h);
	    usleep(1000);
            nlif_close(h);
        }

        signal(SIGTERM,SIG_DFL);
        signal(SIGINT,SIG_DFL);

        puts("Bye");
}

--Boundary-00=_DRUNI3UGauA1uSv--
