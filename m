From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Thu, 20 Apr 2006 21:34:22 +0200
Message-ID: <4447E23E.4090204@trash.net>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <beunlovable@gmail.com>
In-Reply-To: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
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

David Vogt wrote:
> Amin Azez has helped me with some trouble concerning the compilation
> of libnfnetlink.
> The --with-kernel parameter for the configure script did not work as
> intended, so Amin has proposed the following changes that 1) look for
> the kernel sources 2) recognise --with-kernel parameter.

Please change this to use --kernel as literal path as suggested
by Sven Koch.
