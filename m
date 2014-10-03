From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/3] tests: add tests for the masq expression
Date: Fri, 3 Oct 2014 14:08:19 +0200
Message-ID: <20141003120819.GB10433@salvia>
References: <20141002115836.10972.3637.stgit@nfdev.cica.es>
 <20141002115842.10972.64243.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, anayrey@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44780 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaJCMHG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:07:06 -0400
Content-Disposition: inline
In-Reply-To: <20141002115842.10972.64243.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 02, 2014 at 01:58:42PM +0200, Arturo Borrero Gonzalez wrote:
> The masq expression is lacking of tests. Let's add some.

Applied, thanks.

Please, make sure git am doesn't complain with trailing whitespace and
empty lines at the end of the file.

git am reported two in this patch.

> diff --git a/tests/jsonfiles/68-rule-masq.json b/tests/jsonfiles/68-rule-masq.json
> new file mode 100644
> index 0000000..cfaed4c
> --- /dev/null
> +++ b/tests/jsonfiles/68-rule-masq.json
> @@ -0,0 +1,2 @@
> +{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"postrouting","handle":4,"expr":[{"type":"masq","flags":12}]}}]}
> +

Here.

> +++ b/tests/xmlfiles/79-rule-masq.xml
                       ^^

BTW, I wonder when the file numbering diverted (in xml, this 79 but in
json this is 68), it seems we have more tests for XML than json.

For similar mirror tests, we should be using the same number.
