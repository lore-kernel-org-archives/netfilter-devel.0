From: Anton <anton.vazir@gmail.com>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 12:52:41 +0500
Message-ID: <200805221252.41392.anton.vazir@gmail.com>
References: <200805221053.41058.anton.vazir@gmail.com> <20080522074319.GD7436@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:39502 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbYEVHwi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 03:52:38 -0400
In-Reply-To: <20080522074319.GD7436@bayen.regit.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 22 May 2008 12:43, Eric Leblond wrote:
> Hello,
>
> On Thursday, 2008 May 22 at 10:53:40 +0500, Anton wrote:
> You should not call nlif_open, nlif_close at each
> resolution:

Yes, this is obvious, it was just a quick test.

>
> Information about nlif usage:
> http://software.inl.fr/trac/wiki/articles/using_nlif

Great, thanks!

>
> Anyway, I will investigate to see what's going on. We
> definitely should not have a memory leak.
>
> BR,
