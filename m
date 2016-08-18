From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] xtables-translate: add escape_quotes option
 to comment_xlate
Date: Thu, 18 Aug 2016 18:10:21 +0200
Message-ID: <20160818161021.GA1018@salvia>
References: <20160816174433.28272-1-pablombg@gmail.com>
 <20160817142317.GA9755@salvia>
 <CAAaDf4vWgD74bME7fBjErHud6zV0=tWrOf6ouNe_GHiEUFYU+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45472 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755081AbcHSIRn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 04:17:43 -0400
Content-Disposition: inline
In-Reply-To: <CAAaDf4vWgD74bME7fBjErHud6zV0=tWrOf6ouNe_GHiEUFYU+Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 18, 2016 at 05:59:30PM +0200, Pablo M. Bermudo Garay wrote:
> 2016-08-17 16:23 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Tue, Aug 16, 2016 at 07:44:32PM +0200, Pablo M. Bermudo Garay wrote:
> >> The comment_xlate function was not supporting this option that is
> >> necessary in some situations.
> >
> > I have applied what I'm attaching to this email, that is more simple
> > than this and makes sure buffer is nul-terminated (given snprintf
> > doesn't guarantee this).
> 
> Ok, the simplification seems great. But AFAIK both standards (C99+ and
> POSIX.1-2001+) guarantee that the string will be null-terminated. Am I
> wrong about that?

If you write as many bytes as you can fit into the buffer, then
snprintf doesn't guarantee a nul-terminated string.
