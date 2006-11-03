From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/11] Remove ASSERT_{READ,WRITE}_LOCK
Date: Fri, 03 Nov 2006 13:25:22 +0100
Message-ID: <454B3532.9090701@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.306515682@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <20061101210914.306515682@wlug.westbo.se>
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

Martin Josefsson wrote:
> Remove the usage of ASSERT_READ_LOCK/ASSERT_WRITE_LOCK in x_tables and
> nf_conntrack, it didn't do anything, it was just an empty define and it
> uglified the code.

Fully agreed. I kept them mainly in case something similar would
show up for kernel-wide use, but it doesn't looks that way and
I stronly believe that readability helps a lot more to catch bugs.

BTW, the patch doesn't touch any x_tables files, did you forgot
to commit them?
