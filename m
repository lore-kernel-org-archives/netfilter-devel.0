From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: 3 target treatment
Date: Wed, 5 Mar 2003 23:08:55 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303052308.55624.fabrice@netfilter.org>
References: <3E65B570.5DA3802D@ie.cuhk.edu.hk>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Ho <cbho@ie.cuhk.edu.hk>, netfilter-devel@lists.netfilter.org
In-Reply-To: <3E65B570.5DA3802D@ie.cuhk.edu.hk>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 05 March 2003 16:29, Philip Ho wrote:
> Dear all
> Can I possibly force some matched packet passing through three targets
> in a row, namely
> 1. update fragmentation field in IP header
> 2. update DSCP field
> 3. mark it (must be in mangle table)

Hello Philip,

Short answer: for the moment you cannot.

Longuer answer: but you can create a custom chain, where you do all of these.
The in the main table, you can jump in this chain if needed to perform
the three operations one shot. I would also prefer to be able
to do like you say, but it would be too much trouble modifying the
existing netfilter infrastructure in the kernel to suport that,
when you know that there are plan to replace the infrastructure
soon, to support linked list among other things.

You can have a look at the archive, we did mentions pros and cons
of implementing a system that would be able to do what you say.

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
