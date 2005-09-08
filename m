From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Fri, 09 Sep 2005 00:54:03 +0200
Message-ID: <4320C10B.6000306@eurodev.net>
References: <61424.192.35.17.21.1126184669.squirrel@mail.piranho.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henning Peters <hpeters@math.uni-goettingen.de>
In-Reply-To: <61424.192.35.17.21.1126184669.squirrel@mail.piranho.net>
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

Henning Peters wrote:
> This software is being written in c++. I want to avoid using the
> command-line to talk to iptables for efficiency. Including iptables
> headers and linking to libiptables seemed reasonable for me. But compiling
> with g++ (gcc version 3.3.4 (pre 3.3.5 20040809)) and linking to the
> c-libs (extern "C" stuff) gave me a compile error:

Two comments:

a) The internal library used by iptables (libiptc) is undocumented and
its use is discouraged.
b) iptables is entirely written in C, linking libiptc to C++ code isn't
a good a idea.

So, you should call iptables via system(). It isn't great but you'll
have less problems.

--
Pablo
