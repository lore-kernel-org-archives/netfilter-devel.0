From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] set: xml: fix key_type parsing
Date: Thu, 5 Sep 2013 10:53:40 +0200
Message-ID: <20130905085340.GA4317@localhost>
References: <20130904160324.19268.79096.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42058 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468Ab3IEIxr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:53:47 -0400
Content-Disposition: inline
In-Reply-To: <20130904160324.19268.79096.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 04, 2013 at 06:03:25PM +0200, Arturo Borrero Gonzalez wrote:
> Bug introduced by myself at 44928cd5 [set: add XML parsing]

Applied.

Please, investigate why the json/xml test infrastructure did not catch
up this. Thanks.
