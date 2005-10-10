From: Amin Azez <azez@ufomechanic.net>
Subject: Re: x_tables vs. nf-hipac
Date: Mon, 10 Oct 2005 14:47:59 +0100
Message-ID: <434A710F.2030303@ufomechanic.net>
References: <434A4B11.4030103@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <434A4B11.4030103@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Hi Harald,
> 
> you said that there is already some code for x_tables (is that
> pkttables, and if so, doesn't the new name collide with a spreadsheet
> layout program?). How does that relate to nf-hipac? Are they orthogonal
> to each other? Will both be merged into 2.6.$BIGNUM ? Which one is going
> to get in earlier?

I was also wondering this.
The rule structure and rapid update capability of nf-hipac looks very
attractive, it seems desirable to merge them in some way.

I while back someone elses posted a linked-list version of iptables that
also didn't require sending the whole rule structure to the kernel each
time, but nf-hipac seems to have additional optimisation in reducing the
number of repeated identical tests.

Sam
