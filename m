From: "David S. Miller" <davem@redhat.com>
Subject: Re: [jorge@dti2.net: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up
 hang on one system]
Date: Wed, 12 Nov 2003 00:47:00 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031112004700.69796de6.davem@redhat.com>
References: <20031112083357.GA19776@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: marcelo.tosatti@cyclades.com.br, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20031112083357.GA19776@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 12 Nov 2003 09:33:57 +0100
Harald Welte <laforge@gnumonks.org> wrote:

> Since there is now a second bug report on that 'fix', I think it's
> better to back it out for 2.4.23.  The code has been without that 'fix'
> for the whole 2.4.x time, and it didn't seem to cause any real problem.
> 
> So rather than fixing the theoretical case, I'd say we keep the code
> like before (please revert the below patch) and make user complaints go
> away.
> 
> We'll try to investigate this further, but not before 2.4.23.

Ok, no problem.

Marcelo, you can revert this change in your tree simply by
running the following command:

	bk cset -x1.1063.41.4

Please do so, thanks everyone.

We can reinvestigate this in 2.4.24 if we figure out what was
wrong.
