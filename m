From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: rule: fix compat XML output
Date: Tue, 9 Apr 2013 21:49:00 +0200
Message-ID: <20130409194900.GB5544@localhost>
References: <20130408083502.9509.95918.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56799 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935710Ab3DITtI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:49:08 -0400
Content-Disposition: inline
In-Reply-To: <20130408083502.9509.95918.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, Apr 08, 2013 at 10:35:02AM +0200, Arturo Borrero wrote:
> The compat struct was not printed in XML. So, I think give output
> format is the first step to parse it.
> ---
>  src/rule.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 57b849d..e419b0a 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -445,11 +445,18 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
>  
>  	ret = snprintf(buf, size,
>  		"<rule family=\"%u\" table=\"%s\" "
> -			"chain=\"%s\" handle=\"%llu\"> ",
> +			"chain=\"%s\" handle=\"%llu\">\n ",
                                                      ^^^

We don't need the space after ">" and the \n and the extra formatting.

As example, check the output of conntrack in XML:

# conntrack -L -o xml
<?xml version="1.0" encoding="utf-8"?>
<conntrack>
<flow type="new"><meta direction="original"><layer3 protonum="2" protoname="ipv4"><src>77.209.70.77</src><dst>150.214.142.14</dst></layer3><layer4 protonum="1" protoname="icmp"></layer4></meta><meta direction="reply"><layer3 protonum="2" protoname="ipv4"><src>150.214.142.14</src><dst>77.209.70.77</dst></layer3><layer4 protonum="1" protoname="icmp"></layer4></meta><meta direction="independent"><timeout>30</timeout><id>830164440</id><unreplied/></meta></flow>
<flow type="update"><meta direction="original"><layer3 protonum="2" protoname="ipv4"><src>77.209.70.77</src><dst>150.214.142.14</dst></layer3><layer4 protonum="1" protoname="icmp"></layer4></meta><meta direction="reply"><layer3 protonum="2" protoname="ipv4"><src>150.214.142.14</src><dst>77.209.70.77</dst></layer3><layer4 protonum="1" protoname="icmp"></layer4></meta><meta direction="independent"><timeout>29</timeout><id>830164440</id></meta></flow>
</conntrack>

Note that every flow is expressed in one single line in XML.

Now do:

# conntrack -L -o xml > /tmp/x.xml

And have a look at some XML visualizer, eg:

$ firefox /tmp/x.xml

Does it clarify?
