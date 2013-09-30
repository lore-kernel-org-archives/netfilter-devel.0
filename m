From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [libnftables PATCH 2/3] table: json: fix json style
Date: Mon, 30 Sep 2013 11:06:44 -0700
Message-ID: <20130930110644.07aa64c1@nehalam.linuxnetplumber.net>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
	<20130930150557.32124.88117.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64814 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3I3SGu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:06:50 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so5996425pdj.36
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 11:06:50 -0700 (PDT)
In-Reply-To: <20130930150557.32124.88117.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 30 Sep 2013 17:05:57 +0200
Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:

> Be consistent in JSON style.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

All the effort to format and add whitespace in JSON is not that important
since it is intended to be parsed by something, and parsers ignore it.
Many applications just use as little whitespace as possible to reduce size
of output!
