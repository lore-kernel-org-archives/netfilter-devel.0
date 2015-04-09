From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 05/20] netfilter: nft_hash: add support for timeouts
Date: Thu, 9 Apr 2015 13:39:18 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CB17C7C@AcuExch.aculab.com>
References: <1428579304-5520-1-git-send-email-pablo@netfilter.org>
 <1428579304-5520-6-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
To: 'Pablo Neira Ayuso' <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1428579304-5520-6-git-send-email-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso
> Sent: 09 April 2015 12:35
...
> Add support for element timeouts to nft_hash. The lookup and walking
> functions are changed to ignore timed out elements, a periodic garbage
> collection task cleans out expired entries.

You probably want to delete timed out entries during insert.
If you do that you don't really need a garbage collector.

I'd also worry about re-adding a timed out entry.

	David
