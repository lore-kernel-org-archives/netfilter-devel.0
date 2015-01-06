From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] doc: add a reference to the wiki page in the man page
Date: Tue, 6 Jan 2015 22:20:26 +0100
Message-ID: <20150106212026.GA5972@salvia>
References: <20141230151112.14860.37311.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jidanni@jidanni.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57929 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbAFVRt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:17:49 -0500
Content-Disposition: inline
In-Reply-To: <20141230151112.14860.37311.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 30, 2014 at 04:11:13PM +0100, Arturo Borrero Gonzalez wrote:
> Let's add a pointer in the man page to the wiki page.
> 
> Requested-by: Dan Jacobson <jidanni@jidanni.org>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  doc/nft.xml |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/doc/nft.xml b/doc/nft.xml
> index e45a593..7998008 100644
> --- a/doc/nft.xml
> +++ b/doc/nft.xml
> @@ -2202,6 +2202,13 @@ filter output oif wlan0
>  	</refsect1>
>  
>  	<refsect1>
> +		<title>Further reading</title>
> +		<para>
> +			There is an official wiki at: http://wiki.nftables.org
> +		</para>
> +	</refsect1>

Could you include this in SEE ALSO instead as in the iptables manpage?
Thanks.

> +
> +	<refsect1>
>  		<title>See Also</title>
>  		<para>
>  			<simplelist type="inline">
> 
