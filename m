From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v4 1/2] nft_hash: define max_shift rhashtable parameter
Date: Tue, 24 Feb 2015 19:16:07 +0100
Message-ID: <54ECBFE7.1000103@iogearbox.net>
References: <1424801227-17320-1-git-send-email-johunt@akamai.com> <1424801227-17320-2-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Thomas Graf <tgraf@suug.ch>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1424801227-17320-2-git-send-email-johunt@akamai.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 02/24/2015 07:07 PM, Josh Hunt wrote:
> You must define a max_shift parameter to rhashtable or else the table cannot
> grow. This sets max_shift for nft_hash to 24, which will allow the table to
> grow to 2^24 or 16 million buckets.
>
> Acked-by: Thomas Graf <tgraf@suug.ch>
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

Thanks Josh!
