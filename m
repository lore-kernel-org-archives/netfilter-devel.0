From: Amin Azez <azez@ufomechanic.net>
Subject: dangerous? Setting mark in nat table
Date: Tue, 13 Mar 2007 15:25:25 +0000
Message-ID: <et6fp4$l04$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I want need to set a mark (-j MARK) in the nat table based on dnat'ing done.

This means changing the ipt_mark kernel module, at least for my own
consumption.

Are there any overpowering reasons why I should not do this, or even why
it should not be done at all?

I have powerful reasons which finally centre on the fact that the mark
is too small to use as as means of joining condition fragments spread
over different places.

(Is this also a good time to bring up why mangle and filter should not
be merged?)

Sam
