From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] xml: json: Delete a cmpdata label in xml and
 json file.
Date: Mon, 14 Apr 2014 10:49:45 +0200
Message-ID: <20140414084945.GC6200@localhost>
References: <95c4de9cafead42b919ac07cca8d4f776ec3751b.1397033299.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47349 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaDNItz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:49:55 -0400
Content-Disposition: inline
In-Reply-To: <95c4de9cafead42b919ac07cca8d4f776ec3751b.1397033299.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 09, 2014 at 11:16:19AM +0200, Ana Rey wrote:
> It delete the cmpdata label in the structure of json and xml file.
> 
> Example of xmlfile:
> 
> The old structure of xml file:
> [...]
> <expr type="cmp">
> 	<sreg>1</sreg>
> 	<op>eq</op>
> 	<cmpdata>
> 		<data_reg type="value">
> 			<len>4</len>
> 			<data0>0x0100a8c0</data0>
> 		</data_reg>
> 	</cmpdata>
> </expr>
> 
> The new structure of json file:
> [...]
> <expr type="cmp">
> 	<sreg>1</sreg>
> 	<op>eq</op>
> 	<data_reg type="value">
> 		<len>4</len>
> 		<data0>0x0100a8c0</data0>
> 	</data_reg>
> </expr>
> [...]
> 
> To generate the new testfiles, It use the option -u of nft-parsing-test
> script.

Applied, thanks.
