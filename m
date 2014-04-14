From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] xml: json: Delete an immediatedate label in xml
 and json file.
Date: Mon, 14 Apr 2014 10:49:55 +0200
Message-ID: <20140414084955.GD6200@localhost>
References: <8a18f44c02d37f6035ea2d14c6aeea28ebfa7a6e.1397033348.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47384 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaDNIuA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:50:00 -0400
Content-Disposition: inline
In-Reply-To: <8a18f44c02d37f6035ea2d14c6aeea28ebfa7a6e.1397033348.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 09, 2014 at 11:16:54AM +0200, Ana Rey wrote:
> It deletes the immediatedata label in the structure of json and xml file.
> 
> Example of the old structure of xmlfile:
> <nftables>
> 	<rule>
> 		<family>ip</family>
> 		<table>filter</table>
> 		<chain>input</chain>
> 		<handle>32</handle>
> 		<expr type="immediate">
> 			<dreg>0</dreg>
> 			<immediatedata>
> 				<data_reg type="verdict">
> 					<verdict>accept</verdict>
> 				</data_reg>
> 			</immediatedata>
> 		</expr>
> 	</rule>
> </nftables>
> 
> Example of the new structure of xmlfile:
> <nftables>
> 	<rule>
> 		<family>ip</family>
> 		<table>filter</table>
> 		<chain>input</chain>
> 		<handle>32</handle>
> 		<expr type="immediate">
> 			<dreg>0</dreg>
> 			<data_reg type="verdict">
> 				<verdict>accept</verdict>
> 			</data_reg>
> 		</expr>
> 	</rule>
> </nftables>
> 
> To generate the new testfiles, It use the option -u of nft-parsing-test
> script.

Also applied, thanks.
