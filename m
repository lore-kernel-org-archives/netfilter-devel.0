From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] log: print messages to stdout/sderr if
 running in console mode
Date: Thu, 27 Oct 2016 21:53:21 +0200
Message-ID: <20161027195321.GA4996@salvia>
References: <147756970023.18643.10864550353652488496.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932887AbcJ0TyW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 15:54:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 869DBB6C6E
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 21:53:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74DF9DA818
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 21:53:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40EDADA818
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 21:53:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147756970023.18643.10864550353652488496.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 27, 2016 at 02:01:40PM +0200, Arturo Borrero Gonzalez wrote:
> If conntrackd is running in console mode (i.e. in foreground)
> then we can print the log messages to stdout/stderr.
> 
> This eases the workflow for admins, since we condensate more info into
> the same terminal output.
> 
> Example:
> 
> % sudo conntrackd -C /etc/conntrackd.conf
> WARNING: XXXX is an invalid interface
> [Thu Oct 27 13:57:09 2016] (pid=7581) [notice] disabling internal cache
> [Thu Oct 27 13:57:09 2016] (pid=7581) [notice] disabling external cache
> [Thu Oct 27 13:57:09 2016] (pid=7581) [ERROR] can't open channel socket: No such device
> [Thu Oct 27 13:57:09 2016] (pid=7581) [ERROR] initialization failed
> ERROR: conntrackd cannot start, please check the logfile for more info

I'm fine with this. But I'm hitting compilation warnings here:

log.c: In function `logline_put':
log.c:93:23: warning: passing argument 3 of `vfprintf' from incompatible pointer type
  vfprintf(fd, format, args);
                       ^
In file included from ../include/log.h:4:0,
                 from log.c:21:
/usr/include/stdio.h:371:12: note: expected `struct __va_list_tag *'
but argument is of type `struct __va_list_tag (*)[1]'
 extern int vfprintf (FILE *__restrict __s, const char *__restrict __format,
            ^
log.c: In function `dlog':
log.c:117:46: warning: passing argument 4 of `logline_put' from incompatible pointer type
   logline_put(console_out, priority, format, args);
                                              ^
log.c:63:13: note: expected `struct __va_list_tag (*)[1]' but argument is of type `struct __va_list_tag *'
 static void logline_put(FILE *fd, int priority, const char *format,
             ^
log.c:123:37: warning: passing argument 4 of `logline_put' from incompatible pointer type
   logline_put(fd, priority, format, args);
                                     ^
log.c:63:13: note: expected `struct __va_list_tag (*)[1]' but argument is of type `struct __va_list_tag *'
 static void logline_put(FILE *fd, int priority, const char *format,

$ gcc -v
[...]
gcc version 4.9.2 (Debian 4.9.2-10) 
