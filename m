From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [2/3] OSF: Kernel connector support.
Date: Wed, 1 Jun 2005 02:41:23 +0400
Message-ID: <20050601024123.6ac3d12d@zanzibar.2ka.mipt.ru>
References: <cede307105053115304d4d31c5@mail.gmail.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pavel A. Nekrasov" <pnekras@gmail.com>
In-Reply-To: <cede307105053115304d4d31c5@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 1 Jun 2005 00:30:04 +0200
"Pavel A. Nekrasov" <pnekras@gmail.com> wrote:

> hello!
> 
> > Kernel connector was commited into 2.6.12-rc4-mm tree.
> 
> To be honest, this creates a dependency against an experimental tree.
> Do you really  want to create such dependency?

It is under CONFIG_CONNECTOR define so it is fine, 
especially when connector will be slowly moved upstrem.

ULOG socket number usage is not the best thing to have.

> kind regards,
> Pavel


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
