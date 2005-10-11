From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Tue, 11 Oct 2005 10:12:34 +0100
Message-ID: <434B8202.9020703@ufomechanic.net>
References: <1128536584.9868.1.camel@localhost.localdomain>
	<20051007034224.GB5953@rama>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20051007034224.GB5953@rama>
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

Harald Welte wrote:
> JFYI, here's an incremental (yet untested) patch that adds support to
> reinitialize the random seed when reisizing

Just for my own education, why is the seed random?
Doe this mean that we randonly get a "bad" seed?

It just reminds me of the story at:
http://www.karrels.org/Ed/ACM/ec97/prob_5.html

and random things in the kernel smells like hard to reproduce errors.
Of course, possibly we don't actually mean "random" here, hence my
desire for er... enlightenment.

Sam
